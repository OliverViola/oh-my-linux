# oh-my-linux

Personal dotfiles for Vim, Tmux, and Neovim.

## Contents

```
.
├── vim/
│   ├── vimrc              # Vim configuration
│   └── colors/
│       └── apprentice.vim # Color scheme
├── tmux/
│   └── tmux.conf.local    # Tmux local customization (for oh-my-tmux)
├── nvim/
│   ├── init.lua           # Neovim entry point
│   └── lua/               # Neovim Lua configs
└── install.sh             # Installation script
```

## Installation

```bash
git clone <your-repo-url> ~/workspace/oh-my-linux
cd ~/workspace/oh-my-linux
chmod +x install.sh
./install.sh
```

## What gets installed

### Vim
- `~/.vimrc` -> symlink to `vim/vimrc`
- `~/.vim/colors/apprentice.vim` -> symlink to color scheme
- Plugins installed via git:
  - [jedi-vim](https://github.com/davidhalter/jedi-vim) - Python autocompletion
  - [ctrlp](https://github.com/ctrlpvim/ctrlp.vim) - Fuzzy file finder
  - [commentary](https://tpope.io/vim/commentary.git) - Comment stuff out
  - [nerdtree](https://github.com/preservim/nerdtree) - File explorer

### Tmux
基于 [gpakosz/.tmux](https://github.com/gpakosz/.tmux) 配置框架。

- `~/.tmux/` - oh-my-tmux 主仓库（需单独 clone）
- `~/.tmux.conf` -> `~/.tmux/.tmux.conf`（由 oh-my-tmux 提供）
- `~/.tmux.conf.local` -> symlink to `tmux/tmux.conf.local`（个人自定义配置）

首次安装 tmux 配置：
```bash
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
```

### Neovim
- `~/.config/nvim` -> symlink to `nvim/`
=======
## requirements
- neovim>0.8.0
