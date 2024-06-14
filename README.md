# Setting up a new laptop

A not-so-ordered list of things I had to do while setting up my new laptop. Most of these things are work specific.

## Things to install

- Chrome and/or ff. Sign in to get extenions.
- Xcode
- Homebrew
- iTerm
- oh-my-zsh (after installing zsh below)
- Docker
- Virtual box
- Vagrant
- Vundle + vim plugins

## Brew install

- zsh
- zsh-completions
- reattach-to-user-namespace
- vim (override system vim)
- tmux
- brew tap homebrew/cask-fonts && brew cask install font-hack-nerd-font
- font-source-code-pro

## iTerm2

Preset- Jetbrains Darcula

## Vim

### Autocompletion

`jedi-vim` and `YouCompleteMe` will be installed with vundle. To finish setup of ycm, go into the plugin and run `python setup.py --clang-completer`.

## Random notes

- If vim registers don't work, `chown $USER ~/.viminfo` and `chmod u+w .viminfo`
- You may have to update the user in the iterm settings file
- The dracula vim theme doesn't always install correctly. If it's in .vim/bundle, move the colors folder to `~/.vim/colors`. You may be able to just grab that folder from the git repo.
