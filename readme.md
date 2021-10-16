# Arch Linux
- Install stow: pacman -S stow

Stow handles all folders in dotfiles directory as "packages".
It will install whatever files in a package in the parent direcory of dotfiles as symlinks.
If several packages share the same tree it will split open the symlink into directories.

Unfortunately the --dotfiles option doesn'nt work when splitting open symlinks so I have
have to have .config folders instead of prefixed "dot-" folders in my packages.

# Install
- export STOW_FOLDERS=fold1,fold2,fold3 etc
- Run ./install

# Uninstall
- export STOW_FOLDERS=fold1,fold2,fold3 etc
- Run ./uninstall
