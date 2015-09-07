FROM ubuntu:trusty

ENV "GOINSTALLPATH=/usr/local" "GOROOT=/usr/local/go" "GOPATH=/go" "PATH=${PATH}:/usr/local/go/bin:/go/bin"

ADD archives/go.tar.gz /usr/local
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get remove -y adduser apt-utils busybox-initramfs bzip2 console-setup cpio cron debconf-i18n dh-python \
                      dmsetup eject file ifupdown init-system-helpers initramfs-tools initramfs-tools-bin initscripts \
                      iproute2 isc-dhcp-client isc-dhcp-common kbd keyboard-configuration klibc-utils \
                      kmod less libapt-inst1.5:amd64 libarchive-extract-perl libbsd0:amd64 libcap2-bin \
                      libcgmanager0:amd64 libdbus-1-3:amd64 libdevmapper1.02.1:amd64 libdrm2:amd64 libestr0 \
                      libexpat1:amd64 libffi6:amd64 libfribidi0:amd64 libgcrypt11:amd64 libgdbm3:amd64 \
                      libgpg-error0:amd64 libjson-c2:amd64 libjson0:amd64 \
                      libklibc libkmod2:amd64 liblocale-gettext-perl liblockfile-bin liblockfile1:amd64 \
                      liblog-message-simple-perl libmagic1:amd64 libmodule-pluggable-perl libmpdec2:amd64 \
                      libncursesw5:amd64 libnewt0.52:amd64 libnih-dbus1:amd64 libnih1:amd64 libp11-kit0:amd64 \
                      libpam-cap:amd64 libplymouth2:amd64 libpng12-0:amd64 libpod-latex-perl libpopt0:amd64 \
                      libprocps3:amd64 libpython3-stdlib:amd64 libpython3.4-minimal:amd64 libpython3.4-stdlib:amd64 \
                      libsqlite3-0:amd64 libtasn1-6:amd64 libterm-ui-perl libtext-charwidth-perl \
                      libtext-iconv-perl libtext-soundex-perl libtext-wrapi18n-perl libudev1:amd64 locales \
                      lockfile-progs logrotate lsb-release makedev mime-support module-init-tools mountall net-tools \
                      netbase netcat-openbsd ntpdate perl perl-modules plymouth procps python3 python3-minimal \
                      python3.4 python3.4-minimal resolvconf rsyslog ubuntu-minimal ucf udev upstart ureadahead \
                      whiptail xkb-data && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get -y clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /var/cache/debconf/* \
           /usr/share/perl/* && \
    mkdir -p "/go/bin"

VOLUME ["/go"]
WORKDIR "/go"
ENTRYPOINT ["/usr/local/go/bin/go"]
CMD ["-h"]
