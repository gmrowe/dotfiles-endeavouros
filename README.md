# My Dotfiles

A backup of my dotfiles for archiving in a source repository

## Requirements

This repository is structured to me usable with the GNU 
[`stow`](https://www.gnu.org/software/stow) tool.

## Usage

To deploy all the dotfiles as symlinks in the correct location with stow,
from the dotfile/ root directory enter the following command
```sh
stow */
```
