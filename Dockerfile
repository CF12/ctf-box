FROM archlinux:base-devel

ARG user=cf12
ARG pass=cf12

# Setup pacman & optimize mirrors
COPY pacman.conf /etc/pacman.conf

RUN pacman -Sy
RUN pacman --needed --noconfirm -S reflector rsync
RUN reflector -f 10 --score 20 --save /etc/pacman.d/mirrorlist

RUN \
  pacman-key --init && \
  pacman-key --populate archlinux

# Install base packages
RUN pacman --needed --noconfirm -S \
  lib32-glibc \
  openssh \
  git \
  go \
  python2 python2-pip \
  python python-pip \
  fish \
  zip p7zip unzip \
  gdb radare2 ropper python-keystone python-unicorn radare2 ltrace nasm patchelf \
  binwalk foremost imagemagick perl-image-exiftool ffmpeg \
  metasploit \
  fcrackzip pdfcrack john \
  wireshark-cli nmap sqlmap gnu-netcat \
  tmux \
  xorg-server \
  curl


# User setup
RUN sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers

RUN \
  useradd -m -s /usr/bin/fish $user && \
  usermod -aG wheel $user && \
  passwd -d $user
USER $user
WORKDIR /home/$user

# Install yay
RUN \
  git clone https://aur.archlinux.org/yay.git /tmp/yay && \
  cd /tmp/yay && makepkg -sic --noconfirm --needed --noprogressbar && \
  rm -rf /tmp/yay

RUN yay --needed --noconfirm -S \
  burpsuite \
  gobuster \
  android-apktool \
  zsteg \
  hash-identifier \
  pngcheck steghide \
  ngrok

RUN pip install angr

COPY src/ ./

USER root

RUN \
  echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
  ssh-keygen -A
CMD ["/bin/sshd", "-D"]
