#! /bin/bash -x

set -x

INSTALL_VERSION=3.10.0
MINOR_VERSION=3.10
script_="$BASH_SOURCE"
script_name_=$(basename "$script_")
script_dir_=$(dirname $(readlink -f "$script_"))
script_args_="$@"


PYTHON_PREFIX=/opt/jabs
PYTHON_BIN=${PYTHON_PREFIX}/bin
PYTHON_LIB=${PYTHON_PREFIX}/lib
DOWNLOADS=${PYTHON_PREFIX}/tmp

rm_paths () {
    local options_=-f user_=
    [[ $3 == -r ]] && options_=-rf
    [[ $3 == [-][r]*[f] ]] && user_=sudo
    (
        cd "$PYTHON_PREFIX"
        $user_ rm $options_ $(fd -t $2 "$1" ) 
    ) >/dev/null 2>&1
    return 0
}

rm_dirs () {
    [[ $1 ]] || return 1
    rm_paths "$1" d -r
}

rm_files () {
    [[ $1 ]] || return 1
    rm_paths "$1" f -f
}

rm_old_python () {
    # Any old python libs "lying around" can break compilation
    # See https://bugs.python.org/issue29712#msg335598
    rm_files libpython3
    rm_files *.pyc
    rm_files *.pyo
    rm_dirs __pycache__
}

make_python () {
    # --prefix to not interfere with system Python in /usr
    #   and LDFLAGS to allow such embedded Python to find correct library
    ./configure --prefix="$PYTHON_PREFIX" --with-openssl=/usr/local/opt/openssl/ --enable-shared --enable-optimizations LDFLAGS="-Wl,-rpath $PYTHON_LIB"
    make
    make altinstall  # makes python3.10 and python3, leaves python
}

is_command () {
    type "$1" >/dev/null 2>&1
}

set_up () {
    [[ -d "$PYTHON_BIN" ]] || mkdir -p "$PYTHON_BIN"
    export PATH="$PYTHON_BIN:/usr/local/bin:/bin:/usr/bin"
    is_command wget || brew install wget 
    is_command deactivate && deactivate
    cd "$PYTHON_PREFIX"

}

python_version () {
    python3_ --version | sed -e "s,P[a-z]* ,,"
}

install_python () {
    local version_=$INSTALL_VERSION
    [[ -d "$DOWNLOADS" ]] || mkdir -p "$DOWNLOADS"
    cd "$DOWNLOADS"
    wget --quiet --no-check-certificate https://www.python.org/ftp/python/${version_}/Python-${version_}.tgz
    tar zxf Python-${version_}.tgz
    (
        cd Python-${version_}
        make_python
    )
    rm -rf Python-${version_}*
}

install_pip () {
    local python_="${PYTHON_BIN}/python${MINOR_VERSION}"
    if [[ -x $python_ ]]; then
        $python_ -m ensurepip 
        $python_ -m pip install --upgrade pip setuptools
    else
        echo "$python_ is not an executable" >&2
    fi
}

install_more () {
    local python_="${PYTHON_BIN}/python${MINOR_VERSION}"
    local pip_install_="$python_ -m pip install"
    $pip_install_ ipython 
    $pip_install_ pudb3 
    $pip_install_ rich 
    $pip_install_ httpie 
    $pip_install_ pysyte 
    $pip_install_ bumpversion 
    $pip_install_ pytest 
    $pip_install_ tox 
}

install_source_python () {
    set_up
    install_python
    install_pip
    install_more
}

log_install_python () {
    local log_file_="${script_/.sh/$INSTALL_VERSION}.log"
    install_source_python > "$log_file_" 2>&1
}

log_install_python
