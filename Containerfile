FROM ubuntu:focal

COPY apt/focal-src.list /etc/apt/sources.list.d/

WORKDIR /src

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
        apt-get -y install \
        autoconf \
        automake \
        autopoint \
        autotools-dev \
        bsdmainutils \
        debhelper \
        devscripts \
        dh-autoreconf \
        dh-python \
        dh-sequence-gir \
        dh-sequence-gnome \
        dh-strip-nondeterminism \
        dmz-cursor-theme \
        doxygen \
        dpkg-dev \
        dwz \
        file \
        fuse \
        gettext \
        gettext-base \
        gnome-control-center-data \
        gnome-pkg-tools \
        gnome-settings-daemon-common \
        gnome-settings-daemon-dev \
        gobject-introspection \
        graphviz \
        groff-base \
        gtk-doc-tools \
        help2man \
        intltool-debian \
        libarchive-zip-perl \
        libasound2-dev \
        libbluetooth-dev \
        libbsd0 \
        libcanberra-gtk3-dev \
        libcroco3 \
        libdbus-1-dev \
        libdebhelper-perl \
        libdrm-dev \
        libelf1 \
        libexpat1 \
        libfile-stripnondeterminism-perl \
        libflatpak-dev \
        libfuse-dev \
        libgbm-dev \
        libgeoclue-2-dev \
        libgirepository1.0-dev \
        libglib2.0-0 \
        libglib2.0-dev \
        libgnome-desktop-3-dev \
        libgraphene-1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer1.0-dev \
        libgtk-3-dev \
        libgudev-1.0-dev \
        libicu66 \
        libinput-dev \
        libjack-jackd2-dev \
        libjson-glib-dev \
        libmagic-mgc \
        libmagic1 \
        libmpdec2 \
        libncurses-dev \
        libnvidia-egl-wayland-dev \
        libpam0g-dev \
        libpipeline1 \
        libpulse-dev \
        libpython3-stdlib \
        libpython3.8-minimal \
        libpython3.8-stdlib \
        libsbc-dev \
        libsdl2-dev \
        libsigsegv2 \
        libsndfile1-dev \
        libstartup-notification0-dev \
        libsub-override-perl \
        libsystemd-dev \
        libtool \
        libuchardet0 \
        libudev-dev \
        libv4l-dev \
        libwacom-dev \
        libxcb-randr0-dev \
        libxcb-res0-dev \
        libxkbcommon-x11-dev \
        libxkbfile-dev \
        libxml2 \
        m4 \
        man-db \
        meson \
        mime-support \
        pkg-config \
        po-debconf \
        python3 \
        python3-all \
        python3-chardet \
        python3-debian \
        python3-distutils \
        python3-lib2to3 \
        python3-minimal \
        python3-pkg-resources \
        python3-pyparsing \
        python3-setuptools \
        python3-sh \
        python3-six \
        python3.8 \
        python3.8-minimal \
        quilt \
        systemd \
        tzdata \
        xauth \
        xmlto \
        xmltoman \
        xserver-xorg-core \
        xvfb \
        xwayland \
        zenity \
        && apt source mutter
        # && rm -rf /var/lib/apt/lists/* \

COPY apt/hirsute-src.list /etc/apt/sources.list.d/

RUN apt-get update && \
        apt source \
        mini-soong \
        libopenaptx \
        libldac \
        pipewire \
        xdg-desktop-portal \
        xdg-desktop-portal-gtk

COPY patch /patch

RUN cd /src/mini-soong-*/ \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../mini-soong*.deb

RUN cd /src/libldac-*/ \
        && quilt import /patch/libldac/* \
        && dch -i "Focal backport" \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../libldacbt*.deb

RUN cd /src/libopenaptx-*/ \
        && quilt import /patch/libopenaptx/* \
        && dch -i "Focal backport" \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../libopenaptx-dev*.deb ../libopenaptx0_*.deb

RUN cd /src/pipewire-*/ \
        && quilt import /patch/pipewire/* \
        && dch -i "Focal backport" \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../libpipewire-0.3*.deb \
        ../gstreamer1.0-pipewire*.deb \
        ../pipewire_*.deb \
        ../pipewire-bin_*.deb \
        ../libspa-0.2-modules_*.deb \
        ../libspa-0.2-dev_*.deb

RUN cd /src/xdg-desktop-portal-1*/ \
        && quilt import /patch/xdg-desktop-portal/* \
        && dch -i "Enable pipewire" \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../xdg-desktop-portal_*.deb ../xdg-desktop-portal-dev_*.deb

RUN cd /src/xdg-desktop-portal-gtk-*/ \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../xdg-desktop-portal-gtk_*.deb

RUN cd /src/mutter-*/ \
        && quilt import /patch/mutter/* \
        && quilt push -a \
        && dch -i "Screencast with pipewire" \
        && dpkg-buildpackage -b -uc -us \
        && dpkg -i ../mutter_*.deb \
        ../gir1.2-mutter-*.deb \
        ../mutter-common_*.deb \
        ../libmutter-6-0_*.deb
