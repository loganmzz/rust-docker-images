rust_in_docker() {
    docker run --rm --tty --user "$(id -u):$(id -g)" --volume $(pwd):$(pwd) --workdir $(pwd) -e "USER=$(id -un)" loganmzz/rust "$@"
}

mktestdir() {
    local dir="${BATS_TMPDIR}/bats.${PPID}/test.${BATS_TEST_NUMBER}"
    mkdir -p "${dir}"
    echo "${dir}"
}
