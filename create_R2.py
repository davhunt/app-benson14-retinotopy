#!/usr/bin/env python

import numpy as np
import nibabel as nib
import nibabel.freesurfer.io as fsio
import os
import sys

def create_R2(in_vol, in_rh_surf, in_lh_surf):
  
  img = nib.load(in_vol)
  data = img.get_fdata()

  # set all visual areas 1 through 12 to 1.0  
  for i in range(data.shape[0]):
    for j in range(data.shape[1]):
      for k in range(data.shape[2]):
        if data[i,j,k] > 0.0:
          data[i,j,k] = 1.0
  out_vol = nib.Nifti1Image(data, img.affine)
  nib.save(out_vol, os.path.join(os.getcwd(),'prf','r2.nii.gz'))

  data = fsio.read_morph_data(in_rh_surf)
  for i in range(data.shape[0]):
    if data[i] > 0.0:
      data[i] = 1.0
  fsio.write_morph_data(os.path.join(os.getcwd(),'prf','prf_surfaces','rh.r2'),data)

  data = fsio.read_morph_data(in_lh_surf)
  for i in range(data.shape[0]):
    if data[i] > 0.0:
      data[i] = 1.0
  fsio.write_morph_data(os.path.join(os.getcwd(),'prf','prf_surfaces','lh.r2'),data)


if __name__ == '__main__':
  create_R2(sys.argv[1], sys.argv[2], sys.argv[3])
