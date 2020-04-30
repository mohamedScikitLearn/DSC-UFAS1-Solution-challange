from keras import backend as K
from keras.preprocessing.image import ImageDataGenerator,load_img, img_to_array
from keras.models import Sequential, Model
from keras.layers import Conv2D, MaxPooling2D,GlobalAveragePooling2D
from keras.layers import Activation, Dropout, BatchNormalization, Flatten, Dense

from keras.models import Sequential, Model
#rom keras.applications.xception import Xception
#from keras.applications.resnet50 import ResNet50
from keras.applications.vgg16 import VGG16, preprocess_input
from keras.optimizers import Adam, SGD, RMSprop

# Classifier = Sequential()
# Classifier.add(Conv2D(80, (3, 3), input_shape=INPUT_SHAPE))
# Classifier.add(Activation('relu'))
# Classifier.add(MaxPooling2D(pool_size=(2, 2)))
# Classifier.add(Dropout(0.2))

# Classifier.add(Conv2D(64, (3, 3)))
# Classifier.add(Activation('relu'))
# Classifier.add(MaxPooling2D(pool_size=(2, 2)))
# Classifier.add(Dropout(0.5))

# Classifier.add(Conv2D(64, (3, 3)))
# Classifier.add(Activation('relu'))


# Classifier.add(Conv2D(80, (3, 3)))

# Classifier.add(Activation('relu'))
# Classifier.add(MaxPooling2D(pool_size=(2, 2)))

# Classifier.add(Flatten())
# Classifier.add(Dense(64))
# Classifier.add(Activation('relu'))
# Classifier.add(Dropout(0.5))

Classifier.add(Dense(3))
Classifier.add(Activation('softmax'))
Classifier.compile(loss='categorical_crossentropy',
          optimizer='adam',
          metrics=['accuracy'])
