# Versión 3.10 porque Tensorflow no es compatible todavía con 3.11
FROM python:3.10.9-bullseye

COPY backend/ .

RUN python -m pip install replicate fastapi uvicorn python-multipart opencv-python-headless tensorflow_hub Pillow numpy matplotlib tensorflow 
RUN chmod 777 run_server.sh

CMD ["sh", "run_server.sh", "prod"]
