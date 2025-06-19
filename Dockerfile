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




# Arguments pour correspondre à l'utilisateur host
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=user

# Créer l'utilisateur avec les mêmes IDs que le host
RUN groupadd -g $GROUP_ID $USERNAME && \
    useradd -u $USER_ID -g $GROUP_ID -m -s /bin/bash $USERNAME

# Ajouter aux groupes vidéo et audio
RUN usermod -aG video,audio $USERNAME
RUN groupadd -g 109 render
#getent group render


CMD ["/bin/bash"]
