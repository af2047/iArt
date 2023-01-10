from fastapi import FastAPI, UploadFile
from fastapi.responses import FileResponse
import logging
import random

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
        with open(f"temp_images/{file.filename}", 'wb') as f:
            f.write(contents)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        file.file.close()

    output = models.img2txt_model(f"temp_images/{file.filename}")

    return {"description": output}

@app.post("/blend_images/")
async def blend_images(content_image: UploadFile, style_image: UploadFile):
    try:
        content = await content_image.read()
        with open(f"temp_images/{content_image.filename}", 'wb') as f:
            f.write(content)
        style = await style_image.read()
        with open(f"temp_images/{style_image.filename}", 'wb') as f:
            f.write(style)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        content_image.file.close()
        style_image.file.close()

    output = models.blend_images_model(f"temp_images/{content_image.filename}", f"temp_images/{style_image.filename}")
    outputPath = f"temp_images/blend_images_result{random.randint(1, 1e12)}.jpg"
    output.save(outputPath)

    return FileResponse(outputPath)

@app.post("/blend_image_with_{style}/")
async def blend_image_with_style(content_image: UploadFile, style):
    try:
        content = await content_image.read()
        with open(f"temp_images/{content_image.filename}", 'wb') as f:
            f.write(content)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        content_image.file.close()

    output = models.blend_style_model(f"temp_images/{content_image.filename}", style)
    outputPath = f"temp_images/blend_image_with_{style}_result{random.randint(1, 1e12)}.jpg"
    output.save(outputPath)

    return FileResponse(outputPath)

@app.post("/detect_style/")
async def detect_style(content_image: UploadFile):
    try:
        content = await content_image.read()
        with open(f"temp_images/{content_image.filename}", 'wb') as f:
            f.write(content)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        content_image.file.close()

    output = models.detect_style_model(f"temp_images/{content_image.filename}")

    return {"description": output}