#!/bin/bash

latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

if [ -z "$latest_tag" ]; then
    new_tag="v1.0.0"
    echo "No existing tags found. Creating initial tag: $new_tag"
else
    echo "Current tag: $latest_tag"
    version=${latest_tag#v}

    IFS='.' read -r major minor patch <<< "$version"

    patch=$((patch + 1))

    if [ "$patch" -ge 10 ]; then
        minor=$((minor + 1))
        patch=0
    fi
    
    new_tag="v${major}.${minor}.${patch}"
    echo "New tag: $new_tag"
fi

read -p "Create and push tag $new_tag? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Aborted."
    exit 1
fi

git tag "$new_tag"

git push origin "$new_tag"

echo "Tag $new_tag created and pushed successfully!"
