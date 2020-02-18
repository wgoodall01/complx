##### Runtime dependencies #####
FROM ubuntu:16.04 as runtime
RUN apt-get update \
	&& apt-get install -y libwxgtk3.0 \
	&& apt-get clean

##### Build image #####
FROM runtime AS build

# Install additional build dependencies
RUN apt-get -y install build-essential g++ libwxgtk3.0-dev cmake libboost-test-dev libboost-python-dev libboost-serialization-dev libglib2.0-dev castxml python-pip \
	&& apt-get clean

# Install python deps
COPY pylc3/requirements-build.txt /complx/pylc3/requirements-build.txt
RUN pip install -r /complx/pylc3/requirements-build.txt

# Copy in build files
COPY . /complx

# Build complx
RUN mkdir -p /complx/build && cd /complx/build \
	&& cmake .. \
	&& make 

##### Dist image #####
FROM runtime

# Copy in binaries
COPY --from=build /complx/build/as2obj /usr/local/bin/
COPY --from=build /complx/build/liblc3.so /usr/local/lib
COPY --from=build /complx/build/plugins/* /usr/local/lib/
COPY --from=build /complx/build/complx/complx /usr/local/bin/
COPY --from=build /complx/complx.png /usr/local/share/icons/complx.png
COPY --from=build /complx/complx.desktop /usr/local/share/applications/complx.desktop

# Find all the shared libs
RUN ldconfig

RUN useradd developer
RUN mkdir -p /home/developer/ && chown developer:developer /home/developer
USER developer
ENV HOME /home/developer
WORKDIR /home/developer/

CMD [ "complx" ]
