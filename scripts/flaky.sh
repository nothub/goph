#!/usr/bin/env sh

set -eu
cd "$(dirname "$(realpath "$0")")/.."

failed=0
total=20

i=1
while [ "$i" -le "${total}" ]; do

    go clean -testcache

    set +e
    go test -v -vet='all' .
    status="$?"
    set -e

    case ${status} in
        0) ;;
        1) failed="$(expr "${failed}" + 1)" ;;
        *)
            echo "Failed with status: $?"
            exit 1
            ;;
    esac

    i=$(expr "$i" + 1)
done

printf "failed %s/%s times\n" "${failed}" "${total}"

if test "${failed}" -gt 0; then
    exit 1
fi
