#!/bin/bash

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

script_path="$(dirname $0)"
java_apt_packages=(\
    "openjdk-23-doc" \
    "openjdk-23-jdk" \
    "openjdk-23-jre" \
    "openjdk-23-dbg" \
    "openjdk-23-jre-zero" \
    "openjdk-23-testsupport" \
)

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

is_root() {
    return $([ $(id -u) -eq 0 ])
}

is_java_installed() {
    return $(which java &> /dev/null)
}

is_java_home_set() {
    return $([ -n "${JAVA_HOME}" ])
}

find_java_home() {
    find /usr/lib/jvm \
        -maxdepth 1 \
        -type "d" \
        -name "java-23-openjdk*" \
        -printf "%p"
}

install_java_23_openjdk() {
    sudo apt-get update \
    && sudo apt-get install ${java_apt_packages[@]} -y 
}

run_mars() {
    java -jar $script_path/../lib/mars-4.5.0.jar        
}

# -----------------------------------------------------------------------------
# Main 
# -----------------------------------------------------------------------------

main() {
    if is_root;
    then
        echo "This script should not be invoked by root."
        echo "Please run this script as a normal user."
        exit 1
    fi

    if ! is_java_installed;
    then
        echo "java is not installed."
        echo "attempting to install java-23-openjdk..."
        install_java_23_openjdk
    fi

    if ! is_java_home_set;
    then
        JAVA_HOME="$(find_java_home)" run_mars
    else
        run_mars
    fi
}

main
