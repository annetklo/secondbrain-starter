---
name: meeting-prep
description: Prepare for a meeting by analyzing source documents, feedback, and correspondence to create a structured preparation document with talking points and strategy
argument-hint: [--context "description"] [--person "Name, Role, Organization"] [--documents file1 file2 ...] [--email "paste email text"] [--output-dir DIR]
allowed-tools: Bash(python3:*), Bash(node:*), Bash(pandoc:*), Read, Write, Edit, Glob, Grep, WebFetch, WebSearch
---

# Meeting Preparation Skill

Generate a comprehensive, structured meeting preparation document by analyzing source documents, feedback, and email correspondence. Outputs a professional .docx file in Dutch (default) or English.

## Usage

```
/meeting-prep --person "Jane Smith, CTO, Acme Corp" --context "Partnership discussion about platform integration" --documents briefing.pdf feedback.pdf --email "Hi team, ..."
```

Minimal usage (interactive: Claude will ask for context):
```
/meeting-prep
```

## What This Skill Does

1. **Reads and analyzes all provided documents** (PDFs, DOCX, emails, notes)
2. **Identifies the other party's position**: what they want, what concerns them, what they're really saying
3. **Maps points of alignment and tension** between your position and theirs
4. **Generates a structured meeting prep** with:
   - Summary of the other party's core message
   - Point-by-point analysis of their feedback/position with suggested responses
   - Practical/logistical items from correspondence
   - Recommended conversation strategy (opening, key questions, approach)
   - Potential pitfalls to avoid
5. **Outputs a professional .docx** with clean formatting

## Workflow

### Step 1: Gather Context

If not provided via arguments, interactively ask for:

1. **Who is the meeting with?** (name, role, organization)
2. **What is the meeting about?** (topic, context)
3. **What documents should I analyze?** (paths to files: briefings, proposals, feedback docs, reports)
4. **Any email correspondence to include?** (paste or file path)
5. **Where should I save the output?** (default: same folder as the source documents)

### Step 2: Analyze Documents

Read all provided documents thoroughly. For each document, identify:
- **Key positions and arguments** made by the meeting counterpart
- **Concerns, objections, or risks** they raise
- **Concrete suggestions or proposals** they make
- **Implicit messages** (what they're really saying between the lines)
- **Practical/logistical items** (scheduling, broken links, action items)
- **References to external examples, benchmarks, or data** they cite

### Step 3: Synthesize Analysis

Structure the analysis into these sections:

#### A. Summary
- One paragraph capturing the counterpart's core message and stance
- Characterize their tone (constructive, critical, supportive, concerned, etc.)

#### B. Position Analysis
For each major point the counterpart raises:
- **What they say**: neutral description of their position
- **Why it matters**: the strategic implication
- **Your position** (highlighted box): suggested response, talking point, or question to ask

Group related points. Use numbered headings (1. Point X, 2. Concern Y, etc.)

#### C. Practical Items
- Scheduling conflicts, broken links, action items, logistics from emails

#### D. Recommended Approach
5 concrete steps for the conversation:
1. How to open (usually: acknowledge their input)
2. Key question to ask them
3. Where to explore collaboration / common ground
4. Hard topics to address directly
5. Process/next steps alignment

#### E. Pitfalls to Avoid
3-4 bullet points of things NOT to do in the meeting

### Step 4: Generate .docx Output

Create a professional Word document with:
- **Title format**: "Meeting Prep: [Name]"
- **Subtitle**: "[Organization] - [Topic]"
- **Date**: Current date
- Use your brand colors and fonts from knowledge/brand.md if available

### Step 5: Save and Confirm

- Save the .docx to the specified output directory (or same folder as source docs)
- Show a brief summary of what was created
- Clean up any temporary files

## Language

- Default output language: **Dutch**
- If the user requests English, switch all section headers and content to English
- Analysis and talking points should match the language of the meeting

## Tone Guidelines

- Be direct and actionable: this is a working document, not a report
- Clearly separate facts (what they said) from interpretation (what it means)
- Suggested responses should be diplomatic but honest
- Flag implicit messages to help the user read between the lines
- Pitfalls should be specific and based on the actual content, not generic advice

## Output Naming Convention

```
Meeting Prep [Name] - [Organization].docx
```

Example: `Meeting Prep Jane Smith - Acme Corp.docx`
