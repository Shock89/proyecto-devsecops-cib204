// config.js - Configuracion del servicio (version corregida).
// Los secretos se leen del entorno; nunca se versionan.
const config = {
  JWT_SECRET: process.env.JWT_SECRET,
  DATABASE_URL: process.env.DATABASE_URL,
  AUTH_ENABLED: process.env.AUTH_ENABLED === 'true',
  KEYCLOAK_URL: process.env.KEYCLOAK_URL || 'http://localhost:8080',
  KEYCLOAK_REALM: process.env.KEYCLOAK_REALM || 'appmovil',
  ORIGEN_PERMITIDO: process.env.ORIGEN_PERMITIDO || 'http://localhost:8081',
  PUERTO: process.env.PORT || 3000,
};
module.exports = config;
