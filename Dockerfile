FROM --platform=linux/amd64 archlinux:base-devel

ARG USER
ARG PASS
ARG SSH_PORT

ENV SSH_PORT ${SSH_PORT}
ENV PATH "${PATH}:~/.local/bin"

COPY src/sshd_config /etc/ssh/sshd_config
COPY src/pacman.conf /etc/pacman.conf

# Setup pacman & optimize mirrors
RUN \
  pacman -Sy && \
  pacman -S --needed --noconfirm pacman-contrib && \
  pacman-key --init && \
  pacman-key --populate archlinux && \
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && \
  sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup && \
  rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

# Install base packages
RUN pacman --needed --noconfirm -S \
  lib32-glibc \
  openssh \
  git \
  go php \
  python2 python2-pip \
  python python-pip \
  fish vim \
  zip p7zip unzip \
  gdb radare2 ropper python-keystone python-unicorn ltrace nasm patchelf python-pwntools \
  binwalk foremost imagemagick perl-image-exiftool ffmpeg \
  metasploit \
  fcrackzip pdfcrack john \
  wireshark-cli nmap sqlmap gnu-netcat \
  tmux \
  xorg-xauth xorg-server \
  curl wget

# User setup
RUN sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers

RUN \
  useradd -m -s /usr/bin/fish $USER && \
  usermod -aG wheel $USER && \
  passwd -d $USER
USER $USER
WORKDIR /home/$USER
COPY --chown=cf12:cf12 src/dotfiles ./

# # Install yay
# RUN \
#   git clone https://aur.archlinux.org/yay.git /tmp/yay && \
#   cd /tmp/yay && makepkg -sic --noconfirm --needed --noprogressbar && \
#   rm -rf /tmp/yay

# RUN yay --needed --noconfirm -S \
#   gobuster \
#   android-apktool \
#   zsteg \
#   hash-identifier \
#   pngcheck steghide \
#   ngrok

RUN pip install --user \
  angr IPython \
  pillow

# Install gef
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

USER root

RUN ssh-keygen -A
CMD /bin/sshd -D -p ${SSH_PORT}
