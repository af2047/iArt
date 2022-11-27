# Backend

El backend del proyecto se va a implementar en Python, y consiste en:

* una API REST elaborada con FastAPI, que gestiona el acceso a todas las funciones de la aplicación
* un servidor web (uvicorn)
* una base de datos SQLite

Está almacenado en DigitalOcean.

* Firewall activo, abrir el puerto con `ufw allow 8000/tcp` para poder acceder a estos enlaces desde fuera
* API: [134.209.89.62:8000]
* Documentación autogenerada: [http://134.209.89.62:8000/docs]