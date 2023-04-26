#! /bin/bash -x




OPT_ROOT=/opt/jabs

type deactivate 2>/dev/null && deactivate

cd "{{ python_prefix }}"

script_="$BASH_SOURCE"
script_name_=$(basename "$script_")
script_dir_=$(dirname $(readlink -f "$script_"))
script_args_="$@"

mkd () {
    mkdir -p "$1" >/dev/null 2>&1
}

rmd () {
    [[ -d "$1" ]] && rm -rf "$1"
    mkd "$1"
}

rmcd () {
    rmd "$1"
    cd "$1"
}

rm_pythons () {
    local options_=-f user_=
    [[ $3 == -r ]] && options_=-rf
    [[ $3 == [-][r]*[f] ]] && user_=sudo
    (
        cd "{{ python_prefix }}"
        $user_ rm $options_ $(fd -t $2 "$1" ) 
    ) >/dev/null 2&>1
    return 0
}

rm_dirs () {
    [[ $1 ]] || return 1
    rm_pythons "$1" d -r
}

rm_files () {
    [[ $1 ]] || return 1
    rm_pythons "$1" f -f
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
    local prefix_py_="{{ python_prefix }}"
    local prefix_lib_="$prefix_py_/lib"
    ./configure --prefix="$prefix_py_" LDFLAGS="-Wl,-rpath $prefix_lib_"
    make
    make altinstall  # makes python3.10 and python3, leaves python
}

which_cmd () {
    which $1 > /dev/null 2>&1
}

brew_yum () {
    local cmd_=
    for cmd_ in brew dnf yum aptget; do
        if which_cmd $cmd_; then
            echo $cmd_
            return 0
        fi
    done
    return 1
}

yummy () {
    local brewer_=$(brew_yum)
    [[ $brewer_ == yum ]] || [[ $brewer_ == dnf ]]
}

brewy () {
    [[ $(brew_yum) == brew ]]
}

getty () {
    [[ $(brew_yum) == aptget ]]
}

yum_brew () {
    $(brew_yum) "$@"
}

sudo_yum () {
    yummy || return  1
    sudo yum -y "$@"
}

sudo_brew () {
    # sudo make me a sandwich
    brew "$@"
}

dev_install () {
    sudo_yum groupinstall 'development tools'
}

yum_install () {
    sudo_yum install "$@"
}

yum_update () {
    sudo_yum clean all
    sudo_yum uodate
}

brew_install () {
    sudo_brew install "$@"
}

brew_uodate () {
    sudo_brew update
}

if yummy; then
    yum_update
    local_install=yum_install
elif if brewy; then
    brew_update
    local_install=brew_install
fi

if yummy; then
    SUDO_YUM="sudo yum -y"
    LOCAL_INSTALL="$SUDO_YUM install"
elif [[ $LOCAL_INSTALLER == brew ]]; then
    LOCAL_INSTALL="brew install"
fi



set_up () {
    local bin_="{{ python_prefix }}/bin"
    mkd "$bin_"
    export PATH="$bin_:/usr/local/bin:/bin:/usr/bin"
}

install_python_compiler () {
    dev_install || return 1

    yum_install zlib-devel
    yum_install bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel
    yum_install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel libffi-devel
}

python_version () {
    local python3_=$1
    test -x $python3_ || python3_=python3
    $python3_ --version | sed -e "s,P[a-z]* ,,"
}

install_python () {
    local local_=$(python_version python3)
    local version_=3.10.0b4
    local_install wget 
    wget --quiet --no-check-certificate https://www.python.org/ftp/python/${expected_version_}/Python-${expected_version_}.tgz
    tar zxf Python-${expected_version_}.tgz
    (
        cd Python-${expected_version_}
        make_python
    )
    rm -rf Python-${expected_version_}*
}

install_pip () {
    install_py ensurepip 
    install_py pip install --upgrade pip
}

install_source_python () {
    set_up
    install_python_compiler
    install_python
    install_pip
}

log_install_python () {
    script="$0"
    script_name="$(basename $script)"
    log_name="${script_name/.sh/{{python_version}}}.log"
    log_file="{{portal_logs}}/$log_name"
    install_source_python > "$log_file" 2>&1
}

log_install_python"$BASH_SOURCE"
