## Modelo 1 - Descripción textual de imágenes

import os
import random
import replicate
import tokens
from skimage import io

# Configurar modelo
os.environ['REPLICATE_API_TOKEN'] = tokens.REPLICATE_API_TOKEN
model = replicate.models.get('methexis-inc/img2prompt')
img2txt = model.versions.get('50adaf2d3ad20a6f911a8a9e3ccf777b263b8596fbd2c8fc26e8888f8a0edbb5')

def img2txt(image):
    img2txt.predict(image=open("images/minigato.jpg", 'rb'))

## Modelo 2 - Transferencia de estilo artístico

import tensorflow as tf
import tensorflow_hub as hub
import numpy as np
import PIL.Image
import time
import functools

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
    # TODO renombrar archivos
    style_path = f"paintings/{style_name}/{style_name}{random.randInt(1,6)}.jpg"
    stylized_image = blend(tf.constant(load_image(content_path)), tf.constant(load_image(style_path)))[0]
    return tensor_to_image(stylized_image)