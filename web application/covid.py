#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  2 14:57:01 2020

@author: Mohamed BERRIMI
"""

 
## Dependecies
from __future__ import division, print_function
import os
import argparse
import numpy as np

#Image 
import tensorflow
import cv2
from sklearn.preprocessing import normalize

# Keras
from keras import backend as K
from tensorflow.keras.preprocessing.image import ImageDataGenerator,load_img, img_to_array
from tensorflow.keras.models import Sequential, Model
import Classifier
from tensorflow.keras.layers import Conv2D, MaxPooling2D,GlobalAveragePooling2D
from tensorflow.keras.layers import Activation, Dropout, BatchNormalization, Flatten, Dense

from tensorflow.keras.optimizers import Adam, SGD, RMSprop

 
import os
import numpy as np
 
# Flask utils

from gevent.pywsgi import WSGIServer
from werkzeug.utils import secure_filename
from flask import Flask, redirect, url_for, request, render_template

# Config 

parser = argparse.ArgumentParser()
parser.add_argument("-w1", "--width", help="Target Image Width", type=int, default=224)
parser.add_argument("-h1", "--height", help="Target Image Height", type=int, default=224)
parser.add_argument("-c1", "--channel", help="Target Image Channel", type=int, default=3)

parser.add_argument("-p", "--path", help="Best Model Location Path", type=str, default="model/Classifier.h5")
parser.add_argument("-s", "--save", help="Save Uploaded Image", type=bool, default=False)

parser.add_argument("--port", help="WSGIServer Port ID", type=int, default=5008)
args = parser.parse_args()

SHAPE              = (args.width, args.height, 3)
MODEL_SAVE_PATH    = args.path
SAVE_LOADED_IMAGES = args.save

# Metrics

def recall(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    possible_positives = K.sum(K.round(K.clip(y_true, 0, 1)))
    recall = true_positives / (possible_positives + K.epsilon())
    return recall

def precision(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    predicted_positives = K.sum(K.round(K.clip(y_pred, 0, 1)))
    precision = true_positives / (predicted_positives + K.epsilon())
    return precision

def f1(y_true, y_pred):
    precisionx = precision(y_true, y_pred)
    recallx = recall(y_true, y_pred)
    return 2*((precisionx*recallx)/(precisionx+recallx+K.epsilon()))

 
def create_model():
    IMG_W = 224
    IMG_H = 224
    CHANNELS = 3
    
    INPUT_SHAPE = (IMG_W, IMG_H, CHANNELS)
     
    
    
    Classifier = Sequential()
    Classifier.add(Conv2D(80, (3, 3), input_shape=INPUT_SHAPE))
    Classifier.add(Activation('relu'))
    Classifier.add(MaxPooling2D(pool_size=(2, 2)))
    Classifier.add(Dropout(0.2))
    
    Classifier.add(Conv2D(64, (3, 3)))
    Classifier.add(Activation('relu'))
    Classifier.add(MaxPooling2D(pool_size=(2, 2)))
    Classifier.add(Dropout(0.5))
    
    Classifier.add(Conv2D(64, (3, 3)))
    Classifier.add(Activation('relu'))
    
    
    Classifier.add(Conv2D(80, (3, 3)))
    
    Classifier.add(Activation('relu'))
    Classifier.add(MaxPooling2D(pool_size=(2, 2)))
    
    Classifier.add(Flatten())
    Classifier.add(Dense(64))
    Classifier.add(Activation('relu'))
    Classifier.add(Dropout(0.5))
    
    Classifier.add(Dense(3))
    Classifier.add(Activation('softmax'))
    Classifier.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])

    
    return Classifier

model = create_model()
#print(model.summary())
model.load_weights(MODEL_SAVE_PATH)
print('Model loaded. Check 35.205.82.119:{}/'.format(args.port))


def model_predict(img_path, model):
  
    img = np.array(cv2.imread(img_path))
   
    img = cv2.resize(img, (224,224))
    print (img.shape)
     
    
    prediction = model.predict(np.expand_dims(img, axis=0), batch_size=1)
    
    return prediction

# Threshold predictions
def threshold_arr(array):
    new_arr = []
    for ix, val in enumerate(array):
        loc = np.array(val).argmax(axis=0)
        k = list(np.zeros((len(val)), dtype=np.float16))
        k[loc]=1
        new_arr.append(k)
        
    return np.array(new_arr, dtype=np.float16)


os.chdir("deploy/")
# Define a flask app
app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    # Main page
    return render_template('home.html')

@app.route('/predictCovid', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        # Get the file from post request
        f = request.files['file']

        # Save the file to ./uploads
        basepath = os.path.dirname(__file__)
        file_path = os.path.join(
            basepath, 'uploads', secure_filename(f.filename))
        f.save(file_path)
 # Make prediction
        preds = model_predict(file_path, model)
    
        pred_class = threshold_arr(preds)[0]
        
        if pred_class[0] == 1:
            result = " This scan shows Covid-19 infection  "
        elif pred_class[1] == 1:
           result = " NORMAL This scan shows no Infection "
           
        elif pred_class[2] == 1:
            result = " This scan show Pneumonia infection  "
        
        
        if not SAVE_LOADED_IMAGES:
        	os.remove(file_path)
       

        return result
    return None

if __name__ == '__main__':
    http_server = WSGIServer(('', args.port), app)
    http_server.serve_forever()
