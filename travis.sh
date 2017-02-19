#!/bin/bash
set -e
set -o pipefail
trap 'echo FAILED' ERR EXIT
img=radiasoft/test
export radiasoft_secret_test=some-big-secret-xyzzy
curl radia.run | build_batch_mode=1 build_passenv=radiasoft_secret_test bash -s container-build
ver=$(
    docker images |
        perl -n -e 'm{^'"$img"'\s+(\d+\.\d+)} && print($1) && exit(0)'
)
out=$(docker run --rm -u vagrant $img:$ver /home/vagrant/bin/radia-run-testimage 2>&1)
if [[ $out =~ radiasoft_secret_test || $out =~ $radiasoft_secret_test ]]; then
    echo "environment contains secret or variable name: $out" 1>&2
    exit 1
fi
if [[ ! $out =~ $ver ]]; then
    echo "$ver: version didn't appear in out: $out" 1>&2
    exit 1
fi
trap '' EXIT
echo PASSED
