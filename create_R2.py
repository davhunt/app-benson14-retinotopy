#!/usr/bin/python

import numpy as np
import nibabel as nib
import os
import sys

def create_R2(in_img):
  
  img = nib.load(in_img)
  data = img.get_fdata()

  # set all visual areas 1 through 12 to 1.0  
  for i in range(data.shape[0]):
    for j in range(data.shape[1]):
      for k in range(data.shape[2]):
        if data[i,j,k] > 0.0:
          data[i,j,k] = 1.0
  
  img_out = nib.Nifti1Image(data, img.affine)
  nib.save(img_out, os.path.join(os.getcwd(),'prf','r2.nii.gz'))

if __name__ == '__main__':
  create_R2(sys.argv[1])
