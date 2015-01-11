FROM base/archlinux
MAINTAINER atbell

# base

# set environment variables
ENV HOME /root
ENV LANG en_US.UTF-8

# set locale
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen
RUN echo LANG="en_US.UTF-8" > /etc/locale.conf

# perform system update (must ignore package "filesystem")
RUN pacman -Syu --ignore filesystem --noconfirm

# add in pre-req from official repo
RUN yes | pacman -Scc && pacman -Sy --needed base-devel supervisor --noconfirm

# add supervisor configuration file
ADD supervisor.conf /etc/supervisor.conf

# home
######

# set permissions
RUN mkdir -p /home/nobody && chown -R nobody:users /home/nobody && chmod -R 775 /home/nobody

# packer
########

# download packer from aur
ADD https://aur.archlinux.org/packages/pa/packer/packer.tar.gz /root/packer.tar.gz

# download & install packer from aur
RUN cd /root && \
	tar -xzf packer.tar.gz && \
    cd /root/packer && \
    makepkg -s --asroot --noconfirm

# install packer using pacman
RUN pacman -U /root/packer/packer*.tar.xz --noconfirm

# cleanup
#########

RUN pacman -Scc --noconfirm; rm -rf /root/* /tmp/* /archlinux/usr/share/locale /archlinux/usr/share/man /etc/supervisor.d /etc/supervisord.conf