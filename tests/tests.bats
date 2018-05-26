#!/usr/bin/env bats

load helper

@test "initializing project" {
    # Arrange
    local testdir="$(mktestdir)"

    # Act
    cd "${testdir}"
    run rust_in_docker cargo new "newproject"; result=$?
    echo "$output"
    
    # Assert
    [ "$status" -eq 0 ]
    [ -d "newproject" ]
    
    run find "newproject" ! -user "$(id -u)"
    echo "Files not owned by user '$(id -un)': $output"
    [ "$output" == "" ]
    [ "$status" -eq 0 ]

    run find "newproject" ! -group "$(id -g)"
    echo "Files not owned by group '$(id -gn)': $output"
    [ "$output" == "" ]
    [ "$status" -eq 0 ]

    rm -rf "${testdir}"
}
