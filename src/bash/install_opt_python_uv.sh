#! /bin/bash -x

set -x

INSTALL_VERSION=3.13.3
MINOR_VERSION=3.13
script_="$BASH_SOURCE"


UV_ROOT=/opt/uv

rm_globs_in () {
    local options_=-f user_= type_=f
    local dir_="$1"; shift
    if [[ $1 =~ -[rfF]* ]]; then
        options_="-rf" 
        [[ $1 =~ [r] ]] && type_=d
        [[ $1 =~ [r][f] ]] && user_=sudo 
        [[ $1 =~ [F] ]] && user_=sudo 
        shift
    fi
    local glob_="$1"; shift
    [[ $glob_ ]] || return 1
    (
        cd "$dir_"
        $user_ rm $options_ $(fd -t $type_ $glob_ ) 
    ) >/dev/null 2>&1
    return 0
}

rm_old_python () {
    # Any old python libs "lying around" can break compilation
    # See https://bugs.python.org/issue29712#msg335598
    rm_globs_in "UV_ROOT" -F 'libpython3'
    rm_globs_in "UV_ROOT" -f '*.pyc'
    rm_globs_in "UV_ROOT" -f '*.pyo'
    rm_globs_in "UV_ROOT" -r '__pycache__'
}

is_command () {
    type "$1" >/dev/null 2>&1
}

set_up () {
    mkdir -p "${UV_ROOT}/bin"
    export PATH="${UV_ROOT}/bin:/usr/local/bin:/bin:/usr/bin"
    is_command wget || brew install wget 
    is_command deactivate && deactivate
    cd "$UV_ROOT"

}

in_tmp_dir() {
    (
        cd "$(mktemp -d)"
        "$@"
        rm -rf "$(readlink -f .)"
    )
}

make_python () {
    # --prefix to not interfere with system Python in /usr
    #   and LDFLAGS to allow such embedded Python to find correct library
    ./configure --prefix="$UV_ROOT" --with-openssl=/usr/local/opt/openssl/ --enable-shared --enable-optimizations LDFLAGS="-Wl,-rpath ${UV_ROOT}/lib"
    make
    make altinstall  # makes python3.10 and python3, leaves python
}

install_python () {
    local version_=$INSTALL_VERSION
    wget --quiet --no-check-certificate https://www.python.org/ftp/python/${version_}/Python-${version_}.tgz
    tar zxf Python-${version_}.tgz
    (
        cd Python-${version_}
        make_python
    )
}

install_pip () {
    local python_="${UV_BIN}/python${MINOR_VERSION}"
    if [[ -x $python_ ]]; then
        $python_ -m ensurepip 
        $python_ -m pip install --upgrade pip setuptools
    else
        echo "$python_ is not an executable" >&2
    fi
}

install_more () {
    local python_="${UV_BIN}/python${MINOR_VERSION}"
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
    in_tmp_dir install_python
    install_pip
    install_more
}

log_install_python () {
    local log_file_="${script_/.sh/$INSTALL_VERSION}.log"
    install_source_python > "$log_file_" 2>&1
}

log_install_python
