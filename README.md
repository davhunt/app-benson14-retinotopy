[![TravisCI](https://travis-ci.org/noahbenson/neuropythy.svg?branch=master)](https://travis-ci.org/noahbenson/neuropythy.svg?branch=master)
[![PyPI version](https://badge.fury.io/py/neuropythy.svg)](https://badge.fury.io/py/neuropythy)

# neuropythy #######################################################################################
A neuroscience library for Python, intended to complement the existing nibabel library.

## Author ##########################################################################################
Noah C. Benson &lt;<nben@nyu.edu>&gt;

## Installation ####################################################################################

The neuropythy library is available on [PyPI](https://pypi.python.org/pypi/neuropythy) and can be
installed via pip:

```bash
pip install neuropythy
```

The dependencies (below) should be installed auotmatically. Alternately, you can check out this
github repository and run setuptools:

```bash
# Clone the repository
git clone https://github.com/noahbenson/neuropythy
# Enter the repo directory
cd neuropythy
# setup the submodules
git submodule init && git submodule update
# Install the library
python setup.py install

```

## Dependencies ####################################################################################

The neuropythy library depends on a few other libraries, all freely available:
 * [numpy](http://numpy.scipy.org/) &ge; 1.5.0
 * [scipy](http://www.scipy.org/) &ge; 0.0.0
 * [nibabel](https://github.com/nipy/nibabel) &ge; 2.0
 * [pyrsistent](https://github.com/tobgu/pyrsistent) &ge; 0.11.0
 * [pimms](https://github.com/noahbenson/pimms) &ge; 0.2.8
 * [py4j](https://www.py4j.org/) &ge; 0.10

These libaries should be installed automatically for you if you use pip or setuptools (see above),
and they must be found on your PYTHONPATH in order to use neuropythy.

### Optional Dependencies

All optional dependencies are included in the `requirements-dev.txt` file in the neuropythy
repository root. 

 * **[s3fs &ge; 0.1.5](https://github.com/dask/s3fs)**. The HCP dataset can be accessed
   automatically using neuropythy's hcp_subject() function. If configured correctly (see below),
   neuropythy will silently download the relevant HCP data from its Amazon S3 bucket as it is
   requested. Doing this requires the s3fs library.
 * **[h5py &ge; 2.8.0](https://github.com/h5py/h5py)**. The h5py file is used to import the HCP 
   retinotopy data if it is found or configured for automatic-downloading (see below).
 * **[Matplotlib &ge; 1.5.3](http://matplitlib.org/)**. A few functions for plotting cortical maps
   are defined in the neuropythy.graphics package. These are not defined if matplotlib is not
   imported successfully. The primary interface to this functionality is the
   neuropythy.graphics.cortex_plot as well as some helper functions and colormaps.
 * **[Java &ge; 1.8](http://www.oracle.com/technetwork/java/javase/downloads/index.html)**.
   The registration algorithm employed by the register_retinotopy command is performed by
   a Java library embedded in the neuropythy Python library. This library is the
   [nben](https://github.com/noahbenson/nben) library, and is included as a submodule of this
   GitHub repository, found in neuropythy/lib/nben; a standalone jar-file is also distributed as
   part of the PyPI neuropythy distribution. However, in order for the Py4j library, which allows
   Python to execute Java routines, to use this jar-file, you must have a working version of Java
   installed; accordingly, the register_retinotopy command is only available if you have Java
   installed and working. For help getting Java configured to work with Py4j, see the
   [Py4j installation page](https://www.py4j.org/install.html).

### Python Version #################################################################################

Neuropythy has been used extensively with Python 2.7; recently some effort has been made to make it
compatible with Python 3. In theory it should work with Python 3; however, relatively little testing
has been done.

## Configuration ###################################################################################

Neuropythy is most useful when it knows where to find your FreeSurfer subject data or where you want
it to store datasets or Human Connectome Project files. These configuration items can be set in a
number of ways:
* On startup, neuropythy looks for a file `~/.npythyrc` (though this file name may be changed by
  setting the `NPYTHYRC` environment variable). The contents of this file should be a JSON
  dictionary with configurable variables (such as `"freesurfer_subject_paths"`) as the keys. An
  example configuration file:
  ```json
  {"freesurfer_subject_paths": "/Volumes/server/Freesurfer_subjects",
   "data_cache_root":          "~/Temp/npythy_cache",
   "hcp_subject_paths":        "/Volumes/server/Projects/HCP/subjects",
   "hcp_auto_download":        true,
   "hcp_credentials":          "~/.hcp-passwd"}
  ```
* Each config variable in the `NPYTHYRC` file may be overrided using an associated environment
  variable. Usually the environment variable names are either the config variables in uppercase or
  `NPYTHY_` + the variable in uppercase: `NPYTHY_DATA_CACHE_ROOT`, `HCP_CREDENTIALS`,
  `HCP_AUTO_DOWNLOAD`. The `SUBJECTS_DIR` environment is used for the FreeSurfer subject paths, and
  the `HCP_SUBJECTS_DIR` variable is used for the HCP subject paths (both may be :-separated lists
  of directories).
* The config items may be retrieved and set directly using `neuropythy.config`. Values that are set
  in this way override the `NPYTHYRC` file and all environment variables. For example:
  ```python
  import neuropythy as ny
  ny.config['data_cache_root']
  #=> '/Users/nben/Temp/npythy_cache'
  ny.config['data_cache_root'] = '~/Documents/npythy_data'
  ny.config['data_cache_root']
  #=> '/Users/nben/Documents/npythy_data'
  ```

## Human Connectome Project Integration ############################################################

The neuropythy library is capable of automatically integrating with the Human Connectome Project's
Amazon S3 bucket. Neuropythy will present you with nested data structures representing individual
HCP subjects and will silently download the relevant structure files as they are requested. To
configure this behavior, follow these steps:
* Make a directory somewhere to store the HCP subjects that are downloaded. The subjects won't be
  downloaded all at once, but it will drastically speed up future loading of subjects if you cache
  them on your local filesystem.
* **Sign up for an HCP account.** You can do this at the [HCP's database
  page](https://db.humanconnectome.org/).
* Once you have an account, log into the database; near the top of the initial splash page is a cell
  titles "WU-Minn HCP Data - 1200 Subjects" and inside this cell is a button for activating Amazon
  S3 Access. When you activate this feature, you will be given an amazon "Key" and "Secret".
* Copy and paste your key and secret into a file `~/.hcp-passwd` such that the contents are your key
  followed by a colon followed by your secret, e.g., `mys3key:mys3secret`.
* You should then make sure that the configuration variable `"hcp_credentials"` is set to
  `"~/.hcp-passwd"` in your `~/.npythyrc` file (see Configuration, above). Additionally, set the
  `"hcp_auto_download"` value is set to `true`, and set the `"hcp_auto_path"` variable to the
  directory in which you plan to store the HCP subject data.
  
Note that the above steps will additionally enable auto-downloading of the retinotopic mapping
database; if you are only interested in the structural data, you can set the `"hcp_auto_download"`
variable to `"structure"`. If you do enable auto-downloading of the retinotopic maps, then the first
time you examine an HCP subject, neuropythy will have to download the retinotopy database files,
which are approximately 1 GB; it may appear as if neuropythy has frozen during this time, but it is
probably just due to the download. Generally speaking, if your internet connection is relatively
fast, you should not notice significant delays from downloading the HCP strucutral data otherwise.

For more information about using the HCP module of neuropythy, see [this page](https://noahbenson.github.io/HCP-and-Neuropythy/).

## Builtin Datasets ################################################################################

Neuropythy now comes with support for builtin datasets. These datasets are downloaded when they are
first requested, and are only re-downloaded if necessary; note that if you have configured
neuropythy's `"data_cache_root"` configuration variable (see Configuration, above), then the data
will be downloaded to a temporary directory that is deleted when Python exits.

Currently, there is only one builtin dataset (not including the Human Connectome Project dataset,
above), and that is the dataset from [Benson and Winawer (2018)](https://doi.org/10.1101/325597). To
access this dataset:

```python
import neuropythy as ny
subs = ny.data['benson_winawer_2018'].subjects
sorted(subs.keys())
#=> ['S1201', 'S1202', 'S1203', 'S1204', 'S1205', 'S1206', 'S1207', 'S1208', 'fsaverage']
subs['S1201']
#=> Subject(<S1201>,
#=>         <'/Users/nben/Temp/npythy_cache/benson_winawer_2018/freesurfer_subjects/S1201'>)
subs['S1201'].lh.prop('prf_polar_angle')
#=> array([118.811386, 118.80122 , 120.842255, ..., -14.08387 , -62.615746, -32.82376],
#=>       dtype=float32)
```

See also `help(ny.data['benson_winawer_2018'])` or `print(ny.data['benson_winawer_2018'].__doc__)`.

## Commands ########################################################################################

Currently Neuropythy is undergoing rapid development, but to get started, the neuropythy.commands
package contains functions that run command-interfaces for the various routines included.  Any of
these commands may be invoked by calling Neuropythy's main function and passing the name of the
command as the first argument followed by any additional command arguments. The argument --help may
be passed for further information about each command.

 * **surface_to_image**. This command projects data on the cortical surface into a volume the same
   orientation as the subject's mri/orig.mgz file. The algorithm used tends to be much cleaner than
   that used by FreeSurfer's mri_surf2vol.
 * **benson14_retinotopy**. This command applies the anatomically-defined template of retinotopy
   described by Benson *et al.* (2014; see **References** below) to a subject. Note that the
   template applied is not actually the template shown in the paper but is a similar updated
   version.
 * **register_retinotopy**. This command fits a retinotopic model of V1, V2, and V3 to retinotopy
   data for a subject and saves the predicted retinotopic maps that result. Running this command
   requires some retinotopic measurements that have already been transferred to the subject's
   FreeSurfer surface. These files can either be specified on the command line (see the
   `register_retinotopy --help` documentation) or placed in the subject's `surf/` directory and
   named as follows:
    * lh.prf_angle.mgz (subject's LH polar angle, 0-180 degrees refers to UVM -> RHM -> LVM)
    * rh.prf_angle.mgz (subject's RH polar angle, 0-180 degrees refers to UVM -> LHM -> RVM)
    * lh.prf_eccen.mgz (subject's LH eccentricity, in degrees)
    * rh.prf_eccen.mgz (subject's RH eccentricity, in degrees)
    * lh.prf_vexpl.mgz (the varaince explained of each vertex's pRF solution for the LH; 0-1 values)
    * rh.prf_vexpl.mgz (the varaince explained of each vertex's pRF solution for the RH; 0-1 values)

   To be clear, both the left and right hemispheres' angle files should specify the polar angle in
   positive degrees; for the right hemisphere, positive refers to the left visual hemi-field; for
   the left hemisphere, positive values refer to the right visual hemi-field. In both cases, 0
   represents the upper vertical meridian and 180 represents the lower vertical meridian. Each MGZ
   file should contain a 1x1xn (or 1x1x1xn) volume where n is the number of vertices in the relevant
   hemisphere and the vertex ordering is that used by FreeSurfer.
   

If neuropythy is installed on your machine, then you can execute a command like so:

```bash
> python -m neuropythy.__main__ surface_to_image --help
> python -m neuropythy.__main__ benson14_retinotopy bert
```


## Docker ##########################################################################################

There is a Docker containing Neuropythy that can be used to run the Neuropythy commands quite easily
without installing Neuropythy itself. If you have [Docker](https://www.docker.com/) installed, you
can use Neuropythy as follows:

```bash
# If your FreeSurfer subject's directory is /data/subjects and you want to
# apply the Benson2014 template to a subject bert:
docker run nben/neuropythy -ti --rm -v /data/subjects:/subjects \
           benson14_retinotopy bert
```

## Citing ##########################################################################################

To cite Neuropythy, please reference the following:
* Benson NC, Winawer J (**2018**) Bayesian Analysis of Retinotopic Maps. *bioRxiv*
  doi:[10.1101/325597](https://doi.org/10.1101/325597). 


## References ######################################################################################

 * Benson NC, Winawer J (**2018**) Bayesian Analysis of Retinotopic Maps. *bioRxiv*
   doi:[10.1101/325597](https://doi.org/10.1101/325597). 
 * Benson NC, Butt OH, Brainard DH, Aguirre GK (**2014**) Correction of distortion in flattened
   representations of the cortical surface allows prediction of V1-V3 functional organization from
   anatomy. *PLoS Comput. Biol.* **10**(3):e1003538.
   doi:[10.1371/journal.pcbi.1003538](https://dx.doi.org/10.1371/journal.pcbi.1003538).
   PMC:[3967932](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3967932/).
 * Benson NC, Butt OH, Datta R, Radoeva PD, Brainard DH, Aguirre GK (**2012**) The retinotopic
   organization of striate cortex is well predicted by surface topology. *Curr. Biol.*
   **22**(21):2081-5. doi:[10.1016/j.cub.2012.09.014](https://dx.doi.org/10.1016/j.cub.2012.09.014).
   PMC:[3494819](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3494819/).

## License #########################################################################################

This README file is part of the Neuropythy library.

The Neuropythy library is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
