# vim-colorful-go

vim-colorful-go is an addendum to [vim-go](https://github.com/fatih/vim-go)'s
syntax highlighting. This plugin assumes you have
[vim-go](https://github.com/fatih/vim-go) installed and is untested outside that
assumption.

![Image 1](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/image1.png)

![Image 2](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/image2.png)

## Features

Mostly, this plugin highlights non-native types when appropriate. It also
assumes formatting matches the output of `gofmt`.

* Highlight types in var (...) blocks
* Highlight types in receivers
* Highlight types in structs
* Highlight types in function parameters
* Highlight types in function returns
* Highlight methods/functions the same
* Highlight literal struct fields
* Uses the same highlighting option flags as `vim-go`
* ..probably more I can't remember

## Install

vim-colorful-go follows the standard runtime path structure. You may use your
favorite package manager. Below are some helper lines for popular package
managers:

*  [Pathogen](https://github.com/tpope/vim-pathogen)
    * `git clone https://github.com/ajswis/vim-colorful-go.git ~/.vim/bundle/vim-colorful-go`
*  [vim-plug](https://github.com/junegunn/vim-plug)
    * `Plug 'ajswis/vim-colorful-go'`
*  [Vim packages](http://vimhelp.appspot.com/repeat.txt.html#packages)
    * `git clone https://github.com/ajswis/vim-colorful-go.git ~/.vim/pack/plugins/start/vim-colorful-go`

