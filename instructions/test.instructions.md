# Testing Instructions & Best Practices

> Guidelines for writing effective unit tests across Java and TypeScript projects

---

## 🎯 General Testing Principles

### Universal Best Practices

1. **Test Behavior, Not Implementation**
   - Focus on what the code does, not how it does it
   - Tests should survive refactoring of internal logic

2. **Follow AAA Pattern**
   - **Arrange:** Set up test data and preconditions
   - **Act:** Execute the code under test
   - **Assert:** Verify the expected outcome

3. **Keep Tests Independent**
   - Each test should run in isolation
   - No shared state between tests
   - Tests can run in any order

4. **Use Descriptive Names**
   - Test names should describe the scenario and expected outcome
   - Format: `should_ExpectedBehavior_When_StateUnderTest`
   - Example: `should_ReturnNull_When_UserNotFound`

5. **One Assertion Per Logical Concept**
   - Multiple assertions are OK if testing the same concept
   - Avoid unrelated assertions in a single test

6. **Test Edge Cases**
   - Null/undefined inputs
   - Empty collections
   - Boundary values
   - Error conditions

---

## ☕ Java Unit Testing (JUnit 5 + Mockito)

### Test Structure

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    @DisplayName("should return user when valid ID is provided")
    void should_ReturnUser_When_ValidIdProvided() {
        // Arrange
        Long userId = 1L;
        User expectedUser = new User(userId, "John Doe");
        when(userRepository.findById(userId)).thenReturn(Optional.of(expectedUser));
        
        // Act
        User result = userService.getUserById(userId);
        
        // Assert
        assertNotNull(result);
        assertEquals(expectedUser.getName(), result.getName());
        verify(userRepository, times(1)).findById(userId);
    }
    
    @Test
    @DisplayName("should throw exception when user not found")
    void should_ThrowException_When_UserNotFound() {
        // Arrange
        Long userId = 999L;
        when(userRepository.findById(userId)).thenReturn(Optional.empty());
        
        // Act & Assert
        assertThrows(UserNotFoundException.class, () -> {
            userService.getUserById(userId);
        });
    }
}
```

### Java Best Practices

**Mocking:**
```java
// ✅ Good: Mock external dependencies
@Mock
private EmailService emailService;

// ✅ Good: Verify interactions when side effects matter
verify(emailService).sendEmail(eq("user@example.com"), any());

// ❌ Bad: Don't mock the class under test
// @InjectMocks should only be on the class you're testing
```

**Parameterized Tests:**
```java
@ParameterizedTest
@ValueSource(strings = {"", "  ", "\t", "\n"})
@DisplayName("should reject blank usernames")
void should_RejectBlankUsernames(String username) {
    assertThrows(ValidationException.class, () -> {
        userService.createUser(username);
    });
}

@ParameterizedTest
@CsvSource({
    "1, 2, 3",
    "10, 20, 30",
    "-5, 5, 0"
})
void should_AddNumbers_Correctly(int a, int b, int expected) {
    assertEquals(expected, calculator.add(a, b));
}
```

**Integration Tests (Spring Boot):**
```java
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerIntegrationTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    @DisplayName("should return 200 when getting existing user")
    void should_Return200_When_GettingExistingUser() throws Exception {
        mockMvc.perform(get("/api/users/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.name").value("John Doe"));
    }
}
```

**Test Containers (for DB tests):**
```java
@Testcontainers
@SpringBootTest
class UserRepositoryIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16")
        .withDatabaseName("testdb");
    
    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }
    
    @Test
    void should_SaveAndRetrieveUser() {
        // Test with real database
    }
}
```

---

## 📘 TypeScript Unit Testing (Vitest + Vue Test Utils)

### Test Structure

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import UserProfile from '@/components/UserProfile.vue'
import { useUserStore } from '@/stores/user'

describe('UserProfile', () => {
  let userStore: ReturnType<typeof useUserStore>
  
  beforeEach(() => {
    userStore = useUserStore()
    userStore.$reset()
  })
  
  it('should display user name when user is loaded', () => {
    // Arrange
    userStore.currentUser = { id: 1, name: 'John Doe' }
    
    // Act
    const wrapper = mount(UserProfile)
    
    // Assert
    expect(wrapper.text()).toContain('John Doe')
  })
  
  it('should show loading state when user is null', () => {
    // Arrange
    userStore.currentUser = null
    
    // Act
    const wrapper = mount(UserProfile)
    
    // Assert
    expect(wrapper.find('[data-testid="loading"]').exists()).toBe(true)
  })
})
```

### TypeScript Best Practices

**Mocking API Calls:**
```typescript
import { vi } from 'vitest'
import { fetchUser } from '@/api/user'

vi.mock('@/api/user', () => ({
  fetchUser: vi.fn()
}))

describe('UserService', () => {
  it('should fetch user from API', async () => {
    // Arrange
    const mockUser = { id: 1, name: 'John' }
    vi.mocked(fetchUser).mockResolvedValue(mockUser)
    
    // Act
    const result = await userService.getUser(1)
    
    // Assert
    expect(result).toEqual(mockUser)
    expect(fetchUser).toHaveBeenCalledWith(1)
  })
})
```

**Testing Composables:**
```typescript
import { describe, it, expect } from 'vitest'
import { useCounter } from '@/composables/useCounter'

describe('useCounter', () => {
  it('should increment counter', () => {
    // Arrange
    const { count, increment } = useCounter()
    
    // Act
    increment()
    
    // Assert
    expect(count.value).toBe(1)
  })
  
  it('should reset counter', () => {
    // Arrange
    const { count, increment, reset } = useCounter()
    increment()
    increment()
    
    // Act
    reset()
    
    // Assert
    expect(count.value).toBe(0)
  })
})
```

**Testing Async Operations:**
```typescript
import { describe, it, expect, vi } from 'vitest'
import { flushPromises } from '@vue/test-utils'

describe('AsyncComponent', () => {
  it('should handle async data loading', async () => {
    // Arrange
    const mockData = { id: 1, name: 'Test' }
    vi.spyOn(api, 'fetchData').mockResolvedValue(mockData)
    
    // Act
    const wrapper = mount(AsyncComponent)
    await flushPromises() // Wait for promises to resolve
    
    // Assert
    expect(wrapper.text()).toContain('Test')
  })
})
```

**Snapshot Testing (use sparingly):**
```typescript
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import Button from '@/components/Button.vue'

describe('Button', () => {
  it('should match snapshot', () => {
    const wrapper = mount(Button, {
      props: { label: 'Click me' }
    })
    
    expect(wrapper.html()).toMatchSnapshot()
  })
})
```

**Testing Pinia Stores:**
```typescript
import { setActivePinia, createPinia } from 'pinia'
import { describe, it, expect, beforeEach } from 'vitest'
import { useUserStore } from '@/stores/user'

describe('UserStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })
  
  it('should update user state', () => {
    // Arrange
    const store = useUserStore()
    const newUser = { id: 1, name: 'John' }
    
    // Act
    store.setUser(newUser)
    
    // Assert
    expect(store.currentUser).toEqual(newUser)
    expect(store.isLoggedIn).toBe(true)
  })
})
```

---

## 🚫 Common Pitfalls

### ❌ Don't Do This

```java
// ❌ Testing implementation details
@Test
void testInternalMethod() {
    // Don't test private methods directly
}

// ❌ Multiple unrelated assertions
@Test
void testEverything() {
    assertEquals(result1, expected1); // Testing user creation
    assertEquals(result2, expected2); // Testing email validation
    assertEquals(result3, expected3); // Testing password hashing
}

// ❌ Hardcoded dates/times
@Test
void testDateLogic() {
    LocalDate today = LocalDate.of(2025, 12, 20); // Will fail tomorrow!
}
```

```typescript
// ❌ Testing framework internals
it('should call Vue lifecycle hooks', () => {
  expect(wrapper.vm.mounted).toHaveBeenCalled() // Don't test Vue internals
})

// ❌ Overusing snapshots
it('should render correctly', () => {
  expect(wrapper.html()).toMatchSnapshot() // Brittle, hard to maintain
})

// ❌ Not cleaning up mocks
it('test 1', () => {
  vi.mock('./api') // Affects next test!
})
```

### ✅ Do This Instead

```java
// ✅ Test public behavior
@Test
void should_CreateUser_Successfully() {
    User user = userService.createUser("john@example.com", "password");
    assertNotNull(user.getId());
}

// ✅ One logical concept per test
@Test
void should_ValidateEmail_Format() {
    assertThrows(ValidationException.class, () -> {
        userService.createUser("invalid-email", "password");
    });
}

// ✅ Use relative dates
@Test
void should_CalculateAge_Correctly() {
    LocalDate birthDate = LocalDate.now().minusYears(25);
    int age = userService.calculateAge(birthDate);
    assertEquals(25, age);
}
```

```typescript
// ✅ Test component behavior
it('should emit event when button clicked', async () => {
  const wrapper = mount(MyButton)
  await wrapper.find('button').trigger('click')
  expect(wrapper.emitted('click')).toBeTruthy()
})

// ✅ Specific assertions over snapshots
it('should render user name', () => {
  const wrapper = mount(UserCard, { props: { user: mockUser } })
  expect(wrapper.find('[data-testid="user-name"]').text()).toBe('John Doe')
})

// ✅ Restore mocks in beforeEach/afterEach
beforeEach(() => {
  vi.clearAllMocks()
})
```

---

## 📊 Coverage Guidelines

- **Target:** 80%+ code coverage minimum
- **Focus on:** Business logic, edge cases, error handling
- **Less critical:** Getters/setters, simple data classes, UI positioning
- **Use:** Coverage as a guide, not a goal

**Run coverage:**
```bash
# Java
mvn test jacoco:report

# TypeScript
npm run test:coverage
```

---

## 🔗 Additional Resources

- **Java:** [JUnit 5 Docs](https://junit.org/junit5/docs/current/user-guide/), [Mockito Docs](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)
- **TypeScript:** [Vitest Docs](https://vitest.dev/), [Vue Test Utils](https://test-utils.vuejs.org/)
- **Testcontainers:** [Official Site](https://testcontainers.com/)

---

**Last Updated:** December 20, 2025  
**Type:** Abstract template (adapt patterns for your project)
