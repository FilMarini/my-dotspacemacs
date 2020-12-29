all: spacemacs fonts dependencies

spacemacs:
	git clone -b develop --single-branch https://github.com/syl20bnr/spacemacs ~/.emacs.d

fonts:
	source install_scp.sh

dependencies:
	pip install -r requirements.txt
