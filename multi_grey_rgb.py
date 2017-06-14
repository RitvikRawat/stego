from scipy import misc
import sys
from PIL import Image
from numpy import eye

for img_no in range(0,59999):
	print img_no
	f = misc.imread('/home/raw/Desktop/3rd_summer/converter/grey/collected/%d.png' % img_no)
	im = Image.fromarray(f).convert('RGB')
	misc.imsave('/home/raw/Desktop/3rd_summer/converter/grey/db/%d.png' % img_no, im)