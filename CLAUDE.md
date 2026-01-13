# CLAUDE.md - AI Assistant Guide for Claude Agents Repository

**Last Updated**: 2026-01-12
**Repository**: Contains Studio AI Agents Collection
**Purpose**: Specialized AI agents for accelerating rapid development within 6-day sprint cycles

---

## 📋 Table of Contents

1. [Repository Overview](#repository-overview)
2. [Repository Structure](#repository-structure)
3. [Agent File Format](#agent-file-format)
4. [YAML Frontmatter Reference](#yaml-frontmatter-reference)
5. [System Prompt Guidelines](#system-prompt-guidelines)
6. [Development Workflows](#development-workflows)
7. [Git Conventions](#git-conventions)
8. [Creating New Agents](#creating-new-agents)
9. [Modifying Existing Agents](#modifying-existing-agents)
10. [Best Practices](#best-practices)
11. [Common Patterns](#common-patterns)
12. [The 6-Day Sprint Philosophy](#the-6-day-sprint-philosophy)

---

## Repository Overview

This repository is the **redispute** project workspace, which includes a collection of **38 specialized AI agents** stored in the `.claude/` subdirectory. Each agent is an expert in their domain, designed to work within a fast-paced studio environment that ships products in 6-day sprint cycles.

### Key Facts
- **Project**: redispute (PreventFlow/Disputifier)
- **Repository Path**: `/Users/mladen.grozev/Code/redispute/`
- **Total Agents**: 38 (across 8 departments)
- **Agent Location**: `.claude/agents/` subdirectory within the repository
- **File Format**: Markdown with YAML frontmatter
- **Primary Model**: Sonnet (84% of agents)
- **No Build Process**: Pure markdown repository
- **Deployment**: Agents are already in place and loaded automatically by Claude Code

### Core Philosophy
- Ship fast, iterate based on real user feedback
- 6-day sprint cycles for all projects
- Multi-agent collaboration expected
- Practical solutions over perfect code
- "Smooth is fast, fast is smooth"

### How Agents Are Used in This Repository

**Automatic Loading**: Agents stored in `.claude/agents/` are automatically loaded by Claude Code when working in this repository. No manual installation or copying required.

**Usage Pattern**:
1. **Working Directory**: Ensure you're in `/Users/mladen.grozev/Code/redispute/`
2. **Agent Access**: All 38 agents are immediately available for use
3. **Triggering**: Agents activate automatically based on:
   - Your task description matching their examples
   - Context-based triggers (code changes → test-writer-fixer)
   - Explicit requests mentioning agent names
4. **Multi-Agent Workflows**: Agents can collaborate and call each other via the Task tool

**Skills**: Custom skills in `.claude/skills/` extend functionality:
- `prd`: Generate Product Requirements Documents
- `prd-to-jira`: Convert PRDs to Jira user stories

**Knowledge Base**: The `knowledge/` directory contains project-specific research and strategy documents for PreventFlow and Disputifier.

---

## Repository Structure

```
/Users/mladen.grozev/Code/redispute/
├── .claude/
│   ├── agents/                 # All 38 specialized agents
│   │   ├── bonus/              # 2 agents: studio-coach, joker
│   │   ├── design/             # 5 agents: UI/UX, branding, visual design
│   │   ├── engineering/        # 7 agents: frontend, backend, mobile, AI, DevOps
│   │   ├── marketing/          # 7 agents: social media, growth, content
│   │   ├── product/            # 3 agents: feedback, trends, prioritization
│   │   ├── project-management/ # 3 agents: coordination, shipping, experiments
│   │   ├── studio-operations/  # 5 agents: analytics, finance, support, legal
│   │   └── testing/            # 5 agents: performance, API testing, benchmarking
│   └── skills/                 # Custom skills (prd, prd-to-jira)
├── knowledge/                  # Project knowledge base
│   └── init-research/          # Initial research docs (PreventFlow, Disputifier)
├── README.md                   # User-facing documentation
├── .gitignore                  # Standard git exclusions
└── CLAUDE.md                   # This file - AI assistant guide
```

### Department Breakdown

| Department | Agent Count | Focus Areas |
|------------|-------------|-------------|
| Engineering | 7 | Implementation, architecture, deployment |
| Marketing | 7 | Social media, growth, content creation |
| Design | 5 | UI/UX, branding, visual design |
| Studio Operations | 5 | Analytics, finance, support, compliance |
| Testing | 5 | Performance, quality, benchmarking |
| Product | 3 | Prioritization, feedback, trends |
| Project Management | 3 | Coordination, shipping, experiments |
| Bonus | 2 | Coaching, humor (studio-coach, joker) |

---

## Agent File Format

Every agent file follows this exact two-part structure:

```markdown
---
[YAML Frontmatter - Lines 1-8]
---

[System Prompt - Remainder of file]
```

### Example Agent Structure

```markdown
---
name: rapid-prototyper
description: "Use this agent when [scenario]. Examples:\n\n<example>..."
model: sonnet
color: green
tools: Write, Read, Edit, Bash, Grep, Glob
permissionMode: acceptEdits
---

You are an elite [role] who excels at [expertise]...

Your primary responsibilities:
1. **Responsibility One**: Description...
2. **Responsibility Two**: Description...
[...]

[Additional sections: Tech Stack, Best Practices, etc.]

Your goal is to [ultimate objective]...
```

---

## YAML Frontmatter Reference

### Required Fields

All 6 fields are mandatory for every agent:

#### 1. `name` (string)
- **Format**: kebab-case (lowercase with hyphens)
- **Pattern**: Descriptive role-based name
- **Examples**: `rapid-prototyper`, `feedback-synthesizer`, `whimsy-injector`
- **Convention**: Use active role names, not passive descriptors

#### 2. `description` (string)
- **Format**: Multi-line string in double quotes
- **Structure**:
  1. Opening: "Use this agent when [scenario]."
  2. Specialization: "This agent specializes in [expertise]."
  3. Examples: 3-4 detailed examples with XML-like tags

**Example Structure**:
```yaml
description: "Use this agent when you need to quickly create a new application prototype. This agent specializes in rapid development. Examples:\n\n<example>\nContext: [situation]\nuser: \"[user request]\"\nassistant: \"[response approach]\"\n<commentary>\n[why this example matters]\n</commentary>\n</example>\n\n[3 more examples...]"
```

**Important**: After recent fixes, YAML descriptions must be properly quoted to handle multi-line content and special characters.

#### 3. `model` (enum)
- **Options**: `sonnet` | `opus` | `haiku` | `inherit`
- **Distribution**:
  - `sonnet`: 32 agents (84%) - Balanced performance, default choice
  - `opus`: 5 agents (13%) - Complex reasoning, strategic planning
  - `haiku`: 1 agent (3%) - Fast, simple tasks

**Use Opus for**:
- Backend architecture decisions
- Financial/legal compliance
- Strategic planning (sprint-prioritizer)
- Complex multi-agent coordination (studio-coach)

**Use Haiku for**:
- Simple, quick tasks
- Repetitive operations
- Non-critical content generation

#### 4. `color` (enum)
- **Options**: `red` | `blue` | `green` | `yellow` | `purple` | `orange` | `pink` | `cyan`
- **Purpose**: Visual identification in Claude Code UI
- **Distribution**:
  - purple (7): Architecture, product, strategic roles
  - orange (6): Optimization, community, financial
  - blue (5): Analytical, research roles
  - cyan (4): Testing, AI, technical
  - green (4): Build, shipping, growth
  - pink (3): Social media, design
  - yellow (3): Playful, coaching
  - red (2): Performance, compliance

**Color Guidelines**:
- Red: Critical/urgent operations (performance, compliance)
- Blue: Analytical/research work
- Green: Building/shipping/growth
- Yellow: Coaching/playful/creative
- Purple: Strategic/architectural
- Orange: Optimization/community
- Pink: Social/design/visual
- Cyan: Testing/AI/technical

#### 5. `tools` (comma-separated list)
- **Format**: Comma-separated tool names
- **Available Tools**: Write, Read, Edit, Bash, Grep, Glob, Task, TodoWrite, WebSearch, WebFetch, NotebookEdit

**Common Tool Combinations**:

| Agent Type | Typical Tools |
|------------|---------------|
| Engineering | `Write, Read, Edit, Bash, Grep, Glob` |
| Marketing | `Write, Read, WebSearch, WebFetch` |
| Product | `Read, Write, WebSearch, TodoWrite` |
| Operations | `Read, Write, Bash, Grep, Glob` |
| Testing | `Read, Write, Bash, Grep, Glob` |
| Coordination | `Read, Write, TodoWrite, Task, Grep, Glob` |

**Tool Selection Guidelines**:
- Always include `Read` for reading files
- Include `Write` if creating new files
- Include `Edit` if modifying existing files
- Include `Bash` for running commands
- Include `Grep` for searching code
- Include `Glob` for finding files
- Include `WebSearch`/`WebFetch` for research
- Include `Task` for spawning sub-agents
- Include `TodoWrite` for project management

#### 6. `permissionMode` (enum)
- **Options**: `default` | `acceptEdits` | `bypassPermissions` | `plan` | `ignore`
- **Distribution**:
  - `default`: 33 agents (87%) - Standard permission handling
  - `acceptEdits`: 5 agents (13%) - Auto-accept file changes
  - `plan`: 1 agent (3%) - Planning mode only

**Use acceptEdits for**:
- Rapid prototyping (rapid-prototyper)
- Code generation that users expect (test-writer-fixer)
- UI polish work (whimsy-injector)
- Infrastructure automation (devops-automator, infrastructure-maintainer)

**Use plan for**:
- Strategic planning agents (sprint-prioritizer)

**Use default for**:
- Most agents (87% of cases)
- When user review is expected

---

## System Prompt Guidelines

System prompts are the heart of each agent. They define behavior, expertise, and approach.

### Required Structure (500+ words)

Every system prompt should follow this proven structure:

#### 1. Opening Identity Statement (1-3 sentences)
- Define the agent's role clearly
- Establish core expertise areas
- Connect to the 6-day sprint philosophy

**Example**:
```
You are an elite rapid prototyping specialist who excels at transforming
ideas into functional applications at breakneck speed. Your expertise spans
modern web frameworks, mobile development, API integration, and trending
technologies. You embody the studio's philosophy of shipping fast and
iterating based on real user feedback.
```

#### 2. Primary Responsibilities (5-8 numbered items)
- Each with bold heading: **Responsibility Name**
- Followed by "you will:" or "when [scenario], you will:"
- 3-5 sub-bullets explaining the approach
- Action-oriented language (not passive)

**Example**:
```
1. **Project Scaffolding & Setup**: When starting a new prototype, you will:
   - Analyze the requirements to choose the optimal tech stack
   - Set up the project structure using modern tools
   - Configure essential development tools
   - Implement hot-reloading for efficient development
   - Create a basic CI/CD pipeline

2. **Core Feature Implementation**: You will build MVPs by:
   - Identifying the 3-5 core features that validate the concept
   - Using pre-built components to accelerate development
   [...]
```

#### 3. Domain-Specific Sections
Include 2-4 sections specific to the agent's domain:

**For Engineering Agents**:
- Tech Stack Preferences
- Decision Framework
- Common Shortcuts
- Error Handling

**For Marketing Agents**:
- Platform Best Practices
- Content Pillars
- Viral Mechanics
- Engagement Strategies

**For Product Agents**:
- Prioritization Framework
- Analysis Techniques
- User Research Methods
- Validation Approaches

**For Operations Agents**:
- Process Patterns
- Tool Recommendations
- Efficiency Metrics
- Scalability Considerations

#### 4. Best Practices Section
- 5-8 concrete best practices
- Specific, actionable advice
- Include time estimates where relevant
- Reference 6-day sprint constraints

**Example**:
```
**Best Practices**:
- Start with a working "Hello World" in under 30 minutes
- Use TypeScript from the start to catch errors early
- Implement basic SEO and social sharing meta tags
- Create at least one "wow" moment in every prototype
- Always include a feedback collection mechanism
```

#### 5. Integration with 6-Day Sprint Philosophy
- Explain how the agent fits into sprint cycles
- Reference sprint timing and milestones
- Emphasize speed and iteration
- Connect to broader studio goals

#### 6. Closing Goal Statement (2-4 sentences)
- Philosophical summary of the agent's purpose
- Core beliefs and values
- Ultimate objective
- Inspirational tone

**Example**:
```
Your goal is to transform ideas into tangible, testable products faster than
anyone thinks possible. You believe that shipping beats perfection, user
feedback beats assumptions, and momentum beats analysis paralysis. You are
the studio's secret weapon for rapid innovation and market validation.
```

### Tone and Voice Guidelines

- **Perspective**: Second person ("you will", "you excel at")
- **Tone**: Confident expertise without arrogance
- **Style**: Direct, action-oriented language
- **Emphasis**: Speed, pragmatism, shipping
- **Length**: 500-800 words typical (some go longer)

### Content Quality Standards

✅ **Do**:
- Use specific, actionable advice
- Include concrete examples
- Reference real tools and frameworks
- Explain reasoning behind decisions
- Connect to sprint philosophy
- Use bold headings for scannability

❌ **Don't**:
- Use vague generalities
- Include outdated technology references
- Write in passive voice
- Omit the 6-day sprint context
- Forget the closing goal statement

---

## Development Workflows

### The 6-Day Sprint Cycle

All agents operate within this framework:

```
Week 1-2: Planning, setup, core features
Week 3-4: Integration, secondary features, polish
Week 5:   User testing, iteration, feedback integration
Week 6:   Launch preparation, deployment, documentation
```

### Multi-Agent Collaboration

Agents are designed to work together. Common collaboration patterns:

#### Pattern 1: Feature Development Flow
```
1. sprint-prioritizer → Identifies features to build
2. rapid-prototyper → Builds the MVP
3. test-writer-fixer → Adds test coverage
4. whimsy-injector → Polishes UI/UX
5. project-shipper → Handles deployment
```

#### Pattern 2: Marketing Campaign Flow
```
1. trend-researcher → Identifies viral opportunities
2. content-creator → Develops campaign content
3. tiktok-strategist → Optimizes for TikTok
4. instagram-curator → Adapts for Instagram
5. growth-hacker → Implements viral mechanics
```

#### Pattern 3: Bug Fix Flow
```
1. feedback-synthesizer → Analyzes user complaints
2. frontend-developer → Fixes UI issues
3. backend-architect → Fixes API issues
4. test-writer-fixer → Adds regression tests
5. support-responder → Updates affected users
```

### Proactive Agent Triggering

Some agents automatically activate in specific contexts:

| Agent | Trigger Condition |
|-------|-------------------|
| **studio-coach** | Complex multi-agent tasks begin |
| **test-writer-fixer** | After code modifications |
| **whimsy-injector** | After UI/UX changes |
| **experiment-tracker** | When feature flags are added |
| **studio-producer** | Cross-team coordination needed |
| **project-shipper** | Approaching launch deadlines |

**Implementation**: These agents have "PROACTIVELY" in their description's opening sentence.

### Tech Stack Conventions

Agents prefer these technologies for rapid development:

**Frontend**:
- React/Next.js for web applications
- React Native/Expo for mobile apps
- Tailwind CSS for styling
- TypeScript for type safety

**Backend**:
- Supabase (PostgreSQL, Auth, Storage)
- Firebase (Firestore, Auth, Functions)
- Vercel Edge Functions
- Railway for deployments

**Common Integrations**:
- Auth: Clerk, Auth0, Supabase Auth
- Payments: Stripe, Lemonsqueezy
- AI/ML: OpenAI, Anthropic, Replicate
- Analytics: PostHog, Mixpanel
- Email: Resend, Sendgrid

---

## Git Conventions

### Branch Naming

**Pattern**: `claude/{descriptive-name}-{random-id}`

**Examples**:
- `claude/add-claude-documentation-kcW3Q`
- `claude/fix-yaml-descriptions-x7Rp2`
- `claude/update-agent-metadata-mK9dL`

**Rules**:
- Always start with `claude/` prefix
- Use kebab-case for descriptive name
- Include short random ID for uniqueness
- Push will fail with 403 if pattern is incorrect

### Commit Message Format

Follow conventional commits:

```
<type>: <description>

[optional body]
```

**Types**:
- `feat:` - New features or agents
- `fix:` - Bug fixes, corrections
- `docs:` - Documentation changes
- `chore:` - Maintenance, cleanup
- `refactor:` - Code restructuring

**Examples from History**:
```bash
feat: Update all 37 agent front matters with optimized metadata
fix: Correct terminology and typos across agent files
fix: Properly quote YAML description fields in all agents
chore: Remove .DS_Store from tracking
docs: Add comprehensive CLAUDE.md guide
```

### Commit Best Practices

1. **Clear descriptions**: Explain what changed and why
2. **Atomic commits**: One logical change per commit
3. **Present tense**: "Add feature" not "Added feature"
4. **No periods**: Don't end descriptions with periods
5. **Reference issues**: Include issue numbers when relevant

### Push/Pull Operations

**Push with retry logic**:
```bash
# Always use -u flag for new branches
git push -u origin claude/branch-name-kcW3Q

# If network fails, retry up to 4 times with exponential backoff:
# - Wait 2s, retry
# - Wait 4s, retry
# - Wait 8s, retry
# - Wait 16s, final retry
```

**Fetch/Pull**:
```bash
# Prefer specific branches
git fetch origin claude/branch-name-kcW3Q
git pull origin claude/branch-name-kcW3Q

# Same retry logic as push if network failures occur
```

### Pull Request Guidelines

**Format**:
- Clear title describing the change
- Summary section with 1-3 bullet points
- Test plan checklist (if code changes)
- Link to related issues

**Review Process**:
- All agent changes should be tested
- Check YAML syntax validity
- Verify examples are relevant
- Ensure 6-day sprint philosophy is maintained

---

## Creating New Agents

Follow this comprehensive checklist when creating a new agent:

### Step 1: Determine Agent Need

Ask these questions:
- [ ] Is there a clear, specific use case?
- [ ] Does this overlap with existing agents?
- [ ] Will this be used frequently enough?
- [ ] Does it fit the 6-day sprint philosophy?

### Step 2: Choose Department

Place the agent in the appropriate directory within `.claude/agents/`:
- `.claude/agents/engineering/` - Implementation, architecture, deployment
- `.claude/agents/design/` - UI/UX, branding, visual work
- `.claude/agents/marketing/` - Growth, content, social media
- `.claude/agents/product/` - Prioritization, research, feedback
- `.claude/agents/project-management/` - Coordination, shipping
- `.claude/agents/studio-operations/` - Analytics, finance, support, legal
- `.claude/agents/testing/` - Quality, performance, benchmarking
- `.claude/agents/bonus/` - Special purpose agents (coaching, humor)

### Step 3: Define YAML Frontmatter

```yaml
---
name: your-agent-name          # kebab-case, descriptive
description: "Use this agent when [scenario]. This agent specializes in [expertise]. Examples:\n\n<example>\nContext: [situation]\nuser: \"[request]\"\nassistant: \"[response]\"\n<commentary>\n[explanation]\n</commentary>\n</example>\n\n[3 more examples...]"
model: sonnet                  # sonnet (default), opus (complex), haiku (fast)
color: blue                    # Choose meaningful color
tools: Write, Read, Edit       # Minimal set needed
permissionMode: default        # default (most), acceptEdits (auto-accept)
---
```

### Step 4: Write System Prompt

Follow the structure outlined in [System Prompt Guidelines](#system-prompt-guidelines):

1. Opening identity statement (1-3 sentences)
2. Primary responsibilities (5-8 numbered items)
3. Domain-specific sections (2-4 sections)
4. Best practices (5-8 items)
5. Integration with 6-day sprints
6. Closing goal statement (2-4 sentences)

**Minimum length**: 500 words
**Target length**: 500-800 words
**Maximum length**: No hard limit (studio-coach is 127 lines)

### Step 5: Create Examples

Each agent needs **3-4 detailed examples** in the description:

**Example Template**:
```xml
<example>
Context: [What situation is the user in?]
user: "[Exact user request]"
assistant: "[How would Claude respond?]"
<commentary>
[Why this example matters, what it demonstrates]
</commentary>
</example>
```

**Example Quality Guidelines**:
- Use realistic scenarios
- Show the agent's unique value
- Cover different use cases
- Include context for why the agent was chosen

### Step 6: Test the Agent

Before committing:
- [ ] Validate YAML syntax (no parsing errors)
- [ ] Test with real-world scenarios
- [ ] Verify tool access works correctly
- [ ] Check that examples trigger appropriately
- [ ] Confirm agent doesn't overlap with existing ones
- [ ] Test multi-agent collaboration if applicable

### Step 7: Document and Commit

```bash
# Add the new agent file
git add .claude/agents/department/your-agent-name.md

# Commit with clear message
git commit -m "feat: Add [agent-name] agent for [purpose]"

# Push to feature branch
git push -u origin claude/add-agent-name-xxxxx
```

### Step 8: Update README (if needed)

If adding a new agent, update the agent list in README.md:
- Add to the appropriate department section
- Include one-line description
- Maintain alphabetical order within department

---

## Modifying Existing Agents

### When to Modify

Modify existing agents when:
- Fixing errors or typos
- Updating outdated technology references
- Improving clarity or examples
- Adding missing best practices
- Correcting YAML syntax
- Enhancing system prompts

### Modification Checklist

- [ ] Read the entire agent file first
- [ ] Understand the agent's current purpose
- [ ] Preserve the agent's core identity
- [ ] Update YAML if needed (check syntax)
- [ ] Maintain 500+ word system prompt length
- [ ] Keep examples relevant and realistic
- [ ] Test changes before committing
- [ ] Use `fix:` commit type for corrections
- [ ] Use `refactor:` for structural changes

### Recent Fix Examples

From commit history:
```bash
# YAML description quoting fix
fix: Properly quote YAML description fields in all agents

# Terminology consistency
fix: Correct terminology and typos across agent files
# (Changed "6-week" to "6-day" throughout)

# Metadata improvements
feat: Update all 37 agent front matters with optimized metadata
```

### Editing System Prompts

**Do**:
- Maintain the established structure
- Keep tone consistent with other agents
- Add specific, actionable advice
- Reference current technologies
- Preserve the 6-day sprint context

**Don't**:
- Remove core sections
- Change the agent's fundamental purpose
- Make prompts shorter than 500 words
- Remove references to 6-day sprints
- Change tone from confident to uncertain

---

## Best Practices

### For AI Assistants Working with This Repository

#### 1. Always Read Before Editing
```bash
# ✅ Correct approach
Read agent file → Understand structure → Make targeted edits

# ❌ Incorrect approach
Make assumptions → Edit without reading → Break structure
```

#### 2. Use Appropriate Tools
- Use `Read` tool for reading agent files
- Use `Edit` tool for modifying existing agents
- Use `Write` tool only for new agents
- Use `Grep` for searching content across agents
- Use `Glob` for finding agent files by pattern

#### 3. Respect YAML Syntax
```yaml
# ✅ Correct: Quoted multi-line string
description: "This is a description.\n\nIt has multiple lines."

# ❌ Incorrect: Unquoted multi-line
description: This is a description.
  It has multiple lines.

# ✅ Correct: Comma-separated tools
tools: Write, Read, Edit, Bash

# ❌ Incorrect: List format
tools:
  - Write
  - Read
```

#### 4. Maintain Consistency
- Follow the established patterns
- Use the same structure as existing agents
- Match the tone and voice of other agents
- Keep department-specific conventions

#### 5. Test Before Committing
- Validate YAML syntax
- Check that file paths are correct
- Test with example scenarios
- Verify tool access works

### For Users Creating Custom Agents

#### 1. Start with a Template
Copy an existing agent similar to your needs:
- Engineering agent → Use `rapid-prototyper.md` as template
- Marketing agent → Use `content-creator.md` as template
- Product agent → Use `feedback-synthesizer.md` as template

#### 2. Focus on Clear Examples
Your examples are the primary trigger mechanism:
- Make them specific and realistic
- Cover different use cases
- Include context and commentary
- Show the agent's unique value

#### 3. Choose the Right Model
- **Default to `sonnet`** for most agents (balanced)
- **Use `opus`** for complex reasoning, architecture, financial/legal
- **Use `haiku`** for simple, fast operations only

#### 4. Minimize Tool Access
Only include tools the agent actually needs:
- Don't give all agents all tools
- More tools = more complexity
- Match tools to responsibilities

#### 5. Test in Real Scenarios
Before deploying:
- Copy to `~/.claude/agents/`
- Test with real projects
- Verify examples trigger correctly
- Check multi-agent interactions

---

## Common Patterns

### Pattern: Proactive Agent Triggering

Some agents should activate automatically:

**In Description**:
```yaml
description: "PROACTIVELY use this agent when [condition]..."
```

**In System Prompt**:
```
You should be triggered automatically when [condition occurs].
```

**Examples**: studio-coach, test-writer-fixer, whimsy-injector

### Pattern: Multi-Agent Orchestration

Coordination agents can spawn other agents:

**Tools Required**:
```yaml
tools: Task, Write, Read, TodoWrite, Grep, Glob
```

**In System Prompt**:
```
2. **Strategic Orchestration**: You will coordinate multi-agent efforts by:
   - Clarifying each agent's role in the larger mission
   - Preventing duplicate efforts and ensuring synergy
   - Identifying when specific expertise is needed
   - Creating smooth handoffs between specialists
```

**Examples**: studio-coach, studio-producer

### Pattern: Tech Stack Specificity

Engineering agents specify exact technologies:

```
**Tech Stack Preferences**:
- Frontend: React/Next.js for web, React Native/Expo for mobile
- Backend: Supabase, Firebase, or Vercel Edge Functions
- Styling: Tailwind CSS for rapid UI development
- Auth: Clerk, Auth0, or Supabase Auth
- Payments: Stripe or Lemonsqueezy
- AI/ML: OpenAI, Anthropic, or Replicate APIs
```

### Pattern: Decision Frameworks

Agents provide clear decision trees:

```
**Decision Framework**:
- If building for virality: Prioritize mobile and sharing features
- If validating business model: Include payment flow and analytics
- If demoing to investors: Focus on polished hero features
- If testing user behavior: Implement comprehensive event tracking
- If time is critical: Use no-code tools for non-core features
```

### Pattern: Error Handling Sections

Agents anticipate problems:

```
**Error Handling**:
- If requirements are vague: Build multiple small prototypes
- If timeline is impossible: Negotiate core features vs nice-to-haves
- If tech stack is unfamiliar: Use closest familiar alternative
- If integration is complex: Use mock data first, real integration second
```

### Pattern: Time-Boxed Development

Agents break work into 6-day cycles:

```
5. **Time-Boxed Development**: Within the 6-day cycle constraint, you will:
   - Week 1-2: Set up project, implement core features
   - Week 3-4: Add secondary features, polish UX
   - Week 5: User testing and iteration
   - Week 6: Launch preparation and deployment
   - Document shortcuts taken for future refactoring
```

---

## The 6-Day Sprint Philosophy

This is the **core operating principle** for all agents in this repository.

### Overview

The studio operates on **6-day sprint cycles** (not 6-week, not 2-week):
- Week 1-2: Core development
- Week 3-4: Feature completion
- Week 5: User testing
- Week 6: Launch

### Key Principles

1. **Shipping Beats Perfection**
   - Launch functional products quickly
   - Iterate based on real user feedback
   - Progress over perfection

2. **Speed Through Confidence**
   - "Smooth is fast, fast is smooth"
   - Quality doesn't slow you down
   - Panic slows you down

3. **User Feedback Beats Assumptions**
   - Test with real users early
   - Don't build in isolation
   - Validate before investing heavily

4. **Momentum Beats Analysis Paralysis**
   - Make decisions quickly
   - Adjust based on results
   - Keep moving forward

5. **Viral by Design**
   - Build shareable moments
   - Design for TikTok/Instagram
   - Mobile-first thinking

### How Agents Embody This Philosophy

**In Opening Statements**:
```
You embody the studio's philosophy of shipping fast and iterating
based on real user feedback.
```

**In Time Management**:
```
Within the 6-day cycle constraint, you will:
- Week 1-2: [Core work]
- Week 3-4: [Secondary features]
- Week 5: [User testing]
- Week 6: [Launch prep]
```

**In Best Practices**:
```
- Start with a working "Hello World" in under 30 minutes
- Document shortcuts taken for future refactoring
- Focus on 3-5 core features that validate the concept
```

**In Goal Statements**:
```
You believe that shipping beats perfection, user feedback beats
assumptions, and momentum beats analysis paralysis.
```

### Common Shortcuts (Documented)

Agents are pragmatic about shortcuts:

```
**Common Shortcuts** (with future refactoring notes):
- Inline styles for one-off components (mark with TODO)
- Local state instead of global state management (document data flow)
- Basic error handling with toast notifications (note edge cases)
- Minimal test coverage focusing on critical paths only
- Direct API calls instead of abstraction layers
```

**Key Point**: Shortcuts are acceptable if documented for future cleanup.

### Integration in Every Agent

**Check Your Agent**:
- [ ] Opening statement mentions 6-day sprints or rapid shipping
- [ ] Responsibilities include time-boxed development
- [ ] Best practices emphasize speed
- [ ] Examples show quick iterations
- [ ] Closing statement references shipping philosophy

If any are missing, the agent isn't properly aligned with studio philosophy.

---

## Quick Reference

### File Locations
- **Repository Root**: `/Users/mladen.grozev/Code/redispute/`
- **Agents**: `/Users/mladen.grozev/Code/redispute/.claude/agents/{department}/{agent-name}.md`
- **Skills**: `/Users/mladen.grozev/Code/redispute/.claude/skills/`
- **Knowledge**: `/Users/mladen.grozev/Code/redispute/knowledge/`
- **README**: `/Users/mladen.grozev/Code/redispute/README.md`
- **This Guide**: `/Users/mladen.grozev/Code/redispute/CLAUDE.md`

### Agent Counts by Department
```
Engineering:         7 agents
Marketing:           7 agents
Design:              5 agents
Studio Operations:   5 agents
Testing:             5 agents
Product:             3 agents
Project Management:  3 agents
Bonus:               2 agents
---
Total:              38 agents
```

### Most Common Configurations

**Standard Engineering Agent**:
```yaml
model: sonnet
color: cyan
tools: Write, Read, Edit, Bash, Grep, Glob
permissionMode: default
```

**Rapid Development Agent**:
```yaml
model: sonnet
color: green
tools: Write, Read, Edit, Bash, Grep, Glob, Task
permissionMode: acceptEdits
```

**Research/Marketing Agent**:
```yaml
model: sonnet
color: pink
tools: Write, Read, WebSearch, WebFetch
permissionMode: default
```

**Strategic Planning Agent**:
```yaml
model: opus
color: purple
tools: Read, Write, TodoWrite, Task
permissionMode: plan
```

### Common Commands

```bash
# Find all agents
find .claude/agents -name "*.md"

# Search agent content
grep -r "pattern" .claude/agents/engineering/ .claude/agents/design/ .claude/agents/marketing/

# Count agents by department
ls -1 .claude/agents/engineering/ | wc -l

# Validate YAML (requires yq)
yq eval '.' .claude/agents/engineering/rapid-prototyper.md

# Agents are already in place - no copying needed
# They load automatically from .claude/agents/ directory
```

---

## Troubleshooting

### YAML Parsing Errors

**Problem**: Agent not loading due to YAML errors

**Solutions**:
1. Check that description is properly quoted
2. Verify no unescaped special characters
3. Ensure no trailing spaces after `---`
4. Validate tools are comma-separated
5. Check that all 6 required fields are present

### Agent Not Triggering

**Problem**: Agent doesn't activate when expected

**Solutions**:
1. Check that examples match user scenarios
2. Verify agent name is unique
3. Ensure description clearly explains use cases
4. Add more detailed examples
5. Verify agent is in `.claude/agents/{department}/` directory
6. Restart Claude Code to reload agent definitions

### Tool Access Issues

**Problem**: Agent can't use specified tools

**Solutions**:
1. Verify tools are in available tool list
2. Check tool names are spelled correctly
3. Ensure tools are comma-separated in YAML
4. Test with minimal tool set first
5. Check permissionMode isn't blocking tool use

### Git Push Failures

**Problem**: `git push` fails with 403 error

**Solutions**:
1. Verify branch name starts with `claude/`
2. Check that branch name ends with session ID
3. Use `-u` flag for first push: `git push -u origin branch-name`
4. Retry with exponential backoff (2s, 4s, 8s, 16s)

---

## Additional Resources

### In This Repository
- **README.md**: User-facing documentation with installation, agent list, customization checklist
- **Agent Files**: 38 specialized agents in `.claude/agents/` directories
- **Skills**: Custom skills in `.claude/skills/` (prd, prd-to-jira)
- **Knowledge Base**: Project research and strategy in `knowledge/init-research/`
  - PreventFlow MVP planning and Cloudflare Workers implementation
  - Disputifier market research and disruption strategy
  - Shopify payment protection strategy documents
- **.gitignore**: Standard exclusions for Claude Code projects

### Project-Specific Resources
- **PreventFlow**: Shopify payment protection and dispute prevention system
- **Disputifier**: Market disruptor analysis and competitive strategy
- **Tech Stack**: Cloudflare Workers, Shopify API integration planned

### External Documentation
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code Sub-Agents](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [Anthropic API Docs](https://docs.anthropic.com/)

### Contributing
- GitHub Issues: Report problems or suggest improvements
- Pull Requests: Contribute new agents or fixes
- Branch Pattern: `claude/{descriptive-name}-{random-id}`

---

## Changelog

### 2026-01-13
- **Updated repository context**: Changed from generic template to redispute project workspace
- **Fixed agent locations**: Updated all paths from `/home/user/claude-agents/` to `/Users/mladen.grozev/Code/redispute/`
- **Clarified agent deployment**: All 38 agents now in `.claude/agents/` subdirectory (including bonus agents), loaded automatically
- **Added usage instructions**: How agents work in this specific repository setup
- **Updated file structure**: Reflected actual repository layout with `.claude/agents/` (including bonus), `.claude/skills/`, and `knowledge/` directories
- **Added project context**: Documented PreventFlow and Disputifier project information
- **Updated commands**: Changed all example commands to use correct paths
- **Consolidated bonus agents**: Moved bonus agents to `.claude/agents/bonus/` with all other agents

### 2026-01-12
- Initial creation of CLAUDE.md
- Comprehensive documentation of all 38 agents
- Detailed YAML frontmatter reference
- System prompt guidelines
- Git conventions and workflows
- Best practices and common patterns
- 6-day sprint philosophy documentation

---

**For AI Assistants**: This document should be your primary reference when working with this repository. Always read the relevant sections before creating or modifying agents. When in doubt, look at existing agents as examples and follow established patterns.

**For Human Users**: This document complements README.md with technical details specifically for AI assistants. For user-facing documentation, see README.md.

---

*This document is maintained to help AI assistants understand and work effectively with the redispute project workspace. Last updated: 2026-01-13*
