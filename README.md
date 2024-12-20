[![Docker](https://github.com/HolgerPeters/lilypond-github-action/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/HolgerPeters/lilypond-github-action/actions/workflows/docker-publish.yml) [![pre-commit](https://github.com/HolgerPeters/lilypond-github-action/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/HolgerPeters/lilypond-github-action/actions/workflows/pre-commit.yml)

# lilypond-github-action

Based on https://github.com/alexandre-touret/lilypond-github-action

## Purpose
This github action aims at generating music sheets from [Lilypond music score
source files](https://lilypond.org). It creates and run a Docker container
which execute Lilypond.

It could be useful if you want to store your Lilypond source files in Git and
publish them automatically into a web site.

## Prerequisites
Learn git, lilypond and [github pages](https://pages.github.com/)  :)

You also have to create two secrets corresponding to your git username and
email.
* `GIT_USERNAME`
* `GIT_EMAIL`

## Set up
First create a repository with [an action
workflow](https://github.com/features/actions). Then you can add the following
content :

```yaml

name: Generate Lilypond music sheets
on:
  push:
    branches:
    - gh-pages
jobs:
  build_sheets:
    runs-on: ubuntu-latest
    env:
      LILYPOND_FILES: '*.ly'
    steps:
    - name: Checkout Source
      uses: actions/checkout@v1
    - name: Get changed files
      id: getfile
      run: |
        echo "::set-output name=files::$(find ${{github.workspace}} -name "${{ env.LILYPOND_FILES }}" -printf "%P\n" | xargs)"
    - name: LILYPOND files considered echo output
      run: |
        echo ${{ steps.getfile.outputs.files }}
    - name: Generate PDF music sheets
      uses: HolgerPeters/lilypond-github-action@master
      with:
        args: -V -fpdf -fpng -fmidi ${{ steps.getfile.outputs.files }}
    - name: Push Local Changes
      run: |
        git config --local user.email "${{ secrets.GIT_USERNAME }}"
        git config --local user.name "${{ secrets.GIT_EMAIL }}"
        mkdir -p ${{github.workspace}}/docs/
        mv -f *.midi ${{github.workspace}}/docs/
        mv -f *.pdf ${{github.workspace}}/docs/
        mv -f *.png ${{github.workspace}}/docs/
        git add ${{github.workspace}}/docs/
        git commit -m "Add changes" -a
    - name: Push changes
      uses: ad-m/github-push-action@master
      with:
        branch: gh-pages
        github_token: ${{ secrets.GITHUB_TOKEN }}
```
