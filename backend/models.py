import logging

## Modelo 1 - Descripción textual de imágenes

# Este modelo requiere una clave API de replicate.com. Ponerla en el archivo tokens.py.
# El modelo se usa sólo para pruebas y la app no lo utiliza, de forma que si no tenemos la clave no pasa nada.

try:
    import replicate
    import tokens
    import os
    os.environ['REPLICATE_API_TOKEN'] = tokens.REPLICATE_API_TOKEN
  
    model = replicate.models.get('methexis-inc/img2prompt')
    img2txt = model.versions.get('50adaf2d3ad20a6f911a8a9e3ccf777b263b8596fbd2c8fc26e8888f8a0edbb5')

    def img2txt_model(image_path):
        return img2txt.predict(image=open(image_path, 'rb'))

    logging.info("[Fase 1 - Modelo img2txt] Modelo cargado.")

except ImportError:
    logging.warn("[Fase 1 - Modelo img2txt] No se ha encontrado el archivo tokens.py con la clave API. El modelo no se podrá ejecutar.")


## Modelo 2 - Transferencia de estilo artístico

import tensorflow as tf
import tensorflow_hub as hub
import numpy as np
import PIL.Image
import random

blend = hub.load('https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/1')

def load_image(path_to_img):
    max_dim = 512
    img = tf.io.read_file(path_to_img)
    img = tf.image.decode_image(img, channels=3)
    img = tf.image.convert_image_dtype(img, tf.float32)

    shape = tf.cast(tf.shape(img)[:-1], tf.float32)
    long_dim = max(shape)
    scale = max_dim / long_dim

    new_shape = tf.cast(shape * scale, tf.int32)

    img = tf.image.resize(img, new_shape)
    img = img[tf.newaxis, :]
    
    return img

def tensor_to_image(tensor):
    tensor = tensor*255
    tensor = np.array(tensor, dtype=np.uint8)
    if np.ndim(tensor)>3:
        assert tensor.shape[0] == 1
        tensor = tensor[0]
    return PIL.Image.fromarray(tensor)

def blend_images_model(content_path, style_path):
    stylized_image = blend(tf.constant(load_image(content_path)), tf.constant(load_image(style_path)))[0]
    return tensor_to_image(stylized_image)

def blend_style_model(content_path, style_name):    
    style_path = f"paintings/{style_name}/{style_name}{random.randint(1,5)}.jpg"
    stylized_image = blend(tf.constant(load_image(content_path)), tf.constant(load_image(style_path)))[0]
    return tensor_to_image(stylized_image)

## Modelo 3 - Detección de estilo artístico

import tensorflow as tf
from tensorflow import keras
import cv2
import matplotlib.pyplot as plt
import numpy as np

# Carga del modelo
model = tf.keras.models.load_model("models/VGG16/VGG16model_10epochs")

def detect_style_model(image_path):
    img = cv2.imread(image_path)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    plt.imshow(img)
    img = cv2.resize(img,(224,224))     # resize image to match model's expected sizing
    img = np.reshape(img,[1,224,224,3]) # return the image with shaping that TF wants.
    prediction = model.predict(img).tolist()
    best_guess = max(prediction)
    best_guess_index = prediction.index(best_guess)
    styles = ['abstract', 'color_field_painting', 'cubism', 'expressionism',
        'impressionism', 'realism', 'renaissance', 'romanticism']
    return styles[best_guess_index]