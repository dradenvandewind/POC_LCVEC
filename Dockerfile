FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

# Env vars
#ENV PYTHONPATH=/usr/local/lib/python3.8/site-packages:/usr/local/lib/python3.10/site-packages:/usr/local/lib/python3.11/site-packages:/usr/lib/python3.10

ENV GI_TYPELIB_PATH=/usr/local/lib/x86_64-linux-gnu/girepository-1.0:/usr/lib/x86_64-linux-gnu/girepository-1.0
ENV GST_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gstreamer-1.0/
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV DISPLAY=:1
ENV GST_DEBUG=2
ENV GST_DEBUG_DUMP_DOT_DIR=/tmp
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64/
ENV TF_FORCE_GPU_ALLOW_GROWTH=true
ENV TF_ENABLE_GPU_GARBAGE_COLLECTION=false
ENV PREFIX=/usr
ENV TAG=1.26.2
ENV TZ=Europe/Paris

# Timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Installer les outils nécessaires pour gérer les dépôts
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get install -y --no-install-recommends pkg-config \
nlohmann-json3-dev \
libfmt-dev \
libcli11-dev \ 
libavcodec-dev \
libavformat-dev \
libavutil-dev \
libavfilter-dev \
libgtest-dev \
libgmock-dev \
libxxhash-dev \
librange-v3-dev \
git \
build-essential \
cmake \
ninja-build \
python3.9 \
python3-pip \
python3-setuptools \
python3-distutils

WORKDIR /root/workingsrc


RUN git clone https://github.com/v-novaltd/LCEVCdec.git && \
cd LCEVCdec && \
mkdir build && \
cd build && \
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DVN_SDK_EXECUTABLES=ON -DVN_SDK_UNIT_TESTS=ON -DCMAKE_BUILD_TYPE=Release -G Ninja && \
cmake --build . --config Release && \
cmake --install . && \
ldconfig 

# build gstreamer section

RUN apt-get update && apt-get install -y --no-install-recommends  flex bison \
    gobject-introspection \
    libgirepository1.0-dev \
    vim \
    nano \
    net-tools \
    tcpdump \
    alsa-utils \
    lshw \
    graphviz \
    syslog-ng \
    openssh-client \
    python3-dev \
    libpython3-dev \
    python3-dev \
    meson ninja-build git \
    libglib2.0-dev libgirepository1.0-dev gobject-introspection \
    libffi-dev libtool pkg-config curl wget




RUN pip install "setuptools<65" meson==1.4.0
RUN apt-get install -y libc6-dev 
RUN git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git && \
  cd gstreamer && \
  git checkout tags/$TAG && \
  mkdir build && cd build && \
  meson setup ..            \
       --prefix=/usr       \
       --buildtype=release && \
    ninja && \
    ninja install && \
    ldconfig 
#https://docs.v-nova.com/technologies/mpeg-5.lcevc/integrations/gstreamer/lcevc-decoder-build

# RUN git clone https://github.com/v-novaltd/LCEVCdec.git && \
# cd LCEVCdec && \
# mkdir build && cd build && \
# cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR .. && \
# cmake --build . && \
# cmake --install . && \
# ldconfig

#raw souce https://media.xiph.org/video/derf/
RUN wget https://media.xiph.org/video/derf/y4m/akiyo_cif.y4m 

COPY display_conf.patch /root/workingsrc/display_conf.patch
COPY add-logs.patch /root/workingsrc/add-logs.patch
COPY display_conf.patch /root/workingsrc/display_conf.patch
COPY display_image_before_push.patch /root/workingsrc/display_image_before_push.patch
COPY add-debug-xeveapp.patch /root/workingsrc/add-debug-xeveapp.patch

#add lcvec encoderd

#git apply < /root/workingsrc/display_conf.patch && \
#git apply < /root/workingsrc/display_image_before_push.patch && \

RUN git clone https://github.com/mpeg5/xeve && \
cd xeve && \
cp ./app/xeve_app_util.h /usr/include/xeve_app_util.h && \
cp ./src_base/xeve_util.h /usr/include/xeve_util.h && \
git apply < /root/workingsrc/add-debug-xeveapp.patch && \
mkdir build && \
cd build && \
cmake .. && \
make && \
make install && \
ldconfig

#xeve_app -i akiyo_cif.y4m -w 352 -h 288 -z 30 -o xeve.evc
ENV PKG_CONFIG_PATH=/usr/lib/pkgconfig:$PKG_CONFIG_PATH
COPY ./gstevcplugin/ /root/workingsrc/gstevcplugin/
COPY *.sh /root/workingsrc/
COPY myvideo.evc /root/workingsrc/
#cp /usr/local/include/xeve/xeve.h /usr/local/include/xeve.h && \

RUN git clone https://github.com/mpeg5/xevd.git && \
cd xevd && \
mkdir build && \
cd build && \
cmake .. && \
make && \
make install && \
ldconfig
#xevd_app -i akyio.evc -o akyio_lcvev.yuv
#


RUN cd /root/workingsrc/gstevcplugin && \
cp /usr/local/include/xeve/xeve.h /usr/local/include/xeve.h && \
cp xeve.pc /usr/lib/pkgconfig && \
meson builddir --prefix=/usr && \
ninja -C builddir && \
ninja -C builddir install && \
ldconfig

COPY ./xevedec/ /root/workingsrc/xevedec/
RUN cd /root/workingsrc/xevedec/ && \
cp xevd.pc /usr/lib/pkgconfig && \
cp /usr/local/include/xevd/xevd.h /usr/local/include/xevd.h && \
cp /root/workingsrc/xevd/app/xevd_app_util.h /usr/local/include/xevd_app_util.h && \
meson builddir --prefix=/usr && \
ninja -C builddir && \
ninja -C builddir install && \
ldconfig

RUN export GST_DEBUG_DUMP_DOT_DIR=/tmp/


ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=user

RUN groupadd -g $GROUP_ID $USERNAME && \
    useradd -u $USER_ID -g $GROUP_ID -m -s /bin/bash $USERNAME

RUN usermod -aG video,audio $USERNAME
RUN groupadd -g 109 render
#getent group render

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
CMD gst-inspect-1.0 --version || exit 1


CMD ["/bin/bash"]
