# Synchronize repos
pacman -Sy

pacman -S rsync

# Setup reflector for faster mirros
pacman --needed --noconfirm -S reflector
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

pacman --needed --noconfirm -S \
  lib32-glibc

pacman-key --populate archlinux

# Install base packages
pacman --needed --noconfirm -S \
  base-devel \
  git \
  go \
  python2 python2-pip \
  python python-pip \
  fish \
  zip p7zip unzip \
  terminator \
  gdb radare2 ropper python-keystone python-unicorn radare2 ltrace nasm patchelf \
  binwalk foremost imagemagick perl-image-exiftool ffmpeg sagemath \
  metasploit \
  fcrackzip pdfcrack john \
  wireshark-cli nmap sqlmap gnu-netcat \
  tmux \
  xorg \
  curl

# Install yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -sic --noconfirm --needed --noprogressbar
rm -rf /tmp/yay
cd ~

yay --needed --noconfirm -S \
  burpsuite \
  gobuster \
  android-apktool \
  zsteg \
  ttf-symbola \
  nerd-fonts-fira-code \
  hash-identifier \
  pngcheck steghide \
  ngrok
  python-angr-git

pip install --user pwntools pillow

# Install gef
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# Install oh-my-fish
curl -L https://get.oh-my.fish | fish
chsh -s $(which fish) vagrant

# omf i shellder

pacman --noconfirm -Sc