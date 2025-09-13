#!/bin/bash
#
# Harness Terraform Module Documentation Generator
# Generates README.md from README.yaml for consistent team documentation
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

# Check if yq is available
check_dependencies() {
    if ! command -v yq &> /dev/null; then
        error "yq is required but not installed. Please install it first: https://github.com/mikefarah/yq"
    fi
}

# Get script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
README_YAML="$PROJECT_DIR/README.yaml"
README_MD="$PROJECT_DIR/README.md"

# Check if README.yaml exists
check_readme_yaml() {
    if [[ ! -f "$README_YAML" ]]; then
        error "README.yaml not found at $README_YAML"
    fi
}

# Generate terraform-docs table
generate_terraform_docs_table() {
    if command -v terraform-docs &> /dev/null; then
        if terraform-docs markdown table . 2>/dev/null; then
            return 0
        fi
    fi

    # Fallback if terraform-docs is not available or fails
    cat << 'EOF'
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
EOF
}

# Format usage examples section
format_usage_examples() {
    local yaml_file="$1"

    if ! yq e '.usage' "$yaml_file" | grep -q .; then
        return 0
    fi

    echo "## Usage"
    echo

    local length
    length=$(yq e '.usage | length' "$yaml_file")

    for ((i=0; i<length; i++)); do
        local name description code
        name=$(yq e ".usage[$i].name" "$yaml_file")
        description=$(yq e ".usage[$i].description" "$yaml_file")
        code=$(yq e ".usage[$i].code" "$yaml_file")

        if [[ "$name" != "null" ]]; then
            echo "### $name"
            echo
        fi

        if [[ "$description" != "null" ]]; then
            echo "$description"
            echo
        fi

        if [[ "$code" != "null" ]]; then
            echo '```hcl'
            echo "$code"
            echo '```'
            echo
        fi
    done
}

# Format examples section
format_examples_section() {
    local yaml_file="$1"

    if ! yq e '.examples' "$yaml_file" | grep -q .; then
        return 0
    fi

    echo "## Examples"
    echo

    local length
    length=$(yq e '.examples | length' "$yaml_file")

    for ((i=0; i<length; i++)); do
        local name description url
        name=$(yq e ".examples[$i].name" "$yaml_file")
        description=$(yq e ".examples[$i].description" "$yaml_file")
        url=$(yq e ".examples[$i].url" "$yaml_file")

        echo "- **$name**: $description"
        if [[ "$url" != "null" ]]; then
            echo "  - [View Example]($url)"
        fi
    done
    echo
}

# Format related projects section
format_related_projects() {
    local yaml_file="$1"

    if ! yq e '.related' "$yaml_file" | grep -q .; then
        return 0
    fi

    echo "## Related Projects"
    echo

    local length
    length=$(yq e '.related | length' "$yaml_file")

    for ((i=0; i<length; i++)); do
        local name url description
        name=$(yq e ".related[$i].name" "$yaml_file")
        url=$(yq e ".related[$i].url" "$yaml_file")
        description=$(yq e ".related[$i].description" "$yaml_file")

        echo "- [$name]($url) - $description"
    done
    echo
}

# Format contributors section
format_contributors() {
    local yaml_file="$1"

    if ! yq e '.contributors' "$yaml_file" | grep -q .; then
        return 0
    fi

    echo "## Contributors"
    echo
    echo "| Avatar | Name | Email |"
    echo "|--------|------|-------|"

    local length
    length=$(yq e '.contributors | length' "$yaml_file")

    for ((i=0; i<length; i++)); do
        local name email github avatar name_link avatar_img
        name=$(yq e ".contributors[$i].name" "$yaml_file")
        email=$(yq e ".contributors[$i].email" "$yaml_file")
        github=$(yq e ".contributors[$i].github" "$yaml_file")
        avatar=$(yq e ".contributors[$i].avatar" "$yaml_file")

        # Handle name with optional GitHub link
        if [[ "$github" != "null" ]]; then
            name_link="[$name](https://github.com/$github)"
        else
            name_link="$name"
        fi

        # Handle avatar
        if [[ "$avatar" != "null" ]]; then
            avatar_img="<img src=\"$avatar\" width=\"32\" height=\"32\" alt=\"$name\">"
        else
            avatar_img=""
        fi

        # Handle null values
        [[ "$email" == "null" ]] && email=""

        echo "| $avatar_img | $name_link | $email |"
    done
    echo
}

# Format development section
format_development_section() {
    local yaml_file="$1"

    if ! yq e '.development' "$yaml_file" | grep -q .; then
        return 0
    fi

    local title description
    title=$(yq e '.development.title' "$yaml_file")
    description=$(yq e '.development.description' "$yaml_file")

    if [[ "$title" != "null" ]]; then
        echo "## $title"
        echo
    fi

    if [[ "$description" != "null" ]]; then
        echo "$description"
        echo
    fi

    # Check if precommit section exists
    if yq e '.development.precommit.enabled' "$yaml_file" | grep -q "true"; then
        echo "### Pre-commit Hooks"
        echo

        # Features
        if yq e '.development.precommit.features' "$yaml_file" | grep -q .; then
            echo "This module includes comprehensive pre-commit integration:"
            echo
            local features_length
            features_length=$(yq e '.development.precommit.features | length' "$yaml_file")

            for ((i=0; i<features_length; i++)); do
                local feature
                feature=$(yq e ".development.precommit.features[$i]" "$yaml_file")
                echo "- $feature"
            done
            echo
        fi

        # Setup
        local setup
        setup=$(yq e '.development.precommit.setup' "$yaml_file")
        if [[ "$setup" != "null" ]]; then
            echo "#### Setup"
            echo
            echo "$setup"
            echo
        fi

        # Benefits
        if yq e '.development.precommit.benefits' "$yaml_file" | grep -q .; then
            echo "#### Benefits"
            echo
            local benefits_length
            benefits_length=$(yq e '.development.precommit.benefits | length' "$yaml_file")

            for ((i=0; i<benefits_length; i++)); do
                local benefit
                benefit=$(yq e ".development.precommit.benefits[$i]" "$yaml_file")
                echo "- $benefit"
            done
            echo
        fi

        # Tip
        local tip
        tip=$(yq e '.development.precommit.tip' "$yaml_file")
        if [[ "$tip" != "null" ]]; then
            echo "$tip"
            echo
        fi

        # Docs link
        local docs_link
        docs_link=$(yq e '.development.precommit.docs_link' "$yaml_file")
        if [[ "$docs_link" != "null" ]]; then
            echo "For more information, see [$docs_link]($docs_link)."
            echo
        fi
    fi
}

# Generate complete README content
generate_readme() {
    local yaml_file="$1"
    local name description

    # Header section
    name=$(yq e '.name' "$yaml_file")
    description=$(yq e '.description' "$yaml_file")

    # Title
    if [[ "$name" != "null" ]]; then
        echo "# $name"
        echo
    fi

    # Description
    if [[ "$description" != "null" ]]; then
        echo "$description"
        echo
    fi

    # Badges
    if yq e '.badges' "$yaml_file" | grep -q .; then
        local badges_length
        badges_length=$(yq e '.badges | length' "$yaml_file")

        for ((i=0; i<badges_length; i++)); do
            local badge_name badge_image badge_url
            badge_name=$(yq e ".badges[$i].name" "$yaml_file")
            badge_image=$(yq e ".badges[$i].image" "$yaml_file")
            badge_url=$(yq e ".badges[$i].url" "$yaml_file")

            echo "[![$badge_name]($badge_image)]($badge_url)"
        done
        echo
    fi

    # Highlights
    if yq e '.highlights' "$yaml_file" | grep -q .; then
        local highlights_length
        highlights_length=$(yq e '.highlights | length' "$yaml_file")

        for ((i=0; i<highlights_length; i++)); do
            local text link
            text=$(yq e ".highlights[$i].text" "$yaml_file")
            link=$(yq e ".highlights[$i].link" "$yaml_file")

            if [[ "$link" != "null" ]]; then
                echo "> $text [Learn more]($link)"
            else
                echo "> $text"
            fi
        done
        echo
    fi

    # Usage examples
    format_usage_examples "$yaml_file"

    # Development section
    format_development_section "$yaml_file"

    # Terraform documentation
    echo "## Terraform Documentation"
    echo
    generate_terraform_docs_table
    echo

    # Examples
    format_examples_section "$yaml_file"

    # Related projects
    format_related_projects "$yaml_file"

    # Contributors
    format_contributors "$yaml_file"

    # License
    local license
    license=$(yq e '.license' "$yaml_file")
    if [[ "$license" != "null" ]]; then
        echo "$license"
        echo
    fi

    # Footer
    echo "---"
    echo
    echo "This README was generated from [README.yaml](README.yaml) using the Harness documentation generator."
}

# Main function
main() {
    log "Harness Terraform Module Documentation Generator"

    check_dependencies
    check_readme_yaml

    log "Loading configuration from $README_YAML"

    log "Generating README.md content..."

    # Generate README content to temporary file first
    local temp_readme
    temp_readme=$(mktemp)

    if ! generate_readme "$README_YAML" > "$temp_readme"; then
        rm -f "$temp_readme"
        error "Failed to generate README content"
    fi

    # Move temp file to final location
    mv "$temp_readme" "$README_MD"

    log "README.md written to $README_MD"
    log "✓ README.md generated successfully!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
