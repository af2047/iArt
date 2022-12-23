from fastapi import FastAPI, Response, UploadFile
from fastapi.responses import FileResponse
import logging

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

    output = models.img2txt_model(file.filename)
    #output = models.img2txt_model(image=open(file.filename, 'rb'))

    return {"message": f"Successfully uploaded {file.filename}",
    "output": output}

@app.post("/blend_images/")
async def blend_images(content_image: UploadFile, style_image: UploadFile):
    try:
        content = await content_image.read()
        with open(content_image.filename, 'wb') as f:
            f.write(content)
        style = await style_image.read()
        with open(style_image.filename, 'wb') as f:
            f.write(style)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        content_image.file.close()
        style_image.file.close()

    output = models.blend_images_model(content_image.filename, style_image.filename)
    output.save("bop.jpg")

    return FileResponse("bop.jpg")

@app.post("/blend_image_with_{style}")
async def blend_image_with_style(content_image: UploadFile, style):
    try:
        content = await content_image.read()
        with open(content_image.filename, 'wb') as f:
            f.write(content)
    except Exception:
        return {"message": "La imagen no se ha podido cargar."}
    finally:
        content_image.file.close()

    output = models.blend_style_model(content_image.filename, style)
    output.save("bop.jpg")

    return FileResponse("bop.jpg")