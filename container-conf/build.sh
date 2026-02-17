#!/bin/bash
build_fedora_base_image
build_is_public=1

build_as_root() {
    install_yum_install python3
}

build_as_run_user() {
    cd "$build_guest_conf"
    # Must not match exactly so can check for it in test.sh and
    # this file is included in the layer.
    if [[ ! ${GITHUB_TOKEN:-} =~ some-big-secret ]]; then
        build_err 'GITHUB_TOKEN was not included'
    fi
    declare test=~/bin/radia-run-testimage
    # public repo so the credentials don't matter but will be tested
    install -m 755 radia-run-testimage.sh "$test"
    cat >> "$test" <<EOF
if [[ -e $build_guest_conf ]]; then
    echo '$build_guest_conf is visible in container' 1>&2
    exit 1
fi
EOF
    install_git_clone containers
    if [[ $(cd containers && git config --get remote.origin.url) =~ some-big-secret ]]; then
        build_err 'secret is in git remote.origin.url'
    fi
}
