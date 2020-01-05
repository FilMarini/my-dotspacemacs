all: patch

install_spacemacs:
	git clone -b v0.200.13 --single-branch https://github.com/syl20bnr/spacemacs ~/.emacs.d

patch: install_spacemacs
	make -C emacs_patches
