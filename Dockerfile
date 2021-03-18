FROM archlinux:base-devel

# Setup pacman & optimize mirrors
COPY src/pacman.conf /etc/pacman.conf

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
  fish vim \
  zip p7zip unzip \
  gdb radare2 ropper python-keystone python-unicorn ltrace nasm patchelf \
  binwalk foremost imagemagick perl-image-exiftool ffmpeg \
  metasploit \
  fcrackzip pdfcrack john \
  wireshark-cli nmap sqlmap gnu-netcat \
  tmux \
  xorg-server \
  curl wget


# User setup
RUN sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers

RUN \
  useradd -m -s /usr/bin/fish $user && \
  usermod -aG wheel $user && \
  passwd -d $user
USER $user
WORKDIR /home/$user
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
  sudo chsh -s /usr/bin/fish $user

USER root

RUN \
  echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
  ssh-keygen -A
CMD ["/bin/sshd", "-D"]
