FROM archlinux:base-devel

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
  pacman-key --init && \
  pacman-key --populate archlinux && \
  pacman --needed --noconfirm -S reflector rsync && \
  reflector -f 10 --score 20 --save /etc/pacman.d/mirrorlist

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
  gdb radare2 ropper python-keystone python-unicorn ltrace nasm patchelf \
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
COPY src/home ./

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

RUN pip install --user \
  angr IPython \
  pwntools \
  pillow

# Install gef
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# Install oh-my-fish
RUN \
  (curl -L https://get.oh-my.fish | fish) && \
  sudo chsh -s /usr/bin/fish $USER

USER root

RUN ssh-keygen -A
CMD /bin/sshd -D -p ${SSH_PORT}