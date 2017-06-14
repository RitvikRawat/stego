from scipy import misc
import sys
from PIL import Image
from numpy import eye
# face = misc.face()
# misc.imsave('face.png', face)

image_to_open = str(sys.argv[1])
image_to_save = str(sys.argv[2])

print image_to_open

# f = misc.imread('0000_depth.png')
f = misc.imread(image_to_open)
print type(f)      
print f.shape, f.dtype

im = Image.fromarray(f).convert('RGB')

misc.imsave(image_to_save, im)

import matplotlib.pyplot as plt
plt.imshow(im)
plt.show()