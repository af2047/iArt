from fastapi import FastAPI, UploadFile, File
import logging
import tokens

logging.basicConfig(level=logging.INFO)
logging.info(
"""
 _               _   
(_)   /\        | |  
 _   /  \   _ __| |_ 
| | / /\ \ | '__| __|
| |/ ____ \| |  | |_ 
|_/_/    \_\_|   \__|
""")

logging.info("[Fase 1] Cargando modelos...")

try:
    import models
except KeyboardInterrupt:
    logging.info("[Fase 1] Proceso detenido.")
    exit()
except Exception as e:
    logging.error("[Fase 1] Error en la carga de modelos.")
    print(e)
    exit()

logging.info("[Fase 1] Carga de modelos completada.")                      

logging.info("[Fase 2] Iniciando servidor...")     

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hola mundo"}

@app.post("/img2txt/")
async def img2txt(file: UploadFile):
    try:
        contents = await file.read()
        with open(file.filename, 'wb') as f:
            f.write(contents)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        file.file.close()

    output = models.img2txt.predict(image=open("minigato.jpg", 'rb'))

    return {"message": f"Successfully uploaded {file.filename}",
    "output": output}