---
name: security-code-review
description: Perform security-focused code reviews to identify vulnerabilities, insecure patterns, and compliance issues. Use when reviewing code for security vulnerabilities, checking for OWASP Top 10 issues, auditing authentication/authorization, or ensuring secure coding practices.
---

# Security Code Review

This skill provides guidance for conducting security-focused code reviews.

## OWASP Top 10 Checklist

### A01: Broken Access Control

Check for:
- Missing authorization checks on endpoints
- Insecure direct object references (IDOR)
- Path traversal vulnerabilities
- CORS misconfigurations

```javascript
// ❌ Vulnerable - no auth check
app.get('/api/user/:id', (req, res) => {
  return db.users.findById(req.params.id);
});

// ✅ Secure - verify ownership
app.get('/api/user/:id', authenticate, (req, res) => {
  if (req.user.id !== req.params.id) {
    return res.status(403).json({ error: 'Unauthorized' });
  }
  return db.users.findById(req.params.id);
});
```

### A02: Cryptographic Failures

Check for:
- Weak encryption algorithms (MD5, SHA1, DES)
- Hardcoded secrets/keys
- Missing encryption in transit (HTTP vs HTTPS)
- Weak password policies
- Improper key management

```python
# ❌ Vulnerable - weak hash
import hashlib
def hash_password(password):
    return hashlib.md5(password.encode()).hexdigest()

# ✅ Secure - strong hashing
import bcrypt
def hash_password(password):
    salt = bcrypt.gensalt(rounds=12)
    return bcrypt.hashpw(password.encode(), salt)
```

### A03: Injection

Check for:
- SQL injection
- NoSQL injection
- Command injection
- LDAP injection
- XPath injection

```javascript
// ❌ Vulnerable - SQL injection
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// ✅ Secure - parameterized query
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

### A04: Insecure Design

Check for:
- Missing rate limiting
- No input validation
- Business logic flaws
- Race conditions

### A05: Security Misconfiguration

Check for:
- Default credentials
- Unnecessary features enabled
- Verbose error messages in production
- Missing security headers

```javascript
// Security headers (Express)
app.use(helmet({
  contentSecurityPolicy: true,
  crossOriginEmbedderPolicy: true,
  hsts: { maxAge: 31536000 }
}));
```

### A06: Vulnerable Components

Check for:
- Outdated dependencies with known CVEs
- Unmaintained libraries
- Typosquatted packages

```bash
# Audit dependencies
npm audit
yarn audit
pip-audit
```

### A07: Authentication Failures

Check for:
- Weak session management
- Missing MFA
- Credential stuffing vulnerabilities
- Session fixation

```javascript
// ❌ Vulnerable - predictable session
req.session.userId = user.id;

// ✅ Secure - signed, httpOnly cookies
req.session.regenerate(() => {
  req.session.userId = user.id;
  req.session.cookie.secure = true;
  req.session.cookie.httpOnly = true;
  req.session.cookie.sameSite = 'strict';
});
```

### A08: Data Integrity Failures

Check for:
- Missing integrity checks on deserialization
- Unsigned webhooks
- Tamperable client-side data

### A09: Logging Failures

Check for:
- No logging of security events
- Logging sensitive data
- Insufficient monitoring

```javascript
// ✅ Log security events
logger.info('Login attempt', {
  userId: user.id,
  ip: req.ip,
  success: true,
  // Don't log passwords!
});
```

### A10: SSRF

Check for:
- Server-side requests to user-controlled URLs
- Internal network access from public endpoints

## Language-Specific Security

### JavaScript/TypeScript

```javascript
// Checklist:
// ✓ Use strict mode
'use strict';

// ✓ Validate all inputs with Zod/Joi
const schema = z.object({
  email: z.string().email(),
  age: z.number().min(0).max(150)
});

// ✓ Avoid eval() and new Function()
// ✓ Sanitize HTML output (DOMPurify)
// ✓ Use parameterized queries
// ✓ Set secure cookie flags
// ✓ Implement rate limiting
```

### Python

```python
# Checklist:
# ✓ Use f-strings carefully with user input
# ✓ Avoid pickle for untrusted data
# ✓ Use defusedxml for XML parsing
# ✓ Validate file uploads (type, size)
# ✓ Use secrets module for tokens
# ✓ Enable CSRF protection (Flask-WTF, Django)
```

### SQL

```sql
-- Checklist:
-- ✓ Use parameterized queries
-- ✓ Principle of least privilege for DB user
-- ✓ Encrypt sensitive columns
-- ✓ Audit logging for sensitive operations
```

## Review Process

### 1. Threat Modeling

Identify:
- Attack surface
- Trust boundaries
- Data flows
- Entry points

### 2. Static Analysis

Tools to suggest:
- JavaScript: ESLint security plugins, Semgrep
- Python: Bandit, Pylint security
- Go: gosec
- Java: SpotBugs, FindSecBugs

### 3. Manual Review Checklist

For each function/endpoint:

```
□ Input validation present?
□ Authentication required?
□ Authorization checks implemented?
□ Output encoding/sanitization?
□ Error handling (no info leakage)?
□ Logging (no sensitive data)?
□ Rate limiting?
```

### 4. Test Cases

```javascript
// Security test examples
describe('Authentication', () => {
  test('should reject SQL injection in login', async () => {
    const res = await request(app)
      .post('/login')
      .send({
        email: "' OR '1'='1",
        password: 'anything'
      });
    expect(res.status).toBe(401);
  });
  
  test('should prevent brute force', async () => {
    for (let i = 0; i < 10; i++) {
      await request(app).post('/login').send(wrongCreds);
    }
    const res = await request(app).post('/login').send(wrongCreds);
    expect(res.status).toBe(429); // Too many requests
  });
});
```

## Common Vulnerability Patterns

### Authentication

```javascript
// ❌ Timing attack vulnerable
if (user.password === hash(inputPassword)) {
  // login
}

// ✅ Use timing-safe comparison
crypto.timingSafeEqual(
  Buffer.from(user.password),
  Buffer.from(hash(inputPassword))
);
```

### Authorization

```javascript
// ❌ Missing check
app.delete('/api/posts/:id', async (req, res) => {
  await db.posts.delete(req.params.id);
});

// ✅ Verify ownership
app.delete('/api/posts/:id', authenticate, async (req, res) => {
  const post = await db.posts.findById(req.params.id);
  if (post.authorId !== req.user.id) {
    return res.status(403).json({ error: 'Unauthorized' });
  }
  await db.posts.delete(req.params.id);
});
```

### Data Exposure

```javascript
// ❌ Over-fetching
app.get('/api/users', async (req, res) => {
  const users = await db.users.findAll(); // Includes passwords!
  res.json(users);
});

// ✅ Explicit selection
app.get('/api/users', async (req, res) => {
  const users = await db.users.findAll({
    attributes: ['id', 'name', 'email'] // Exclude password
  });
  res.json(users);
});
```

## Reporting Findings

### Severity Levels

- **Critical**: Immediate exploit, data breach possible
- **High**: Easy to exploit, significant impact
- **Medium**: Requires effort or specific conditions
- **Low**: Best practice violation, minimal impact
- **Info**: Awareness, defense in depth

### Report Template

```markdown
## Finding: [Title]

**Severity**: [Critical/High/Medium/Low]
**Category**: [OWASP Category]
**Location**: [File:Line]

### Description
[What is the vulnerability]

### Proof of Concept
[How to exploit it]

### Impact
[What could happen]

### Remediation
[How to fix it with code example]

### References
- [CWE Entry]
- [OWASP Guide]
```

## Resources

- [OWASP Top 10](https://owasp.org/Top10/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [SANS Top 25](https://www.sans.org/top25-software-errors/)
- [Security Headers](https://securityheaders.com/)
