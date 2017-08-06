# vim-colorful-go

vim-colorful-go is an addendum to [vim-go](https://github.com/fatih/vim-go)'s
syntax highlighting. This plugin assumes you have
[vim-go](https://github.com/fatih/vim-go) installed and is untested outside that
assumption.

| Before                                                                                     | After                                                                         |
| ---                                                                                        | ---                                                                           |
| ![Before Image 1](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/beforeimage1.png) | ![Image 1](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/image1.png) |
| ![Before Image 2](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/beforeimage2.png) | ![Image 2](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/image2.png) |
| ![Before Image 3](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/beforeimage3.png) | ![Image 3](https://s3.amazonaws.com/ajswis-images/vim-colorful-go/image3.png) |

## Features

Mostly, this plugin highlights non-native types when appropriate. It assumes
formatting matches the output of `gofmt`.

vim-colorful-go also uses the same highlighting option flags as `vim-go`.

Some things that are now highlighted:
* types in `type (...)` blocks
* type declarations in structs
* types in function parameters
* types in function returns
* literal struct fields
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

