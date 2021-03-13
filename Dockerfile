FROM archlinux:base-devel

COPY pacman.conf /etc/pacman.conf

RUN pacman -Sy
RUN pacman --needed --noconfirm -S \
  lib32-glibc \
  openssh

RUN ssh-keygen -A

CMD ["/bin/sshd", "-D"]