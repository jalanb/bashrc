#! /bin/bash

set -e

main () {
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
}

main
