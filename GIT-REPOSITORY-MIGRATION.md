# Git Repository Migration

**Date:** 2026-01-15
**Status:** ✅ Complete

---

## Repository Migration Summary

The ReDispute repository has been successfully remapped to the new GitHub location.

### Old Repository
```
git@github.com:mlgrozev/claude-agents.git
```

### New Repository
```
https://github.com/melioraweb/redispute-app.git
```

---

## ✅ Migration Complete

The git remote has been updated and verified. All future pushes and pulls will use the new repository.

### Verification

```bash
$ git remote -v
origin	https://github.com/melioraweb/redispute-app.git (fetch)
origin	https://github.com/melioraweb/redispute-app.git (push)

$ git fetch origin
# Success! Connected to new repository
```

---

## 🔧 Optional: Switch to SSH Authentication

If you prefer to use SSH instead of HTTPS (recommended for easier authentication):

```bash
# Update to SSH URL
git remote set-url origin git@github.com:melioraweb/redispute-app.git

# Verify
git remote -v
```

**SSH Benefits:**
- No password prompts when pushing/pulling
- More secure
- Faster authentication

**HTTPS Benefits:**
- Works through firewalls
- Easier initial setup
- No SSH key configuration needed

---

## 📝 Common Git Commands with New Repository

### Pulling Latest Changes
```bash
git pull origin main
```

### Pushing Your Changes
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

### Creating a Feature Branch
```bash
# Create and switch to new branch
git checkout -b feature/your-feature-name

# Push to new repository
git push -u origin feature/your-feature-name
```

### Checking Repository Status
```bash
# View current status
git status

# View remote configuration
git remote -v

# View branch information
git branch -vv
```

---

## 🚀 Pushing Your Latest Work

Your current branch (main) is already tracking `origin/main` on the new repository.

To push your latest changes:

```bash
# Make sure you're on main branch
git checkout main

# Pull any remote changes first
git pull origin main

# Push your local commits
git push origin main
```

---

## 🔄 Handling Existing Branches

If you have other branches that need to track the new remote:

```bash
# List all branches
git branch -a

# For each branch, set upstream to new remote
git checkout branch-name
git branch --set-upstream-to=origin/branch-name

# Or push and set upstream in one command
git push -u origin branch-name
```

---

## 📋 Repository Information

### New Repository Details
- **Owner:** melioraweb
- **Repository:** redispute-app
- **URL:** https://github.com/melioraweb/redispute-app
- **Local Path:** /Users/mladen.grozev/Code/redispute

### Current Branch Status
```
* main 7935eb2 [origin/main] Merge pull request #8
```

### Latest Commits
```
7935eb2 Merge pull request #8 from mlgrozev/claude/shopify-landing-page-copy-GVIEu
d00d063 feat: Add V3 professional polish prompt - remove emojis, add logos, enhance trust
25ea604 Merge pull request #7 from mlgrozev/claude/shopify-landing-page-copy-GVIEu
a67baf7 feat: Add detailed polish feedback for Lovable landing page V2
a6fea59 Merge pull request #6 from mlgrozev/claude/shopify-landing-page-copy-GVIEu
```

---

## 🔐 Authentication Setup

### If Using HTTPS (Current Setup)

You may need to authenticate when pushing:

**Option 1: Personal Access Token (Recommended)**
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token (classic) with `repo` scope
3. Use token as password when prompted

**Option 2: GitHub CLI**
```bash
# Install GitHub CLI
brew install gh

# Authenticate
gh auth login

# Git will use GH CLI for authentication automatically
```

### If Using SSH

```bash
# Check if you have SSH key
ls -la ~/.ssh

# If no key exists, generate one
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
```

---

## ⚠️ Important Notes

### 1. Update CI/CD Pipelines
If you have CI/CD workflows (GitHub Actions, etc.), they will continue to work as they reference the repository context automatically.

### 2. Update Documentation
Search for any documentation that references the old repository URL and update:
```bash
# Search for old repository references
grep -r "mlgrozev/claude-agents" .

# Common files to check:
# - README.md
# - package.json (repository field)
# - .github/workflows/*.yml
# - Documentation files
```

### 3. Collaborator Access
Make sure all team members have access to the new repository:
- Repository → Settings → Collaborators and teams
- Add collaborators with appropriate permissions

### 4. Branch Protection Rules
If you had branch protection rules on the old repository, set them up on the new one:
- Settings → Branches → Branch protection rules
- Protect `main` branch (require PR reviews, status checks, etc.)

---

## 🧹 Cleanup (Optional)

### Archive Old Repository

If you want to preserve the old repository but prevent accidental pushes:

1. Go to old repository on GitHub
2. Settings → General → Danger Zone
3. Archive this repository

### Update package.json

If your `package.json` has a repository field, update it:

```json
{
  "repository": {
    "type": "git",
    "url": "https://github.com/melioraweb/redispute-app.git"
  }
}
```

---

## ✅ Verification Checklist

- [x] Git remote updated to new URL
- [x] Connection to new repository verified
- [x] Current branch tracking new remote
- [ ] Team members have access to new repository
- [ ] CI/CD pipelines updated (if applicable)
- [ ] Documentation updated with new URLs
- [ ] Branch protection rules configured
- [ ] Old repository archived (if desired)

---

## 🆘 Troubleshooting

### Permission Denied Error
```
remote: Permission denied to melioraweb/redispute-app.
```

**Solution:** Check that you have write access to the repository.
```bash
# Verify your GitHub identity
gh auth status

# Or check SSH key is added to GitHub
ssh -T git@github.com
```

### Authentication Failed (HTTPS)
```
remote: Invalid username or password.
```

**Solution:** Use Personal Access Token instead of password.
```bash
# Install and authenticate with GitHub CLI
brew install gh
gh auth login
```

### Upstream Branch Not Set
```
fatal: The current branch has no upstream branch.
```

**Solution:** Set upstream when pushing.
```bash
git push -u origin main
```

---

## 📞 Need Help?

If you encounter issues:
1. Check GitHub status: https://www.githubstatus.com/
2. Review GitHub documentation: https://docs.github.com/
3. Contact repository owner: melioraweb organization

---

**Migration Status:** ✅ Successfully completed
**Date:** 2026-01-15
**Performed by:** Claude Code

All git operations will now use the new repository URL.
