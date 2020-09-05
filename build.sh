#!/bin/bash
die() {
    printf '%s\n' "$1" >&2
    exit 1
}

outputHtmls=()
compile_md() {
    inputf="$1.md"
    outputf="$1.html"
    vorsch-md2html "$inputf" > "$outputf" || die "failed to compile $inputf"
    outputHtmls+=("$outputf")
}

compile_md "./index"


if ! git show-ref "refs/heads/gh-pages" >/dev/null; then
    git checkout --orphan "gh-pages" || die "failed to create & switch to gh-pages"
    git reset
else
    git checkout "gh-pages"  || die "failed to switch to gh-pages"
fi

git add "${outputHtmls[@]}" || die "git: failed to add ${outputHtmls[*]}"
