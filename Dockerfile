FROM ubuntu:20.10

# Environment things
ENV TZ America/New_York
ENV REPO_DIR /rtl-sdr-tcp
ENV BUILD_DIR ${REPO_DIR}/build

# Update things
RUN ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
RUN apt-get update -y && apt-get upgrade -y

# Install things
RUN apt-get install -y git
RUN apt-get install -y cmake 
RUN apt-get install -y build-essential
RUN apt-get install -y libusb-1.0-0.dev

# Install GQRX server
RUN git clone git://git.osmocom.org/rtl-sdr.git $REPO_DIR
RUN mkdir $BUILD_DIR
RUN cd $BUILD_DIR
RUN cmake $REPO_DIR
RUN make
RUN make install
RUN ldconfig


# Connect RTL dongle
RUN cp $REPO_DIR/rtl-sdr.rules /etc/udev/rules.d
RUN echo -e "blacklist dvb_usb_rtl28xxu\nblacklist e4000\nblacklist rtl2832" > /etc/modprobe.d/rtl-sdr-blacklist.conf

WORKDIR $REPO_DIR
CMD rtl_tcp
