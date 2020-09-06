#!/bin/bash
die() {
    printf '%s\n' "$1" >&2
    exit 1
}

usage() {
    echo "usage: [-c|--commit]"
    exit 1
}

commit=
while :; do
    case $1 in
        -h|-\?|--help)
            usage; exit ;;
        -c|--commit)
            commit=1
            ;;
        --)
            shift
            break
            ;;
        *) break ;;
    esac

    shift
done


output_files=(
    ./dl/*
)
compile_md() {
    inputf="$1.md"
    outputf="$1.html"
    vorsch-md2html "$inputf" > "$outputf" || die "failed to compile $inputf"
    output_files+=("$outputf")
}

autoversion "./dl/ut99-in-2020-check.bat" "./dl/ut99-install-umod.bat"
compile_md "./index"
compile_md "./checksums"

if [[ $commit ]]; then
    md_repo_dir=$(realpath "$PWD")
    pages_repo_dir=$(realpath ../"$(basename "$PWD")"-pages)

    pushd "$pages_repo_dir" || die "failed to cd to $pages_repo_dir - we're assuming a working copy containing the pages branch"

    cp_and_add() {
        mkdir -p "$(dirname "$pages_repo_dir/$1")" || die "failed to mkdirs for $1"
        cp "$md_repo_dir/$1" "$pages_repo_dir/$1" || die "failed to copy $1"
        git add "$pages_repo_dir/$1" || die "failed to add $1"
    }

    for html in "${output_files[@]}"; do
        cp_and_add "$html"
    done
fi
