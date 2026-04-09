---
name: qa-testing
description: Design and implement quality assurance testing strategies including unit tests, integration tests, E2E tests, and test automation. Use when writing tests, setting up testing frameworks, debugging test failures, or establishing QA processes.
---

# QA Testing

This skill provides comprehensive guidance for software testing and quality assurance.

## Testing Pyramid

```
       /\
      /  \     E2E Tests (Few)
     /----\    
    /      \   Integration Tests (Some)
   /--------\  
  /          \ Unit Tests (Many)
 /------------\
```

## Unit Testing

### Principles

- **FIRST**: Fast, Independent, Repeatable, Self-validating, Timely
- **AAA Pattern**: Arrange, Act, Assert
- **One concept per test**

### JavaScript/TypeScript (Jest)

```javascript
// ✅ Good test
describe('calculateTotal', () => {
  test('should sum items and apply discount', () => {
    // Arrange
    const items = [
      { price: 100, quantity: 2 },
      { price: 50, quantity: 1 }
    ];
    const discount = 0.1;
    
    // Act
    const result = calculateTotal(items, discount);
    
    // Assert
    expect(result).toBe(225); // (250 * 0.9)
  });
  
  test('should throw error for negative prices', () => {
    const items = [{ price: -100, quantity: 1 }];
    
    expect(() => calculateTotal(items)).toThrow('Invalid price');
  });
});

// Mocking
describe('UserService', () => {
  test('should fetch user from database', async () => {
    const mockDb = {
      users: {
        findById: jest.fn().mockResolvedValue({ id: '1', name: 'John' })
      }
    };
    const service = new UserService(mockDb);
    
    const user = await service.getUser('1');
    
    expect(mockDb.users.findById).toHaveBeenCalledWith('1');
    expect(user.name).toBe('John');
  });
});
```

### Python (pytest)

```python
# Basic test
import pytest
from calculator import calculate_total

def test_calculate_total_with_discount():
    # Arrange
    items = [
        {"price": 100, "quantity": 2},
        {"price": 50, "quantity": 1}
    ]
    
    # Act
    result = calculate_total(items, discount=0.1)
    
    # Assert
    assert result == 225

def test_calculate_total_invalid_price():
    items = [{"price": -100, "quantity": 1}]
    
    with pytest.raises(ValueError, match="Invalid price"):
        calculate_total(items)

# Fixtures
@pytest.fixture
def mock_db():
    return MockDatabase()

def test_user_service(mock_db):
    service = UserService(mock_db)
    user = service.get_user("1")
    assert user.name == "John"

# Parametrized tests
@pytest.mark.parametrize("input,expected", [
    ([1, 2, 3], 6),
    ([10, 20], 30),
    ([], 0),
])
def test_sum(input, expected):
    assert sum(input) == expected
```

### Go

```go
func TestCalculateTotal(t *testing.T) {
    tests := []struct {
        name     string
        items    []Item
        discount float64
        want     float64
        wantErr  bool
    }{
        {
            name: "with discount",
            items: []Item{
                {Price: 100, Quantity: 2},
                {Price: 50, Quantity: 1},
            },
            discount: 0.1,
            want:     225,
        },
        {
            name:     "invalid price",
            items:    []Item{{Price: -100, Quantity: 1}},
            wantErr:  true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := CalculateTotal(tt.items, tt.discount)
            if tt.wantErr {
                assert.Error(t, err)
                return
            }
            assert.Equal(t, tt.want, got)
        })
    }
}
```

## Integration Testing

### API Testing

```javascript
// Using supertest
describe('POST /api/users', () => {
  test('should create user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'john@example.com' })
      .expect(201);
    
    expect(response.body).toHaveProperty('id');
    expect(response.body.email).toBe('john@example.com');
  });
  
  test('should validate email format', async () => {
    await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'invalid' })
      .expect(400);
  });
});
```

### Database Testing

```javascript
// Test with test database
describe('UserRepository', () => {
  beforeAll(async () => {
    await testDb.connect();
  });
  
  afterAll(async () => {
    await testDb.disconnect();
  });
  
  beforeEach(async () => {
    await testDb.clear();
  });
  
  test('should persist user', async () => {
    const user = await User.create({
      name: 'John',
      email: 'john@example.com'
    });
    
    const found = await User.findById(user.id);
    expect(found.name).toBe('John');
  });
});
```

## E2E Testing

### Playwright

```javascript
import { test, expect } from '@playwright/test';

test.describe('User Flow', () => {
  test('user can sign up and log in', async ({ page }) => {
    // Sign up
    await page.goto('/signup');
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'SecurePass123!');
    await page.click('button[type="submit"]');
    
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('text=Welcome')).toBeVisible();
    
    // Logout and login
    await page.click('text=Logout');
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'SecurePass123!');
    await page.click('button[type="submit"]');
    
    await expect(page.locator('text=Dashboard')).toBeVisible();
  });
  
  test('user can add items to cart', async ({ page }) => {
    await page.goto('/products');
    await page.click('[data-testid="product-1"]');
    await page.click('text=Add to Cart');
    
    await expect(page.locator('[data-testid="cart-count"]')).
      toHaveText('1');
  });
});
```

### Cypress

```javascript
describe('Checkout Flow', () => {
  it('completes purchase', () => {
    cy.visit('/products');
    cy.get('[data-testid="add-to-cart"]').first().click();
    cy.get('[data-testid="cart"]').click();
    cy.get('button').contains('Checkout').click();
    
    // Fill shipping
    cy.get('[name="address"]').type('123 Main St');
    cy.get('[name="city"]').type('New York');
    cy.get('button').contains('Continue').click();
    
    // Fill payment (test card)
    cy.get('[name="cardNumber"]').type('4242424242424242');
    cy.get('[name="expDate"]').type('12/25');
    cy.get('[name="cvc"]').type('123');
    cy.get('button').contains('Pay').click();
    
    cy.contains('Order confirmed').should('be.visible');
  });
});
```

## Test Coverage

### Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Integration Tests**: Critical paths covered
- **E2E Tests**: Happy path + critical error scenarios

### Coverage Reports

```bash
# Jest
jest --coverage --coverageReporters=text-summary

# Python
pytest --cov=src --cov-report=term-missing

# Go
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

## Test Automation

### CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run unit tests
        run: npm run test:unit -- --coverage
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://test:test@localhost/test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

### Pre-commit Hooks

```yaml
# .husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npm run lint:staged
npm run test:staged
```

## Test Data Management

### Factories

```javascript
// factory.js
const { factory } = require('factory-girl');
const faker = require('faker');

factory.define('User', User, {
  name: faker.name.findName(),
  email: faker.internet.email(),
  password: faker.internet.password(),
  createdAt: () => new Date()
});

// usage
const user = await factory.create('User', { name: 'Specific Name' });
```

### Fixtures

```yaml
# fixtures/users.yml
users:
  admin:
    name: Admin User
    email: admin@example.com
    role: admin
  
  regular:
    name: Regular User
    email: user@example.com
    role: user
```

## Mocking Strategies

### External APIs

```javascript
// Mock Stripe
jest.mock('stripe', () => {
  return jest.fn().mockImplementation(() => ({
    paymentIntents: {
      create: jest.fn().mockResolvedValue({ id: 'pi_123', status: 'succeeded' })
    }
  }));
});

// MSW (Mock Service Worker)
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/users', (req, res, ctx) => {
    return res(ctx.json([{ id: '1', name: 'John' }]));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

## Debugging Tests

### Common Issues

```javascript
// Test timeouts
test('slow operation', async () => {
  jest.setTimeout(10000); // 10 seconds
  // ...
}, 10000);

// Async issues
test('async test', async () => {
  await expect(asyncFunction()).resolves.toBe('result');
});

// Floating promises
test('handles promise', async () => {
  const result = await someAsyncFunction(); // Don't forget await!
  expect(result).toBeDefined();
});
```

### Debugging Tools

```bash
# Jest debug
node --inspect-brk node_modules/.bin/jest --runInBand

# Python debug
pytest --pdb  # Drop into debugger on failure

# Verbose output
jest --verbose
pytest -v
```

## Testing Best Practices

### DO

- Write tests before or alongside code (TDD/BDD)
- Test behavior, not implementation
- Use descriptive test names
- Keep tests independent
- Use appropriate test doubles
- Test edge cases and error scenarios

### DON'T

- Test implementation details
- Write tests that depend on each other
- Mock everything (test real behavior)
- Ignore flaky tests
- Leave tests commented out

## Performance Testing

### Load Testing with k6

```javascript
import http from 'k6/http';
import { check } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 100 },
    { duration: '3m', target: 100 },
    { duration: '1m', target: 0 }
  ]
};

export default function() {
  const res = http.get('https://api.example.com/users');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500
  });
}
```

## Resources

- [Testing Library](https://testing-library.com/)
- [Jest Docs](https://jestjs.io/)
- [Playwright Docs](https://playwright.dev/)
- [pytest Docs](https://docs.pytest.org/)
