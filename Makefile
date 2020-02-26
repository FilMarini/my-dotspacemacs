all: spacemacs fonts

spacemacs:
	git clone -b v0.200.13 --single-branch https://github.com/syl20bnr/spacemacs ~/.emacs.d

fonts:
	source install_scp.sh
