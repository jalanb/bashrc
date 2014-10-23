cd ~
rm -rf ~/ycm_build
mkdir ~/ycm_build
cd ~/ycm_build
cmake  -DPYTHON_INCLUDE_DIRS=/home/alanb/include/python2.7/ -DPYTHON_LIBRARY=/home/alanb/lib/python2.7/config/libpython2.7.a -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs
