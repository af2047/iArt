Los certificados HTTPS son de pago, a excepción de Let's Encrypt, que requiere un nombre de dominio.

1. Obtener un dominio gratuito .tk
2. Instalar certbot (herramienta de la EFF que autogestiona el certificado) con `sudo snap install --classic certbot`
3. En el servidor, ejecutar `certbot certonly --standalone`