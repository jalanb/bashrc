#! /bin/bash

# Set up initialisation files for me on a new server
# Assuming as little as possible

as_root ()
{
    cd linux
    sudo bash make_software.sh
    local distro=$(python2.7 -c "import platform; print platform.linux_distribution()[0].lower()")
    if [[ -d $distro ]]; then
        for file in linux/$distro/*.sh
        do
            cat $file
        done
    fi
    sudo bash write_system_startups.sh
    sudo bash write_root_startups.sh
    sudo bash gnome/make_vim_default_editor.sh
    cd ..
    sudo bash network/company.sh
}

as_jab ()
{
    cd jab
    bash clean_directories.sh
    bash checkout_jab.sh
    bash set_ssh.sh
    bash write_jab_startup.sh
    cd ..
}

main ()
{
    as_root
    as_jab
}

export PATH=/bin:/usr/bin:/usr/local/bin
builtin cd
main
