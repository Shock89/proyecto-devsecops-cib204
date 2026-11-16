// auth.js - Valida el JWT de Keycloak: firma contra JWKS y solo RS256.
const { expressjwt } = require('express-jwt');
const jwksRsa = require('jwks-rsa');
const config = require('./config');

const validarToken = expressjwt({
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksUri: `${config.KEYCLOAK_URL}/realms/${config.KEYCLOAK_REALM}/protocol/openid-connect/certs`,
  }),
  algorithms: ['RS256'],
});

function requiereAuth(req, res, next) {
  if (!config.AUTH_ENABLED) return next();
  validarToken(req, res, (err) => {
    if (err) return res.status(401).json({ error: 'No autorizado' });
    req.usuario = req.auth;
    return next();
  });
}

module.exports = { requiereAuth };
