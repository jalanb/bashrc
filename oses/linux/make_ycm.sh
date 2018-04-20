cd ~
rm -rf ~/ycm_build
mkdir ~/ycm_build
cd ~/ycm_build
cmake  -DPYTHON_INCLUDE_DIRS=$HOME/include/python/ -DPYTHON_LIBRARY=$HOME/lib/python.7/config/libpython2.7.a -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs
