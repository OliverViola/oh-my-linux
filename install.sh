#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from home directory to dotfiles in this repo

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

backup_and_link() {
    local src=$1
    local dest=$2
    
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "${YELLOW}Backing up existing $dest to ${dest}.backup${NC}"
        mv "$dest" "${dest}.backup"
    elif [ -L "$dest" ]; then
        rm "$dest"
    fi
    
    ln -s "$src" "$dest"
    echo -e "${GREEN}Linked $dest -> $src${NC}"
}

# ==================== Vim ====================
echo ""
echo "=== Installing Vim configuration ==="

mkdir -p ~/.vim/colors
mkdir -p ~/.vim/pack/plugins/start
mkdir -p ~/.vim/pack/tpope/start
mkdir -p ~/.vim/pack/vendor/start

backup_and_link "$DOTFILES_DIR/vim/vimrc" ~/.vimrc
backup_and_link "$DOTFILES_DIR/vim/colors/apprentice.vim" ~/.vim/colors/apprentice.vim

# Install vim plugins
echo "Installing Vim plugins..."
if [ ! -d ~/.vim/pack/plugins/start/jedi-vim ]; then
    git clone https://github.com/davidhalter/jedi-vim.git ~/.vim/pack/plugins/start/jedi-vim
    echo "Installed jedi-vim"
fi

if [ ! -d ~/.vim/pack/plugins/start/ctrlp ]; then
    git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/pack/plugins/start/ctrlp
    echo "Installed ctrlp"
fi

if [ ! -d ~/.vim/pack/tpope/start/commentary ]; then
    git clone https://tpope.io/vim/commentary.git ~/.vim/pack/tpope/start/commentary
    echo "Installed commentary"
fi

if [ ! -d ~/.vim/pack/vendor/start/nerdtree ]; then
    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
    echo "Installed nerdtree"
fi

# ==================== Tmux ====================
echo ""
echo "=== Installing Tmux configuration ==="

# Install oh-my-tmux if not present
if [ ! -d ~/.tmux ]; then
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux
    ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
    echo "Installed oh-my-tmux"
fi

backup_and_link "$DOTFILES_DIR/tmux/tmux.conf.local" ~/.tmux.conf.local

# ==================== Neovim ====================
echo ""
echo "=== Installing Neovim configuration ==="

mkdir -p ~/.config
backup_and_link "$DOTFILES_DIR/nvim" ~/.config/nvim

echo ""
echo -e "${GREEN}=== Installation complete! ===${NC}"
