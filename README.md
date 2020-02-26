[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)

# Map pRFs in visual cortex with anatomy

This app performs a retinotopic mapping in visual areas V1, V2, and V3, as well as higher-order visual areas, from an anatomical (T1-weighted MRI) image, using the neuropythy python library by Noah Benson (github.com/noahbenson/neuropythy).


![screen](screen.png)


1) What the App does, and how it does it at the basic level.
2) Briefly explain what 1) means for novice users in a language that 1st year psychology student can understand it.
3) Briefly description of input / output files.

### Authors
- [David Hunt](davhunt@iu.edu)
- [Noah Benson](nben@nyu.edu)

### Project director
- Franco Pestilli (franpest@indiana.edu)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.187](https://doi.org/10.25663/brainlife.app.187) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with path to your freesurfer subject directory.

```json
{
        "freesurfer": "./freesurfer/subjects/bert"
}
```

3. Launch the App by executing `main`

```bash
./main
```

### Sample Datasets

If you don't have your own freesurfer subject, you can download sample datasets from Brainlife.io, or you can use [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 598a2aa44258600aa3128fd4 && mv -R 598a2aa44258600aa3128fd4 input/output
```

## Output

All output files will be generated under the current working directory (pwd). The main output of this App is the directory `prf`, which contains the population receptive field measures polarAngle, eccentricity, rfWidth, and varea in the brain volume (*.nii.gz) as well as on the cortical surface (lh.polarAngle, etc) in freesurfer .curv format.

```
.
+-- prf
|   +-- polarAngle.nii.gz
|   +-- eccentricity.nii.gz
|   +-- rfWidth.nii.gz
|   +-- varea.nii.gz
+   |-- prf_surfaces
+   |-- surfaces
```

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run.
