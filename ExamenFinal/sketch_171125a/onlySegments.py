#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  1 14:53:20 2017

@author: leonvillapun
"""

import cv2

img = cv2.imread('3.jpg')

for i in range(0, len(img)):
    for j in range(0, len(img[0])):
        if(img[i][j][:] == [255,0,0]):
            continue
        else:
            img[i][j] = 0
            
            
cv2.imwrite('onlySegments.jpg',img)