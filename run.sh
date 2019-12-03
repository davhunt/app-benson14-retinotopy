#!/bin/bash

fsdir=$1

set -x 
set -e

echo "copying input freesurfer to here because benson14_retinotopy writes output to freesurfer dir"
cp -r $fsdir copy

echo "delete any old retinotopy"
rm -rf copy/mri/*benson14*
rm -rf copy/surf/*benson14*

echo "running benson14_retinotopy"
time python -m neuropythy benson14_retinotopy copy -d .

echo "converting output to nifti"
for i in copy/mri/*benson14*
do 
	mri_convert $i ${i%.*}.nii.gz
done

echo "organizing output"
mkdir -p prf varea prf/benson14_surfaces varea_surf
mv copy/surf/*benson14* prf/benson14_surfaces/ 
mv copy/mri/*benson14* prf

mv prf/benson14_eccen.nii.gz prf/eccentricity.nii.gz 
mv prf/benson14_sigma.nii.gz prf/rfWidth.nii.gz 
mv prf/benson14_angle.nii.gz prf/polarAngle.nii.gz 
mv prf/benson14_varea.nii.gz prf/varea.nii.gz 
cp prf/varea.nii.gz varea/parc.nii.gz

for i in rh lh
do
  mv prf/benson14_surfaces/${i}.benson14_eccen prf/benson14_surfaces/${i}.eccentricity
  mv prf/benson14_surfaces/${i}.benson14_sigma prf/benson14_surfaces/${i}.rfWidth
  mv prf/benson14_surfaces/${i}.benson14_angle prf/benson14_surfaces/${i}.polarAngle
  mv prf/benson14_surfaces/${i}.benson14_varea prf/benson14_surfaces/${i}.varea
  cp prf/benson14_surfaces/${i}.varea varea_surf/${i}.parc.annot
done

echo "running create_R2"
# this will create a binary mask R2 of 1's and 0's
# based on whether a voxel is assigned a visual area or not
./create_R2.py ./varea/parc.nii.gz ./prf/benson14_surfaces/rh.varea ./prf/benson14_surfaces/lh.varea

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

