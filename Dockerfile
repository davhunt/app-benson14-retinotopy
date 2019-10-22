FROM brainlife/freesurfer:6.0.0
MAINTAINER David Hunt <davhunt@indiana.edu>
EXPOSE 5900
ADD . /tmp/

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

RUN apt-get update

#RUN apt-get remove python3-numpy
#RUN apt-get remove python3-scipy

RUN apt-get -y install python-pip
RUN pip install --upgrade pip
RUN pip install --upgrade numpy
RUN pip install --upgrade scipy
RUN pip install --upgrade six
RUN pip install --upgrade pimms
RUN pip install --upgrade neuropythy

