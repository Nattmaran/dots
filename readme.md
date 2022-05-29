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


# Information about neovim and LSP support etc
Java requires a whole lot of extra downloads to work properly.
The other languages requires lsp clients and such as well but Java is the worst ofc.

You'll need to download and install jdt.ls lsp client for java, a vscode-extension to use
the integration with java-debug and nvim-dap, and make sure that all paths are correct.

I'll try to remember to write a proper install-script with explanations this is just dumping some
of the stuff i have in my head atm.
