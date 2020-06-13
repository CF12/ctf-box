sudo hostname "cf12-arch"

# Synchronize repos
sudo pacman -Sy

# Setup reflector for faster mirros
sudo pacman --needed --noconfirm -S reflector
sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Install base packages
sudo pacman --needed --noconfirm -S \
  base-devel \
  git \
  go \
  python2 python2-pip \
  python python-pip \
  fish \
  zip p7zip \
  terminator \
  gdb radare2 ropper python-keystone python-unicorn radare2 \
  binwalk foremost imagemagick perl-image-exiftool ffmpeg \
  metasploit \
  fcrackzip pdfcrack john \
  wireshark-cli nmap sqlmap \
  tmux \
  xclip \
  curl

# Install yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sic --noconfirm --needed --noprogressbar
cd ~
rm -rf ./yay

yay --needed --noconfirm -S \
  burpsuite \
  gobuster \
  android-apktool \
  zsteg \
  ttf-symbola \
  nerd-fonts-fira-code \
  hash-identifier \
  pngcheck steghide \
  python-angr-git

pip install --user pwntools pillow

# Install gef
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# Install oh-my-fish
curl -L https://get.oh-my.fish | fish
sudo chsh -s $(which fish) vagrant

omf i shellder

sudo pacman --noconfirm -Sc