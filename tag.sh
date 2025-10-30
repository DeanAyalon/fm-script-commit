#!/bin/sh

# This script tags the current commit with the version specified by the user.
# - It pushes the tag to the remote repositories.
# - It creates a new release on GitHub with the specified version, with assets being files from the lfs directory, and description from release.md

# Utils
error() {
    echo "Error: $1"
    exit 1
}
help() {
    echo "Usage: $0 <version> or $0 help

        This script tags the current commit in both repositories with the version specified by the user.
        It also creates a new release on GitHub with the specified version, and description from release.md"
    exit $1
}

tag() {
    git tag -a "$1" --cleanup whitespace -F "$ctx/release.md" || error "$dir: Failed to create tag $1."
    git push --tags origin "$1" || error "$dir: Failed to push tag $1 to remote."
}
untag() {
    git tag -d "$1" || error "Failed to delete local tag $1."
    git push --delete origin "$1" || error "Failed to delete remote tag $1."
}
lfs() {
    cd lfs && dir=lfs
    $@
    cd .. && dir=fmp
}

# Check if the version argument is provided
[ -z "$1" ] && help 1
[ "$1" = "help" ] && help 0
VERSION=$1

# Context
cd "$(dirname "$0")"
ctx=$PWD
dir=fmp

# Check if the version is already tagged
if git rev-parse "$VERSION" > /dev/null 2>&1; then
    echo "Version $VERSION is already tagged."
    read -p "Do you want to override the tag? (y/N): " override
    [ "$override" != "y" ] && [ "$override" != "Y" ] && error "Exiting without tagging."

    # Delete the existing tag
    untag "$VERSION"
    lfs untag "$VERSION"
    echo "Deleted existing tag $VERSION."
fi

# Create a new tag
tag "$VERSION"
lfs tag "$VERSION"

# Prompt whether to release on github, (y/n/p) p for pre-release - always release as a draft (-d)
read -p "Release to GitHub? (Y)es / (n)o / (p)re-release: " release
if [ "$release" = "N" ] || [ "$release" = "n" ]; then 
    echo "Skipping GitHub release."
    exit 0
elif [ "$release" = "P" ] || [ "$release" = "p" ]; then release="-p"
else unset release
fi

# Create a new release on GitHub
gh release create "$VERSION" -dt "$VERSION" $release \
    --notes-from-tag lfs/* || error "Failed to create GitHub release for $VERSION."
