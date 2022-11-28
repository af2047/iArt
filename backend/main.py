from fastapi import FastAPI, File, UploadFile
import os
import replicate

app = FastAPI()



# Configurar modelo
os.environ['REPLICATE_API_TOKEN'] = '1d00c4a2874d2acdf17b8092205ee974142f6763'
model = replicate.models.get('methexis-inc/img2prompt')
version = model.versions.get('50adaf2d3ad20a6f911a8a9e3ccf777b263b8596fbd2c8fc26e8888f8a0edbb5')

@app.get("/")
async def root():
    return {"message": "Hola mundo"}

@app.post("/img2txt/")
async def create_upload_file(file: UploadFile):
    try:
        contents = file.file.read()
        with open(file.filename, 'wb') as f:
            f.write(contents)
    except Exception:
        return {"message": "There was an error uploading the file"}
    finally:
        file.file.close()

    output = version.predict(image=open("minigato.jpg", 'rb'))

    return {"message": f"Successfully uploaded {file.filename}",
    "output": output}