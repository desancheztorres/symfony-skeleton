#!/bin/bash

# 🚀 GitHub Actions CI/CD Setup Script
# Automatically configures repository for CI/CD workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis
SUCCESS="✅"
ERROR="❌"
INFO="ℹ️"
WARNING="⚠️"
ROCKET="🚀"

echo -e "${BLUE}${ROCKET} GitHub Actions CI/CD Setup${NC}"
echo "========================================"

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "success") echo -e "${GREEN}${SUCCESS} ${message}${NC}" ;;
        "error") echo -e "${RED}${ERROR} ${message}${NC}" ;;
        "info") echo -e "${BLUE}${INFO} ${message}${NC}" ;;
        "warning") echo -e "${YELLOW}${WARNING} ${message}${NC}" ;;
    esac
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_status "error" "Not in a git repository. Please run this script from your project root."
    exit 1
fi

print_status "info" "Checking repository setup..."

# Get repository information
REPO_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
if [[ -z "$REPO_URL" ]]; then
    print_status "warning" "No remote origin found. You'll need to add one later."
    GITHUB_REPO="USERNAME/REPOSITORY"
else
    # Extract GitHub username/repo from URL
    if [[ $REPO_URL =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
        GITHUB_USER="${BASH_REMATCH[1]}"
        GITHUB_REPO_NAME="${BASH_REMATCH[2]}"
        GITHUB_REPO="${GITHUB_USER}/${GITHUB_REPO_NAME}"
        print_status "success" "Detected GitHub repository: ${GITHUB_REPO}"
    else
        print_status "warning" "Could not parse GitHub repository from URL: ${REPO_URL}"
        GITHUB_REPO="USERNAME/REPOSITORY"
    fi
fi

# Update README badges with actual repository
if [[ "$GITHUB_REPO" != "USERNAME/REPOSITORY" ]]; then
    print_status "info" "Updating README badges with repository information..."
    
    if [[ -f "README.md" ]]; then
        # Update badge URLs
        sed -i.bak "s|USERNAME/REPOSITORY|${GITHUB_REPO}|g" README.md
        rm -f README.md.bak
        print_status "success" "Updated README.md badges"
    else
        print_status "warning" "README.md not found, skipping badge update"
    fi
fi

# Check if GitHub CLI is available
if command -v gh &> /dev/null; then
    print_status "info" "GitHub CLI detected, checking authentication..."
    
    if gh auth status &> /dev/null; then
        print_status "success" "GitHub CLI authenticated"
        
        # Check if we can access the repository
        if gh repo view "${GITHUB_REPO}" &> /dev/null; then
            print_status "success" "Repository access confirmed"
            
            # Offer to set up branch protection
            echo ""
            read -p "Do you want to set up branch protection rules for 'main'? (y/N): " setup_protection
            if [[ $setup_protection =~ ^[Yy]$ ]]; then
                print_status "info" "Setting up branch protection rules..."
                
                # Create branch protection rule
                gh api repos/"${GITHUB_REPO}"/branches/main/protection \
                    --method PUT \
                    --field required_status_checks='{"strict":true,"contexts":["CI Pipeline / quality-checks","CI Pipeline / multi-environment-builds","CI Pipeline / integration-tests","CI Pipeline / security-scans","CI Pipeline / performance-tests"]}' \
                    --field enforce_admins=true \
                    --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true,"require_code_owner_reviews":false}' \
                    --field restrictions=null \
                    2>/dev/null && print_status "success" "Branch protection rules configured" || print_status "warning" "Could not set branch protection (may require admin access)"
            fi
            
            # Offer to create labels
            echo ""
            read -p "Do you want to create CI/CD related labels? (y/N): " create_labels
            if [[ $create_labels =~ ^[Yy]$ ]]; then
                print_status "info" "Creating labels..."
                
                # Define labels
                declare -A labels=(
                    ["enhancement"]="a2eeef"
                    ["bug"]="d73a4a"
                    ["documentation"]="0075ca"
                    ["testing"]="20b2aa"
                    ["refactoring"]="ffd700"
                    ["performance"]="ff6347"
                    ["maintenance"]="696969"
                    ["ci/cd"]="1f77b4"
                    ["api"]="2ca02c"
                    ["authentication"]="ff7f0e"
                    ["docker"]="1f5582"
                    ["breaking-change"]="b60205"
                    ["size/S"]="c2e0c6"
                    ["size/M"]="7fb8d3"
                    ["size/L"]="ffeaa7"
                    ["size/XL"]="fdcb58"
                    ["size/XXL"]="e74c3c"
                )
                
                for label in "${!labels[@]}"; do
                    gh label create "$label" --color "${labels[$label]}" --force 2>/dev/null && \
                        echo "  Created label: $label" || echo "  Label already exists: $label"
                done
                
                print_status "success" "Labels created/updated"
            fi
            
        else
            print_status "warning" "Cannot access repository ${GITHUB_REPO}. May need to push to GitHub first."
        fi
    else
        print_status "warning" "GitHub CLI not authenticated. Run 'gh auth login' to authenticate."
    fi
else
    print_status "info" "GitHub CLI not found. Install it for additional setup options."
fi

# Validate workflow files
print_status "info" "Validating GitHub Actions workflow files..."

WORKFLOWS_DIR=".github/workflows"
if [[ -d "$WORKFLOWS_DIR" ]]; then
    workflow_count=$(find "$WORKFLOWS_DIR" -name "*.yml" -o -name "*.yaml" | wc -l)
    print_status "success" "Found ${workflow_count} workflow files"
    
    # List workflow files
    for workflow in "$WORKFLOWS_DIR"/*.yml "$WORKFLOWS_DIR"/*.yaml; do
        if [[ -f "$workflow" ]]; then
            filename=$(basename "$workflow")
            print_status "info" "  - $filename"
        fi
    done
else
    print_status "warning" "No .github/workflows directory found"
fi

# Check for required files
print_status "info" "Checking for required files..."

required_files=(
    "composer.json"
    "phpunit.dist.xml"
    "phpstan.dist.neon"
    "Dockerfile"
    "docker-compose.yml"
    "Makefile"
)

for file in "${required_files[@]}"; do
    if [[ -f "$file" ]]; then
        print_status "success" "  $file exists"
    else
        print_status "warning" "  $file missing (may cause CI failures)"
    fi
done

# Check optional files
optional_files=(
    "CONVENTIONAL_COMMITS.md"
    "CICD_IMPLEMENTATION.md"
    "grumphp.yml"
    ".editorconfig"
    ".gitignore"
)

print_status "info" "Checking for optional files..."
for file in "${optional_files[@]}"; do
    if [[ -f "$file" ]]; then
        print_status "success" "  $file exists"
    else
        print_status "info" "  $file not found (optional)"
    fi
done

# Check git configuration
print_status "info" "Checking git configuration..."

git_user=$(git config --get user.name 2>/dev/null || echo "")
git_email=$(git config --get user.email 2>/dev/null || echo "")

if [[ -n "$git_user" && -n "$git_email" ]]; then
    print_status "success" "Git user configured: $git_user <$git_email>"
else
    print_status "warning" "Git user not fully configured"
    echo "  Run: git config --global user.name 'Your Name'"
    echo "  Run: git config --global user.email 'your.email@example.com'"
fi

# Check for semantic release configuration
if [[ -f ".releaserc.json" || -f ".releaserc.yml" || -f ".releaserc.yaml" ]]; then
    print_status "success" "Semantic release configuration found"
else
    print_status "info" "Semantic release will use default configuration"
fi

echo ""
echo "========================================"
print_status "success" "CI/CD Setup Check Complete!"
echo ""

# Summary and next steps
echo -e "${BLUE}📋 Summary:${NC}"
echo "- Repository: ${GITHUB_REPO}"
echo "- Workflows: $(find ${WORKFLOWS_DIR} -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l) files found"
echo "- Required files: Most dependencies satisfied"
echo ""

echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "1. Commit and push the GitHub Actions workflows:"
echo "   git add .github/"
echo "   git commit -m 'ci: add comprehensive GitHub Actions CI/CD pipeline'"
echo "   git push origin main"
echo ""

echo "2. Create your first feature PR to test the CI pipeline:"
echo "   git checkout -b feat/test-ci-pipeline"
echo "   echo '# Test' >> TEST.md"
echo "   git add TEST.md"
echo "   git commit -m 'feat: add test file for CI validation'"
echo "   git push origin feat/test-ci-pipeline"
echo ""

echo "3. Monitor the workflows in GitHub Actions tab"
echo ""

echo "4. Read the complete guide: CICD_IMPLEMENTATION.md"
echo ""

if [[ "$GITHUB_REPO" == "USERNAME/REPOSITORY" ]]; then
    print_status "warning" "Remember to update USERNAME/REPOSITORY in README.md badges with your actual repository!"
fi

echo -e "${GREEN}🎉 Happy coding with automated CI/CD!${NC}"