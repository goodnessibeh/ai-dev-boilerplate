#!/bin/bash

echo "Organizing skills into category directories..."
echo ""

# Create category directories
mkdir -p "01-Software-Web-Development"
mkdir -p "02-Context-Engineering-AI"
mkdir -p "03-Security"
mkdir -p "04-QA-Testing"
mkdir -p "05-Document-Processing"
mkdir -p "06-Meta-Process"

# Software & Web Development
for skill in stripe-best-practices upgrade-stripe stripe-integration frontend-design mcp-builder webapp-testing wrangler building-ai-agent-on-cloudflare building-mcp-server-on-cloudflare cloudflare-agents-sdk durable-objects web-perf voltagent-best-practices huggingface-gradio replicate-ai; do
    if [ -d "$skill" ] && [ ! -L "$skill" ]; then
        mv "$skill" "01-Software-Web-Development/"
        echo "  ✓ Moved $skill -> 01-Software-Web-Development/"
    fi
done

# Context Engineering & AI
for skill in advanced-evaluation bdi-mental-states context-compression context-degradation context-fundamentals context-optimization context-engineering evaluation filesystem-context hosted-agents memory-systems multi-agent-patterns project-development tool-design dispatching-parallel-agents brainstorming verification-before-completion test-driven-development; do
    if [ -d "$skill" ] && [ ! -L "$skill" ]; then
        mv "$skill" "02-Context-Engineering-AI/"
        echo "  ✓ Moved $skill -> 02-Context-Engineering-AI/"
    fi
done

# Security
for skill in security-code-review vibesec-security; do
    if [ -d "$skill" ] && [ ! -L "$skill" ]; then
        mv "$skill" "03-Security/"
        echo "  ✓ Moved $skill -> 03-Security/"
    fi
done

# QA & Testing
for skill in qa-testing; do
    if [ -d "$skill" ] && [ ! -L "$skill" ]; then
        mv "$skill" "04-QA-Testing/"
        echo "  ✓ Moved $skill -> 04-QA-Testing/"
    fi
done

# Document Processing
for skill in docx pdf; do
    if [ -d "$skill" ] && [ ! -L "$skill" ]; then
        mv "$skill" "05-Document-Processing/"
        echo "  ✓ Moved $skill -> 05-Document-Processing/"
    fi
done

# Meta/Process
for skill in skill-creator-anthropic; do
    if [ -d "$skill" ] && [ ! -L "$skill" ]; then
        mv "$skill" "06-Meta-Process/"
        echo "  ✓ Moved $skill -> 06-Meta-Process/"
    fi
done

echo ""
echo "Organization complete!"
