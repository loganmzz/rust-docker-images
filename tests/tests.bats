#!/usr/bin/env bats

load helper

@test "initializing project" {
    # Arrange
    local testdir="$(mktestdir)"

    # Act
    cd "${testdir}"
    run rust_in_docker cargo new "newproject"; result=$?
    print_output
    
    # Assert
    [ "$status" -eq 0 ]
    [ -d "newproject" ]
    
    run find "newproject" ! -user "$(id -u)"
    echo "Files not owned by user '$(id -un)': $output"
    [ "$output" = "" ]
    [ "$status" -eq 0 ]

    run find "newproject" ! -group "$(id -g)"
    echo "Files not owned by group '$(id -gn)': $output"
    [ "$output" = "" ]
    [ "$status" -eq 0 ]

    rm -rf "${testdir}"
}

@test "building project without dependencies" {
    # Arrange
    local testdir="$(mktestdir)"
    local projectdir="$(get_resource 'helloworld')"

    # Act
    cd "${projectdir}"
    run rust_in_docker cargo build; result=$?
    print_output

    # Assert
    [ "$status" -eq 0 ]
    [ -f "${projectdir}/target/debug/helloworld" ]

    rm -rf "${testdir}"
}

@test "cleaning project" {
    # Arrange
    local testdir="$(mktestdir)"
    local projectdir="$(get_resource 'helloworld')"

    cd "${projectdir}"
    rust_in_docker cargo build

    # Act
    run rust_in_docker cargo clean; result=$?
    print_output

    # Assert
    [ "$status" -eq 0 ]
    [ ! -d "${projectdir}/target" ]

    rm -rf "${testdir}"
}

@test "running project without dependencies" {
    # Arrange
    local testdir="$(mktestdir)"
    local projectdir="$(get_resource 'helloworld')"

    # Act
    cd "${projectdir}"
    run rust_in_docker cargo run; result=$?
    print_output

    # Assert
    [ "$status" -eq 0 ]
    local lastlineindex=$(("${#lines[@]} - 1"))
    local lastline="$(clear_text "${lines[lastlineindex]}")"
    [ "${lastline}" == 'Hello, world!' ]

    rm -rf "${testdir}"
}

@test "run project tests" {
    # Arrange
    local testdir="$(mktestdir)"
    local projectdir="$(get_resource 'helloworld')"

    # Act
    cd "${projectdir}"
    run rust_in_docker cargo test; result=$?
    print_output

    # Assert
    [ "$status" -eq 0 ]
    
    local testresult0="$(clear_text ${lines[7]})"
    local testresult1="$(clear_text ${lines[20]})"
    [[ "${testresult0}" = 'test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out' ]]
    [[ "${testresult1}" = 'test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out' ]]

    rm -rf "${testdir}"
}

@test "generate project documentation" {
    # Arrange
    local testdir="$(mktestdir)"
    local projectdir="$(get_resource 'helloworld')"

    # Act
    cd "${projectdir}"
    run rust_in_docker cargo doc --all; result=$?
    print_output

    # Assert
    [ "$status" -eq 0 ]
    
    [ -f "${projectdir}/target/doc/helloworld/index.html" ]
    
    rm -rf "${testdir}"
}
