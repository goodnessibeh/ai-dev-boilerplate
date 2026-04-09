---
name: context-engineering
description: Optimize context management and prompt engineering for AI coding agents. Use when designing prompts, managing large codebases, implementing retrieval strategies, or improving AI agent performance through better context handling.
---

# Context Engineering

This skill provides patterns and strategies for effective context management with AI coding agents.

## Core Principles

### 1. Progressive Disclosure

Structure information in layers to maximize token efficiency:

```
Layer 1: Metadata (always loaded) - Skill name, brief description
Layer 2: SKILL.md body (on trigger) - Core instructions
Layer 3: References (as needed) - Detailed docs
Layer 4: Scripts (execution) - Deterministic operations
```

### 2. Context Budget Management

The context window is a finite resource. Prioritize:

1. **User request** (highest priority)
2. **System instructions**
3. **Relevant skills** (only triggered ones)
4. **Code context** (relevant files only)
5. **Conversation history** (recent turns)

### 3. Signal-to-Noise Ratio

Every token should justify its cost:

- **Include**: Procedural knowledge, domain expertise, specific workflows
- **Exclude**: General knowledge the AI already has
- **Challenge**: "Does Kimi really need this explanation?"

## Patterns for Codebase Context

### Code Summary Over Full Content

Instead of loading entire files, create summaries:

```
[File: src/auth/login.ts]
- Purpose: Handle user authentication
- Key exports: login(), validateToken()
- Dependencies: bcrypt, jwt
- Last modified: 2024-01-15
```

### Hierarchical Context Building

```
1. Start with entry points (main, index, app)
2. Follow import chains as needed
3. Load related files by semantic similarity
4. Keep cross-references for navigation
```

### Symbol-Based Retrieval

Index codebase by symbols for quick lookup:

```javascript
// Symbol index example
{
  "UserService": {
    "file": "src/services/user.ts",
    "type": "class",
    "exports": ["createUser", "updateUser"],
    "dependencies": ["Database", "Logger"]
  }
}
```

## Prompt Engineering Strategies

### Structured Prompts

```markdown
## Task
[Clear description of what needs to be done]

## Context
[Relevant files, patterns, constraints]

## Requirements
- [ ] Specific requirement 1
- [ ] Specific requirement 2

## Output Format
[Expected format for the response]

## Constraints
- [Limitation 1]
- [Limitation 2]
```

### Few-Shot Examples

Include examples for complex tasks:

```markdown
## Example

Input:
```typescript
function greet(name) {
  return "Hello " + name;
}
```

Output:
```typescript
function greet(name: string): string {
  return `Hello ${name}`;
}
```
```

### Chain-of-Thought

For complex reasoning tasks:

```markdown
Think through this step by step:
1. First, identify the main components
2. Then, analyze their relationships
3. Finally, propose a solution
```

## Retrieval Strategies

### 1. Semantic Search

Use embeddings to find relevant context:

```python
# Pseudo-code for semantic retrieval
query_embedding = embed("How does authentication work?")
relevant_chunks = vector_db.similarity_search(query_embedding, k=5)
```

### 2. Keyword + Semantic Hybrid

Combine exact matching with semantic search:

```python
# Find files mentioning "auth" exactly
keyword_matches = grep("auth", codebase)

# Find semantically similar content
semantic_matches = vector_search("authentication", codebase)

# Merge and deduplicate
context = merge(keyword_matches, semantic_matches)
```

### 3. Graph-Based Navigation

Navigate code via relationships:

```
[Function] -> calls -> [Function]
[Class] -> extends -> [Class]
[File] -> imports -> [File]
```

## Context Compression Techniques

### 1. Summarization

```
Before: 500 lines of implementation
After: "Implements OAuth2 flow with PKCE for SPA authentication"
```

### 2. Differential Context

Only include what's changed:

```
[Original function signature]
function calculate(a, b, c, d)

[New signature - only show this]
function calculate(a, b, c, d, options = {})
```

### 3. Hierarchical Summaries

```
Project: E-commerce API
├── Auth module: JWT-based auth
│   ├── login: Credentials -> JWT
│   ├── refresh: JWT -> new JWT
│   └── logout: invalidate token
├── Products module: CRUD operations
│   └── ...
```

## Working with Large Codebases

### Module Isolation

Focus on one module at a time:

```
[Module Boundary: payments]
- Entry: src/payments/index.ts
- Tests: src/payments/__tests__/
- API: src/payments/routes.ts
- Logic: src/payments/service.ts
```

### Lazy Loading

Load details only when needed:

```markdown
## Module Overview
The auth module handles authentication. See [DETAILS.md](DETAILS.md) for implementation.

[Only load DETAILS.md when user asks about implementation]
```

### Cache Management

Cache expensive operations:

```python
# Cache file summaries
@lru_cache(maxsize=1000)
def summarize_file(filepath):
    content = read_file(filepath)
    return generate_summary(content)
```

## Anti-Patterns to Avoid

### 1. Context Stuffing

Don't include irrelevant information just because it's available.

### 2. Over-Summarization

Don't lose critical details in over-zealous compression.

### 3. Static Context

Update context as the conversation evolves:

```
User: "Update the login function"
[Load auth module]

User: "Now update the tests"
[Keep auth context, add test context]
```

### 4. Ignoring Token Limits

Always be aware of context window usage:

```javascript
// Rough estimation
tokens = characters / 4
tokens += num_lines * 0.5  // Formatting overhead
```

## Best Practices

### For Skills Design

1. **Concise descriptions** - Trigger accurately with minimal tokens
2. **Progressive disclosure** - Load details on demand
3. **Clear triggers** - When should this skill activate?
4. **Minimal viable context** - Start small, expand as needed

### For Codebase Interaction

1. **Start broad, narrow down** - Get overview first
2. **Follow user focus** - Load what they're working on
3. **Maintain working memory** - Keep relevant context across turns
4. **Explicit forgetting** - Clear context when switching topics

### For Prompt Design

1. **Be specific** - Vague prompts waste tokens
2. **Use structured formats** - Easier to parse
3. **Include constraints** - What NOT to do is important
4. **Provide examples** - For complex patterns

## Tools and Techniques

### Context Analysis

```python
# Estimate token count
def estimate_tokens(text):
    # Rough approximation
    return len(text) // 4

# Analyze context distribution
def analyze_context(context):
    return {
        'system_prompt': estimate_tokens(context.system),
        'skills': {k: estimate_tokens(v) for k, v in context.skills.items()},
        'code': estimate_tokens(context.code),
        'history': estimate_tokens(context.history),
    }
```

### Relevance Scoring

```python
def score_relevance(query, document):
    """Score how relevant a document is to a query."""
    # Semantic similarity
    semantic_score = cosine_similarity(embed(query), embed(document))
    
    # Keyword overlap
    query_terms = set(query.lower().split())
    doc_terms = set(document.lower().split())
    keyword_score = len(query_terms & doc_terms) / len(query_terms)
    
    return 0.7 * semantic_score + 0.3 * keyword_score
```

## Measuring Effectiveness

### Metrics

1. **Task completion rate** - Can the agent complete the task?
2. **Token efficiency** - Tokens used per task
3. **Latency** - Time to retrieve relevant context
4. **User satisfaction** - Quality of responses

### A/B Testing

Compare context strategies:

```
Variant A: Load full files
Variant B: Load summaries + expand on demand
Measure: Task success, tokens used, response time
```
