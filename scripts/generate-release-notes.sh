#!/bin/bash
# Release Notes Generator for Harness Terraform Modules
# Automates creation and maintenance of RELEASE_NOTES.md

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
RELEASE_NOTES_FILE="RELEASE_NOTES.md"
# MODULE_NAME=$(basename "$(pwd)")  # Kept for potential future use

# Helper functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to get current version from git tags
get_current_version() {
    git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0"
}

# Function to get next version
get_next_version() {
    local current_version="$1"
    local version_type="${2:-patch}"

    # Remove 'v' prefix if present
    current_version=${current_version#v}

    # Split version into components
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major=${VERSION_PARTS[0]:-0}
    local minor=${VERSION_PARTS[1]:-0}
    local patch=${VERSION_PARTS[2]:-0}

    case $version_type in
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
        *)
            error "Invalid version type: $version_type. Use major, minor, or patch."
            ;;
    esac

    echo "v${major}.${minor}.${patch}"
}

# Function to get commits since last tag
get_commits_since_last_tag() {
    local last_tag
    last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

    if [[ -n "$last_tag" ]]; then
        git log --oneline "${last_tag}..HEAD"
    else
        git log --oneline
    fi
}

# Function to parse conventional commits
parse_conventional_commit() {
    local commit="$1"
    local type=""
    local scope=""
    local breaking=""
    local description=""

    # Extract conventional commit format: type(scope): description
    if [[ $commit =~ ^[a-f0-9]+[[:space:]]+(feat|fix|docs|style|refactor|test|chore|ci|build|perf) ]]; then
        type="${BASH_REMATCH[1]}"
        # Extract scope if present
        if [[ $commit =~ \(([^\)]+)\) ]]; then
            scope="(${BASH_REMATCH[1]})"
        fi
        # Check for breaking change indicator
        if [[ $commit =~ \! ]]; then
            breaking="!"
        fi
        # Extract description after the colon
        if [[ $commit =~ :[[:space:]]*(.+)$ ]]; then
            description="${BASH_REMATCH[1]}"
        else
            description=$(echo "$commit" | sed 's/^[a-f0-9]\+ [a-zA-Z]*[^:]*: *//')
        fi
    else
        # Fallback: analyze commit message for keywords
        if [[ $commit =~ (feat|add|new|implement) ]]; then
            type="feat"
        elif [[ $commit =~ (fix|bug|patch|resolve) ]]; then
            type="fix"
        elif [[ $commit =~ (doc|readme|example|comment) ]]; then
            type="docs"
        elif [[ $commit =~ (refactor|clean|reorganize) ]]; then
            type="refactor"
        elif [[ $commit =~ (style|format|lint) ]]; then
            type="style"
        elif [[ $commit =~ (test|spec) ]]; then
            type="test"
        elif [[ $commit =~ (ci|build|deploy|makefile|pipeline) ]]; then
            type="build"
        elif [[ $commit =~ (chore|update|bump|upgrade) ]]; then
            type="chore"
        elif [[ $commit =~ (perf|performance|optimize) ]]; then
            type="perf"
        else
            type="other"
        fi
        description=$(echo "$commit" | sed 's/^[a-f0-9]\+ //')
    fi

    echo "$type|$scope|$breaking|$description"
}

# Function to format commit entry
format_commit_entry() {
    local commit="$1"
    local parsed
    parsed=$(parse_conventional_commit "$commit")

    IFS='|' read -ra PARTS <<< "$parsed"
    local type="${PARTS[0]}"
    local scope="${PARTS[1]}"
    local breaking="${PARTS[2]}"
    local description="${PARTS[3]}"

    # Extract commit hash for reference
    local hash
    hash=$(echo "$commit" | cut -d' ' -f1 | cut -c1-7)

    # Format description with proper capitalization
    local formatted_desc
    formatted_desc=$(echo "$description" | sed 's/^./\U&/')

    # Add scope if present
    if [[ -n "$scope" ]]; then
        scope=$(echo "$scope" | tr -d '()')
        echo "- **${scope}**: $formatted_desc ($hash)"
    else
        echo "- $formatted_desc ($hash)"
    fi
}

# Function to categorize commits with better analysis
categorize_commits() {
    local commits="$1"
    local has_content=false

    # Arrays to hold categorized commits
    local features=()
    local fixes=()
    local docs=()
    local infrastructure=()
    local refactoring=()
    local performance=()
    local breaking=()
    local other=()

    # Process each commit
    while IFS= read -r commit; do
        [[ -z "$commit" ]] && continue

        local parsed
        parsed=$(parse_conventional_commit "$commit")

        IFS='|' read -ra PARTS <<< "$parsed"
        local type="${PARTS[0]}"
        local breaking_flag="${PARTS[2]}"

        local formatted_entry
        formatted_entry=$(format_commit_entry "$commit")

        # Categorize by type
        case "$type" in
            feat)
                features+=("$formatted_entry")
                has_content=true
                ;;
            fix)
                fixes+=("$formatted_entry")
                has_content=true
                ;;
            docs)
                docs+=("$formatted_entry")
                has_content=true
                ;;
            build|ci)
                infrastructure+=("$formatted_entry")
                has_content=true
                ;;
            refactor|style)
                refactoring+=("$formatted_entry")
                has_content=true
                ;;
            perf)
                performance+=("$formatted_entry")
                has_content=true
                ;;
            *)
                other+=("$formatted_entry")
                has_content=true
                ;;
        esac

        # Check for breaking changes
        if [[ "$breaking_flag" == "!" ]] || echo "$commit" | grep -qi "breaking\|break"; then
            breaking+=("$formatted_entry")
        fi
    done <<< "$commits"

    # Output categorized sections
    if [[ ${#features[@]} -gt 0 ]]; then
        echo "### 🚀 Features"
        printf '%s\n' "${features[@]}"
        echo ""
    fi

    if [[ ${#fixes[@]} -gt 0 ]]; then
        echo "### 🐛 Bug Fixes"
        printf '%s\n' "${fixes[@]}"
        echo ""
    fi

    if [[ ${#docs[@]} -gt 0 ]]; then
        echo "### 📚 Documentation"
        printf '%s\n' "${docs[@]}"
        echo ""
    fi

    if [[ ${#infrastructure[@]} -gt 0 ]]; then
        echo "### 🔧 Infrastructure"
        printf '%s\n' "${infrastructure[@]}"
        echo ""
    fi

    if [[ ${#performance[@]} -gt 0 ]]; then
        echo "### ⚡ Performance"
        printf '%s\n' "${performance[@]}"
        echo ""
    fi

    if [[ ${#refactoring[@]} -gt 0 ]]; then
        echo "### 🎨 Code Style & Refactoring"
        printf '%s\n' "${refactoring[@]}"
        echo ""
    fi

    if [[ ${#other[@]} -gt 0 ]]; then
        echo "### 🔄 Other Changes"
        printf '%s\n' "${other[@]}"
        echo ""
    fi

    if [[ ${#breaking[@]} -gt 0 ]]; then
        echo "### ⚠️ Breaking Changes"
        printf '%s\n' "${breaking[@]}"
        echo ""
        echo "**Note**: These changes may require updates to your configuration."
        echo ""
    fi

    # If no categorized content, show summary
    if [[ "$has_content" == false ]]; then
        echo "### 📋 Changes"
        echo "- Minor updates and improvements"
        echo ""
    fi
}

# Function to prompt for release description
prompt_for_release_description() {
    local version="$1"
    local release_type="$2"

    # Only prompt if we're in an interactive terminal and not automated
    if [[ -t 0 ]] && [[ "${AUTOMATED_RELEASE:-}" != "true" ]]; then
        echo ""
        log "Creating $release_type release $version"
        echo -e "${YELLOW}Please provide a brief description for this release (or press Enter to skip):${NC}"
        read -r -p "> " release_description
        echo "$release_description"
    else
        echo ""
    fi
}

# Function to create new release notes section
create_release_section() {
    local version="$1"
    local date="$2"
    local commits="$3"
    local version_type="$4"

    # Get release description if interactive
    local release_description
    release_description=$(prompt_for_release_description "$version" "$version_type")

    # Start with basic header
    cat << EOF
## $version ($date)

EOF

    # Add release description if provided
    if [[ -n "$release_description" ]]; then
        cat << EOF
$release_description

EOF
    fi

    # Add categorized commits
    categorize_commits "$commits"

    # Only add sections that are relevant based on the commits
    local has_breaking
    has_breaking=$(echo "$commits" | grep -qi "breaking\|break" && echo "true" || echo "false")

    # Add minimal boilerplate only if there are breaking changes
    if [[ "$has_breaking" == "true" ]]; then
        cat << EOF
### 📦 Migration Guide
- Review the breaking changes above
- Update your configurations accordingly

EOF
    fi

    echo "---"
    echo ""
}

# Function to check if RELEASE_NOTES.md exists
check_release_notes_exists() {
    [[ -f "$RELEASE_NOTES_FILE" ]]
}

# Function to backup existing release notes
backup_release_notes() {
    if check_release_notes_exists; then
        cp "$RELEASE_NOTES_FILE" "${RELEASE_NOTES_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        success "Backed up existing release notes"
    fi
}

# Function to create initial release notes file
create_initial_release_notes() {
    cat > "$RELEASE_NOTES_FILE" << 'EOF'
# Release Notes

This file tracks all notable changes to this Terraform module.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release structure

---

EOF
    success "Created initial $RELEASE_NOTES_FILE"
}

# Function to add new release section
add_new_release() {
    local version="$1"
    local version_type="$2"

    if ! check_release_notes_exists; then
        warn "Release notes file doesn't exist. Creating initial file."
        create_initial_release_notes
    fi

    backup_release_notes

    local date
    date=$(date +%Y-%m-%d)

    local commits
    commits=$(get_commits_since_last_tag)

    if [[ -z "$commits" ]]; then
        warn "No new commits found since last tag. Creating template anyway."
        commits="- Template release section created"
    fi

    # Create new release section
    local new_section
    new_section=$(create_release_section "$version" "$date" "$commits" "$version_type")

    # Insert after the "# Release Notes" header
    local temp_file
    temp_file=$(mktemp)

    {
        # Keep header and description
        sed -n '1,/^## \[Unreleased\]/p' "$RELEASE_NOTES_FILE"

        # Add new release section
        echo "$new_section"

        # Add remaining content (skip the Unreleased section header)
        sed -n '/^## \[Unreleased\]/,$p' "$RELEASE_NOTES_FILE" | tail -n +2
    } > "$temp_file"

    mv "$temp_file" "$RELEASE_NOTES_FILE"

    success "Added $version release section to $RELEASE_NOTES_FILE"
    log "Please review and edit the generated content before committing."
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
    init                Create initial RELEASE_NOTES.md file
    add [VERSION_TYPE]  Add new release section (VERSION_TYPE: major|minor|patch, default: patch)
    template           Generate release template for current changes
    help               Show this help message

Examples:
    $0 init                    # Create initial release notes file
    $0 add patch               # Add new patch release section
    $0 add minor               # Add new minor release section
    $0 template                # Generate template for current changes

The script will:
- Analyze git commits since the last tag
- Categorize changes by type (features, fixes, docs, etc.)
- Generate a structured release notes section
- Backup existing files before making changes
EOF
}

# Function to generate template
generate_template() {
    local current_version
    current_version=$(get_current_version)

    local commits
    commits=$(get_commits_since_last_tag)

    if [[ -z "$commits" ]]; then
        warn "No new commits found since last tag $current_version"
        return
    fi

    log "Changes since $current_version:"
    echo "$commits"
    echo ""

    log "Suggested release notes content:"
    categorize_commits "$commits"
}

# Main script logic
main() {
    local command="${1:-help}"

    case "$command" in
        init)
            if check_release_notes_exists; then
                warn "$RELEASE_NOTES_FILE already exists - creating backup and initializing new file"
                backup_release_notes
                log "Existing release notes backed up as ${RELEASE_NOTES_FILE}.backup.*"
            fi
            create_initial_release_notes
            ;;
        add)
            local version_type="${2:-patch}"
            local current_version
            current_version=$(get_current_version)
            local next_version
            next_version=$(get_next_version "$current_version" "$version_type")

            log "Current version: $current_version"
            log "Next version: $next_version"

            add_new_release "$next_version" "$version_type"
            ;;
        template)
            generate_template
            ;;
        get-next-version)
            local version_type="${2:-patch}"
            local current_version
            current_version=$(get_current_version)
            get_next_version "$current_version" "$version_type"
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            error "Unknown command: $command"
            show_usage
            ;;
    esac
}

# Ensure we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Not in a git repository"
fi

# Run main function with all arguments
main "$@"
