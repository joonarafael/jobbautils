#!/bin/bash
set -e

current_version=$1
bump_mode=$2
sync_mode=$3

ai_changed=$1
be_changed=$2
fe_changed=$3

IFS='-' read -r ai_version be_version fe_version <<< "$current_version"

bump_version() {
    local version="$1"
    local mode="$2"
    IFS='.' read -r major minor patch <<< "$version"

    case "$mode" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
    esac
    echo "$major.$minor.$patch"
}

if [ "$ai_changed" = "true" ]; then
    ai_version=$(bump_version "$ai_version" "$bump_mode")
fi

if [ "$be_changed" = "true" ]; then
    be_version=$(bump_version "$be_version" "$bump_mode")
fi

if [ "$fe_changed" = "true" ]; then
    fe_version=$(bump_version "$fe_version" "$bump_mode")
fi

if [ "$sync_mode" = "true" ]; then
    compare_versions() {
        local v1="$1"
        local v2="$2"

        IFS='.' read -r v1_major v1_minor v1_patch <<< "$v1"
        IFS='.' read -r v2_major v2_minor v2_patch <<< "$v2"

        if (( v1_major > v2_major )); then
            echo "$v1"
        elif (( v1_major < v2_major )); then
            echo "$v2"
        elif (( v1_minor > v2_minor )); then
            echo "$v1"
        elif (( v1_minor < v2_minor )); then
            echo "$v2"
        elif (( v1_patch > v2_patch )); then
            echo "$v1"
        else
            echo "$v2"
        fi
    }

    max_version=$(compare_versions "$ai_version" "$be_version")
    max_version=$(compare_versions "$max_version" "$fe_version")

    ai_version="$max_version"
    be_version="$max_version"
    fe_version="$max_version"
fi

echo "$ai_version-$be_version-$fe_version"
