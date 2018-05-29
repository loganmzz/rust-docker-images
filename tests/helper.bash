rust_in_docker() {
    docker run --rm --tty --user "$(id -u):$(id -g)" --volume $(pwd):$(pwd) --workdir $(pwd) -e "USER=$(id -un)" loganmzz/rust:test "$@"
}

mktestdir() {
    local dir="${BATS_TMPDIR}/bats.${PPID}/test.${BATS_TEST_NUMBER}"
    [ ! -d "${dir}" ] && {
        echo "Using test working directory: ${dir}" >&2
        mkdir -p "${dir}"
    }
    echo "${dir}"
}

get_resource() {
    local in="${BATS_TEST_DIRNAME}/resources/$1"; shift
    local out=""
    if [ "$#" -gt 1 ]; then
        out="$(mktestdir)/$1"; shift
    else
        out="$(mktestdir)/$(basename "${in}")"
    fi
    echo "Copy resource" >&2
    echo "  from: ${in}" >&2
    echo "  to:   ${out}" >&2
    cp -r "${in}" "${out}"
    echo "${out}"
}

clear_text() {
    local sed_command=( sed -E 's/^[[:space:]]+|[[:space:]]+$|\x1b(\[[0-9]*(;[0-9]+)?[A-Za-z]|[()].)//g' )
    if [[ $# -eq 0 || "$1" == "-" ]]; then
        "${sed_command[@]}"
    else
        while [[ $# > 0 ]]; do
            echo "$1" | "${sed_command[@]}"
            shift
        done
    fi
}

print_output() {
    for ((i=0 ; "${#lines[@]}" - $i ; i++)); do
        printf "%03d:%s\n" "$i" "${lines[i]}"
    done | clear_text
}
