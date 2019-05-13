import cv2
import numpy as np

src = cv2.imread("bug-2.png")
src_gray = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)

src_256 = np.where(src_gray==255, 255, 9).astype(np.uint8)

outputFile = open("bug2_image.bin", "wb")
outputFile.write(bytearray(src_256))
outputFile.close()