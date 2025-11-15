#!/bin/bash
build_fedora_base_image
build_is_public=1

build_as_root() {
    install_yum_install screen
}

build_as_run_user() {
    cd "$build_guest_conf"
    # Must not match exactly so can check for it in test.sh and
    # this file is included in the layer.
    if [[ ! $GITHUB_TOKEN =~ some-big-secret ]]; then
        echo 'GITHUB_TOKEN was not included' 1>&2
        exit 1
    fi
    local test=~/bin/radia-run-testimage
    install -m 755 radia-run-testimage.sh "$test"
    cat >> "$test" <<EOF
if [[ -e $build_guest_conf ]]; then
    echo '$build_guest_conf is visible in container' 1>&2
    exit 1
fi
EOF
}
