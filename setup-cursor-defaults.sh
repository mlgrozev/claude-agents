#!/bin/bash

# Setup Cursor as Default IDE on macOS
# Run this script to configure Cursor as your default code editor

echo "🎯 Setting up Cursor as default IDE..."
echo ""

# Step 1: Install cursor command
echo "📦 Step 1: Installing cursor command line tool"
echo "Run this command (requires sudo password):"
echo ""
echo "  sudo ln -sf \"/Applications/Cursor.app/Contents/Resources/app/bin/code\" /usr/local/bin/cursor"
echo ""
read -p "Press Enter after running the above command..."

# Step 2: Verify installation
echo ""
echo "🧪 Step 2: Verifying installation..."
if command -v cursor &> /dev/null; then
    echo "✅ cursor command installed successfully"
    cursor --version
else
    echo "❌ cursor command not found. Please run the command above first."
    exit 1
fi

# Step 3: Set as default for common file types
echo ""
echo "📝 Step 3: Setting Cursor as default for code files..."
echo ""
echo "To set Cursor as default for code files, you have two options:"
echo ""
echo "Option A - Use duti (command-line tool):"
echo "  1. Install duti: brew install duti"
echo "  2. Run the commands below:"
echo ""

# Generate duti commands for common file types
cat << 'DUTI'
# JavaScript/TypeScript
duti -s com.todesktop.230313mzl4w4u92 .js all
duti -s com.todesktop.230313mzl4w4u92 .jsx all
duti -s com.todesktop.230313mzl4w4u92 .ts all
duti -s com.todesktop.230313mzl4w4u92 .tsx all

# Web files
duti -s com.todesktop.230313mzl4w4u92 .html all
duti -s com.todesktop.230313mzl4w4u92 .css all
duti -s com.todesktop.230313mzl4w4u92 .scss all

# Config files
duti -s com.todesktop.230313mzl4w4u92 .json all
duti -s com.todesktop.230313mzl4w4u92 .yaml all
duti -s com.todesktop.230313mzl4w4u92 .yml all
duti -s com.todesktop.230313mzl4w4u92 .toml all

# Markdown & text
duti -s com.todesktop.230313mzl4w4u92 .md all
duti -s com.todesktop.230313mzl4w4u92 .txt all

# Python
duti -s com.todesktop.230313mzl4w4u92 .py all

# Shell scripts
duti -s com.todesktop.230313mzl4w4u92 .sh all
duti -s com.todesktop.230313mzl4w4u92 .zsh all
DUTI

echo ""
echo "Option B - Manual (via Finder):"
echo "  1. Right-click any code file (e.g., .js, .ts, .py)"
echo "  2. Select 'Get Info' (⌘I)"
echo "  3. Under 'Open with:', select Cursor"
echo "  4. Click 'Change All...' button"
echo "  5. Repeat for each file type you want"
echo ""

# Step 4: Update shell config
echo "📝 Step 4: Updating shell configuration..."
echo ""
echo "Add these lines to your ~/.zshrc:"
echo ""
cat << 'ZSHRC'
# Cursor as default editor
export EDITOR="cursor --wait"
export VISUAL="cursor --wait"
export GIT_EDITOR="cursor --wait"

# Convenient aliases
alias c="cursor"
alias c.="cursor ."
ZSHRC

echo ""
echo "Then run: source ~/.zshrc"
echo ""

# Step 5: Test
echo "✅ Step 5: Test your setup"
echo ""
echo "Try these commands:"
echo "  cursor .                    # Open current directory"
echo "  cursor package.json         # Open a file"
echo "  c.                          # Short alias to open current dir"
echo "  git config --global core.editor \"cursor --wait\"  # Set as git editor"
echo ""

echo "🎉 Setup complete! Cursor is now your default IDE."
