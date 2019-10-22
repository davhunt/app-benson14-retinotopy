FROM brainlife/freesurfer:6.0.0

RUN apt-get update && apt-get -y install python-pip 
RUN pip install --upgrade pip 
RUN pip install numpy scipy six pimms neuropythy

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft


