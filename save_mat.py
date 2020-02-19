#!/usr/bin/env python

import numpy as np
import nibabel as nib
import nibabel.freesurfer.io as fsio
import scipy.io as sio

rh_eccentricity = fsio.read_morph_data('./prf/prf_surfaces/rh.eccentricity')
rh_rfWidth = fsio.read_morph_data('./prf/prf_surfaces/rh.rfWidth')
rh_polarAngle = fsio.read_morph_data('./prf/prf_surfaces/rh.polarAngle')
rh_varea = fsio.read_morph_data('./prf/prf_surfaces/rh.varea')
rh_r2 = fsio.read_morph_data('./prf/prf_surfaces/rh.r2')
lh_eccentricity = fsio.read_morph_data('./prf/prf_surfaces/lh.eccentricity')
lh_rfWidth = fsio.read_morph_data('./prf/prf_surfaces/lh.rfWidth')
lh_polarAngle = fsio.read_morph_data('./prf/prf_surfaces/lh.polarAngle')
lh_varea = fsio.read_morph_data('./prf/prf_surfaces/lh.varea')
lh_r2 = fsio.read_morph_data('./prf/prf_surfaces/lh.r2')

prf_surfs = {
  'rh_eccentricity': rh_eccentricity,
  'rh_rfWidth': rh_rfWidth,
  'rh_polarAngle': rh_polarAngle,
  'rh_varea': rh_varea,
  'rh_r2': rh_r2,
  'lh_eccentricity': lh_eccentricity,
  'lh_rfWidth': lh_rfWidth,
  'lh_polarAngle': lh_polarAngle,
  'lh_varea': lh_varea,
  'lh_r2': lh_r2
}

sio.savemat('./prf/prf_surfs.mat',prf_surfs)
