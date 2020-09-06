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
            preview=1
            ;;
        --)
            shift
            break
            ;;
        *) break ;;
    esac

    shift
done


outputHtmls=()
compile_md() {
    inputf="$1.md"
    outputf="$1.html"
    vorsch-md2html "$inputf" > "$outputf" || die "failed to compile $inputf"
    outputHtmls+=("$outputf")
}

autoversion "./dl/ut99-in-2020-check.bat" "./dl/ut99-install-umod.bat"
compile_md "./index"
compile_md "./checksums"

if [[ $commit ]]; then
    if ! git show-ref "refs/heads/gh-pages" >/dev/null; then
        git checkout --orphan "gh-pages" || die "failed to create & switch to gh-pages"
        git reset
    else
        git checkout "gh-pages"  || die "failed to switch to gh-pages"
    fi

    git add "${outputHtmls[@]}" || die "git: failed to add ${outputHtmls[*]}"
fi
