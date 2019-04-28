FROM brainlife/freesurfer:6.0.0

WORKDIR /app

COPY . /app

EXPOSE 5900

RUN ldconfig && RUN mkdir -p /N/u /N/home /N/dc2 /N/soft

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get remove python3-numpy
RUN pip3 install --upgrade numpy
