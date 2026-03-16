# Building a Second Brain in Claude Code

## A practical guide to making your AI assistant remember, learn, and grow

**By Annet Kloprogge, Mission Relearn**


## Introduction: Why a Second Brain?

Claude Code is powerful out of the box, but it starts fresh every session. It doesn't remember your preferences, your project context, or the workflows you've refined over weeks of collaboration. Every new conversation means re-explaining your stack, your style, and your standards.

What if Claude Code could remember everything that matters?

That's what a Second Brain does. It's a persistent layer of context, knowledge, and automation that turns Claude Code from a capable tool into a personalized AI partner. One that knows your brand guidelines, suggests the right workflow at the right moment, and grows smarter with every session.

This guide walks you through the six layers of building a Second Brain, based on a real production setup that handles proposal generation, document branding, client research, and accounting integration daily.

**The Six Layers:**

1. Foundation: CLAUDE.md + Memory
2. Knowledge Base + Rules
3. Skills (Custom Commands)
4. Hooks + Automation
5. MCP Integrations + Agents
6. Health + Maintenance


## Layer 1: Foundation (CLAUDE.md + Memory)

### CLAUDE.md: Your Master Instruction File

The CLAUDE.md file is the single most important file in your Second Brain. It lives at ~/.claude/CLAUDE.md and is loaded into every conversation automatically. Think of it as Claude's "personality config": it tells Claude who you are, how you work, and what rules to follow.

**What to include:**

- Who you are and what your company does (2-3 lines)
- Default language and output format
- Key guardrails (never auto-commit, confirm before deleting)
- Pointers to knowledge files and rules (not the content itself)
- Session management tips

**What to keep out:**

- Long reference tables (move to rules files)
- Tool installation paths (move to knowledge files)
- Task-specific instructions (use TASK.md instead)

**The golden rule: keep CLAUDE.md under 60 lines.** Every line costs context tokens. If it's not needed in every single session, it belongs in a separate file.

### Memory: Cross-Session Learning

Claude Code has a built-in auto-memory system. It maintains a MEMORY.md file that persists across conversations, storing patterns, preferences, and corrections.

**How it works:**

- Claude automatically saves confirmed patterns and preferences
- You can explicitly ask Claude to "remember this for next time"
- Corrections are stored so mistakes don't repeat
- A memory index links to topic-specific files (e.g., voice.md, patterns.md)

**Pro tip:** Organize memory semantically by topic, not chronologically. Create separate files for different domains: writing style, tool configurations, client context. Keep MEMORY.md as a concise index that points to these files.


## Layer 2: Knowledge Base + Rules

While CLAUDE.md stays lean, your knowledge base holds the deep reference material Claude needs for specific tasks.

### Knowledge Files

Store domain expertise in ~/.claude/.claude/knowledge/:

- **brand.md**: Colors, fonts, document standards, logo usage
- **clients.md**: Active clients, project context, contact details
- **mcp-tools.md**: Integration details for external services
- **workflows.md**: Step-by-step workflow chains

Claude reads these files on demand, not on every session start. This keeps your context window efficient.

### Rules Files

Rules go in ~/.claude/.claude/rules/ and define behavioral patterns:

- **skills-reference.md**: Master table of all available skills with trigger phrases
- **tool-paths.md**: System tool locations and common pitfalls

### When to Use What

- **CLAUDE.md**: Core identity + guardrails. Loaded every session.
- **Knowledge files**: Deep reference material. Loaded on demand.
- **Rules files**: Behavioral patterns. Loaded on demand.
- **MEMORY.md**: Learned preferences. Loaded every session.


## Layer 3: Skills (Custom Commands)

Skills are Claude Code's superpower for repeatable workflows. A skill is a markdown file (SKILL.md) inside a named directory under ~/.claude/skills/ that teaches Claude a specialized capability.

### What Skills Can Do

Each skill contains instructions, constraints, and examples that Claude follows when the skill is invoked. Examples from a production setup:

- **generate-proposal**: Converts meeting transcripts into bilingual proposals with proper formatting
- **brand-pdf**: Applies company branding (fonts, colors, layout) to any document
- **meeting-prep**: Analyzes source documents to create structured preparation notes
- **frontend-slides**: Creates animation-rich HTML presentations from scratch
- **linkedin-posts**: Writes social media content in a specific voice and style

### Creating Your First Skill

1. Create a directory: `~/.claude/skills/my-skill/`
2. Add a SKILL.md file with:
   - A clear description of what the skill does
   - Step-by-step instructions for Claude to follow
   - Constraints and quality checks
   - Example inputs and outputs

**Example directory structure:**

- ~/.claude/skills/brand-pdf/SKILL.md
- ~/.claude/skills/generate-proposal/SKILL.md
- ~/.claude/skills/meeting-prep/SKILL.md

Skills are invoked with slash commands (e.g., /brand-pdf) or triggered automatically by hooks when certain keywords appear in your prompt.


## Layer 4: Hooks + Automation

Hooks are shell scripts that fire at specific moments in the Claude Code lifecycle. They transform your Second Brain from passive (waiting for instructions) to proactive (anticipating your needs).

### Types of Hooks

**Session Start Hook** (`session-start.sh`)
Fires when you open a new session. Use it to:
- Inject today's date and active project context
- Load relevant documentation
- Remind about pending tasks

**Prompt Submit Hook** (`user-prompt-submit.sh`)
Fires every time you send a message. Use it to:
- Suggest relevant skills based on keywords in your prompt
- Inject contextual reminders
- Add timestamps to your workflow

**Pre-Tool-Use Hook** (`pre-tool-use.sh`)
Fires before Claude executes a tool. Use it to:
- Block destructive operations (rm -rf, git push --force)
- Add safety confirmations for sensitive actions

**Stop Hook** (`stop.sh`)
Fires when a session ends. Use it to:
- Remind about updating project context
- Trigger cleanup tasks

### Skill Suggestions via Hooks

One of the most powerful patterns: a JSON rules file maps keywords to skill suggestions. When you type "voorstel" (proposal), the hook automatically suggests the `/generate-proposal` skill. This means you never need to remember which skill to use: the Second Brain suggests it for you.

In your skill-rules.json, define trigger-to-skill mappings:

- **triggers**: "proposal", "voorstel", "offerte"
- **skill**: /generate-proposal
- **hint**: "Use /generate-proposal for meeting transcripts"

The hook reads this file on every prompt and matches keywords automatically.


## Layer 5: MCP Integrations + Agents

MCP (Model Context Protocol) servers connect Claude Code to external services, extending your Second Brain beyond local files.

### What MCP Enables

- **Web scraping**: Research companies, read articles, analyze competitors
- **Accounting**: Query invoices, check payment status, manage contacts
- **Databases**: Store and retrieve structured data
- **Platform integrations**: Connect to project management, communication tools

### Specialized Agents

Define agent profiles in ~/.claude/.claude/agents/ for complex, multi-step workflows:

- **proposal-writer**: Takes a transcript and produces a complete proposal package
- **researcher**: Performs web research using multiple sources
- **document-creator**: Handles the full document lifecycle (draft, brand, export)

### The Compound Effect

The real magic happens when layers work together:

1. You type "maak een voorstel voor het transcript"
2. The **prompt hook** detects "voorstel" and suggests `/generate-proposal`
3. The **skill** provides Claude with proposal-writing instructions
4. The **knowledge base** supplies brand guidelines and client context
5. The **MCP integration** looks up the client in your accounting system
6. The **agent** orchestrates the full workflow: draft, brand, export, email

What used to take hours now takes minutes, and the output is consistent every time.


## Layer 6: Health + Maintenance

A Second Brain needs maintenance, just like a real one. Without it, your CLAUDE.md grows bloated, memories become outdated, and skills fall out of sync.

### Regular Health Checks

Run periodic health checks to assess:

- **CLAUDE.md size**: Is it still under 60 lines?
- **Memory freshness**: Are stored patterns still accurate?
- **Skill usage**: Which skills are actually being used? Which can be removed?
- **Knowledge accuracy**: Do client details and tool paths still match reality?

### Pruning and Updating

- Remove outdated memories when you correct Claude
- Archive skills that haven't been used in months
- Update knowledge files when projects change
- Review hook configurations as your workflow evolves

### The Growth Cycle

Your Second Brain improves through a natural cycle:

1. **Use**: Work with Claude Code on real tasks
2. **Observe**: Notice what Claude gets wrong or forgets
3. **Correct**: Fix the issue (update memory, add a rule, create a skill)
4. **Verify**: Check that the fix works in the next session
5. **Repeat**: Each cycle makes your Second Brain smarter


## Getting Started: Your First 5 Steps

Ready to build your own Second Brain? Start here:

1. **Create your CLAUDE.md** at ~/.claude/CLAUDE.md. Include your name, company, default language, and top 3 guardrails. Keep it under 60 lines.

2. **Set up a knowledge file**. Pick your most-repeated context (brand standards, project details, or tool configurations) and save it to ~/.claude/.claude/knowledge/. Add a pointer in CLAUDE.md.

3. **Build your first skill**. Identify a workflow you repeat weekly. Create a SKILL.md that teaches Claude how to do it. Test it, refine it, and start using it.

4. **Add a session start hook**. Create a simple `session-start.sh` that injects today's date and your active project context. Configure it in ~/.claude/settings.json.

5. **Start the growth cycle**. Every time Claude gets something wrong, decide where the fix belongs: CLAUDE.md, memory, knowledge, rules, or a skill. Make the correction. Your Second Brain just got smarter.


*Building a Second Brain is not a one-time project. It's an ongoing practice of teaching your AI assistant to work the way you do. Start small, iterate often, and let the compound effect do its work.*

**Annet Kloprogge**
Founder, Mission Relearn
annet@missionrelearn.com
