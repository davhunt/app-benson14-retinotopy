#!/bin/bash

fsdir=$1

set -x 
set -e

echo "copying input freesurfer to here because benson14_retinotopy writes output to freesurfer dir"
cp -r $fsdir fs_copy && chmod -R +w fs_copy

echo "delete any old retinotopy"
rm -rf fs_copy/mri/*benson14*
rm -rf fs_copy/surf/*benson14*

echo "running benson14_retinotopy"
time python -m neuropythy benson14_retinotopy fs_copy -d .

echo "converting mgz to nifti"
for i in fs_copy/mri/*benson14*
do 
	mri_convert $i ${i%.*}.nii.gz
done

echo "organizing output"
mkdir -p prf prf/prf_surfaces varea varea_surf
cp key.txt label.json varea && cp key.txt label.json varea_surf

mv fs_copy/surf/*benson14* prf/prf_surfaces
mv fs_copy/mri/*benson14*.nii.gz prf

mv prf/benson14_eccen.nii.gz prf/eccentricity.nii.gz 
mv prf/benson14_sigma.nii.gz prf/rfWidth.nii.gz 
mv prf/benson14_angle.nii.gz prf/polarAngle.nii.gz 
mv prf/benson14_varea.nii.gz prf/varea.nii.gz 
cp prf/varea.nii.gz varea/parc.nii.gz

for i in rh lh
do
  mv prf/prf_surfaces/${i}.benson14_eccen prf/prf_surfaces/${i}.eccentricity
  mv prf/prf_surfaces/${i}.benson14_sigma prf/prf_surfaces/${i}.rfWidth
  mv prf/prf_surfaces/${i}.benson14_angle prf/prf_surfaces/${i}.polarAngle
  mv prf/prf_surfaces/${i}.benson14_varea prf/prf_surfaces/${i}.varea
  cp prf/prf_surfaces/${i}.varea varea_surf/${i}.parc.annot
done

echo "running create_R2"
# this will create a binary mask R2 of 1's and 0's
# based on whether a voxel is assigned a visual area or not
# Just for visualization purposes, not actual r^2 values
./create_R2.py ./varea/parc.nii.gz ./prf/prf_surfaces/rh.varea ./prf/prf_surfaces/lh.varea

echo "saving surfaces in .mat file"
./save_mat.py

echo "creating vtks"
mkdir -p prf/surfaces
mris_convert --to-scanner $fsdir/surf/lh.white prf/surfaces/lh.white.vtk
mris_convert --to-scanner $fsdir/surf/rh.white prf/surfaces/rh.white.vtk
mris_convert --to-scanner $fsdir/surf/lh.pial prf/surfaces/lh.pial.vtk
mris_convert --to-scanner $fsdir/surf/rh.pial prf/surfaces/rh.pial.vtk
mris_convert --to-scanner $fsdir/surf/lh.sphere prf/surfaces/lh.sphere.vtk
mris_convert --to-scanner $fsdir/surf/rh.sphere prf/surfaces/rh.sphere.vtk
mris_convert --to-scanner $fsdir/surf/lh.inflated prf/surfaces/lh.inflated.vtk
mris_convert --to-scanner $fsdir/surf/rh.inflated prf/surfaces/rh.inflated.vtk

