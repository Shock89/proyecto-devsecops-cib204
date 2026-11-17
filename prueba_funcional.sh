#!/bin/bash
# Prueba funcional end-to-end (secciones 7 a 12 de la guia)
cd /workspaces/proyecto-devsecops-cib204
L=docs/evidencia_funcional.log; : > $L
say(){ echo "$@" | tee -a $L; }
docker compose up -d --build >/dev/null 2>&1
until curl -s -o /dev/null http://localhost:8080/realms/master; do sleep 3; done
K="docker exec keycloak /opt/keycloak/bin/kcadm.sh"
$K config credentials --server http://localhost:8080 --realm master --user admin --password admin >/dev/null 2>&1
$K create realms -s realm=appmovil -s enabled=true >/dev/null 2>&1
$K create clients -r appmovil -s clientId=servicio-cifrado -s publicClient=true -s directAccessGrantsEnabled=true -s enabled=true >/dev/null 2>&1
$K create users -r appmovil -s username=demo -s enabled=true -s email=demo@ejemplo.com -s firstName=Demo -s lastName=Usuario -s emailVerified=true >/dev/null 2>&1
$K set-password -r appmovil --username demo --new-password demo123 >/dev/null 2>&1
sleep 5
U=http://localhost:3000
T=$(curl -s -X POST http://localhost:8080/realms/appmovil/protocol/openid-connect/token -d grant_type=password -d client_id=servicio-cifrado -d username=demo -d password=demo123 | python3 -c 'import json,sys;print(json.load(sys.stdin).get("access_token",""))')
say "token Keycloak obtenido: longitud ${#T}"
H='Content-Type: application/json'
say "T1 GET /salud ........................ $(curl -s $U/salud)"
say "T2 POST /cifrar SIN token ............ HTTP $(curl -s -o /dev/null -w '%{http_code}' -X POST $U/cifrar -H "$H" -d '{"texto":"hola"}')"
C=$(curl -s -X POST $U/cifrar -H "$H" -H "Authorization: Bearer $T" -d '{"texto":"Cifrado OK CIB-204"}')
say "T3 POST /cifrar CON token ............ HTTP $(curl -s -o /dev/null -w '%{http_code}' -X POST $U/cifrar -H "$H" -H "Authorization: Bearer $T" -d '{"texto":"x"}') $(echo $C | cut -c1-40)..."
CT=$(echo $C | python3 -c 'import json,sys;print(json.load(sys.stdin).get("cifrado",""))')
say "T4 POST /descifrar CON token ......... $(curl -s -X POST $U/descifrar -H "$H" -H "Authorization: Bearer $T" -d "{\"cifrado\":\"$CT\"}")"
say "T5 /descifrar dato manipulado ........ HTTP $(curl -s -o /dev/null -w '%{http_code}' -X POST $U/descifrar -H "$H" -H "Authorization: Bearer $T" -d '{"cifrado":"AAAA"}')"
say "T6 /cifrar texto de 500 caracteres ... HTTP $(curl -s -o /dev/null -w '%{http_code}' -X POST $U/cifrar -H "$H" -H "Authorization: Bearer $T" -d "{\"texto\":\"$(head -c 500 /dev/zero | tr '\0' a)\"}")"
bash pentest.sh 3000 2>&1 | tee -a $L
say "--- contenedor corre como: $(docker exec cifrado id -un)"
say "--- fin ---"
