FROM ubuntu:18.04

# Port things
EXPOSE 1234/tcp

# Environment things
ENV TZ America/New_York
ENV REPO_DIR /opt/rtl-sdr-tcp
ENV BUILD_DIR ${REPO_DIR}/build
ENV MODPROBE_CONF /etc/modprobe.d/rtl-sdr-blacklist.conf

# Update things
RUN ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt install -y pkg-config

# Install things
RUN apt-get install -y apt-utils
RUN apt-get install -y rtl-sdr
RUN apt-get install -y soapysdr-module-rtlsdr
RUN apt-get install -y git
RUN apt-get install -y cmake 
RUN apt-get install -y build-essential
RUN apt-get install -y libusb-1.0-0.dev

# Install GQRX server
#RUN git clone git://git.osmocom.org/rtl-sdr.git $REPO_DIR
#RUN mkdir $BUILD_DIR
#WORKDIR $BUILD_DIR
#RUN cmake $REPO_DIR
#RUN make
#RUN make install
#RUN ldconfig


# Connect RTL dongle
RUN mkdir -p /etc/modprobe.d/
RUN mkdir -p /etc/udev/
RUN cp $REPO_DIR/rtl-sdr.rules /etc/udev/rules.d
RUN echo -e "blacklist dvb_usb_rtl28xxu\nblacklist e4000\nblacklist rtl2832" > $MODPROBE_CONF

#WORKDIR $REPO_DIR
CMD rtl_tcp
