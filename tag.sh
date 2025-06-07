#!/bin/sh

# This script tags the current commit with the version specified by the user.
# - It pushes the tag to the remote repository.
# - It creates a new release on GitHub with the specified version, with asset being lfs/yeda-water.fmp12, and description from release.md

# Utils
error() {
    echo "Error: $1"
    exit 1
}
help() {
    echo "Usage: $0 <version> or $0 help

        This script tags the current commit with the version specified by the user.
        It also creates a new release on GitHub with the specified version, and description from release.md"
    exit $1
}

# Check if the version argument is provided
[ -z "$1" ] && help 1
[ "$1" = "help" ] && help 0
VERSION=$1

# Context
cd "$(dirname "$0")"

# Check if the version is already tagged
if git rev-parse "$VERSION" > /dev/null 2>&1; then
    echo "Version $VERSION is already tagged."
    read -p "Do you want to override the tag? (y/N): " override
    [ "$override" != "y" ] && [ "$override" != "Y" ] && error "Exiting without tagging."

    # Delete the existing tag
    git tag -d "$VERSION" || error "Failed to delete local tag $VERSION."
    git push --delete origin "$VERSION" || error "Failed to delete remote tag $VERSION."
    echo "Deleted existing tag $VERSION."
fi

# Create a new tag
git tag -a "$VERSION" --cleanup whitespace -F release.md || error "Failed to create tag $VERSION."
git push --tags origin "$VERSION" || error "Failed to push tag $VERSION to remote."

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
    --notes-from-tag lfs/*.fmp12 || error "Failed to create GitHub release for $VERSION."
