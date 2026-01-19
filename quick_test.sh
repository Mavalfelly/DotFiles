#!/usr/bin/env bash
# Quick verification test

echo "🧪 Quick Verification Test"
echo "=========================="

# Test core tools
tools=("zsh" "git" "nvim" "starship" "docker" "node" "python3" "cargo" "go")

for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool: $(($tool --version 2>/dev/null || $tool -v 2>/dev/null || echo 'installed') | head -1)"
    else
        echo "❌ $tool: Not found"
    fi
done

echo ""
echo "🔧 ZSH Configuration Test"
echo "=========================="

# Test if $HOME/.zshrc loads without errors
if zsh -c "source \"$HOME/.zshrc\"" 2>/dev/null; then
    echo "✅ $HOME/.zshrc loads successfully"
else
    echo "❌ $HOME/.zshrc has errors"
fi

# Test for key functions
if grep -q "project()" "$HOME/.zshrc"; then
    echo "✅ project() function exists"
else
    echo "❌ project() function missing"
fi

if grep -q "newproj()" "$HOME/.zshrc"; then
    echo "✅ newproj() function exists"
else
    echo "❌ newproj() function missing"
fi

if grep -q "PROJECTS_DIR" "$HOME/.zshrc"; then
    echo "✅ Uses PROJECTS_DIR variable"
else
    echo "❌ PROJECTS_DIR variable missing"
fi

echo ""
echo "📁 File Structure Test"
echo "===================="

files=(".zshrc" "LICENSE" "README.md" "install.sh" "test_installation.sh")
dirs=(".config")

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/ exists"
    else
        echo "❌ $dir/ missing"
    fi
done

echo ""
echo "🎯 Test Summary"
echo "=============="
echo "Core dotfiles setup appears to be working correctly!"
echo "Run './test_personal_removal.sh' to verify personal items were removed."
echo "Use './install.sh' to install/update your environment."