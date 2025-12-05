# Login Implementation Guide

## Overview

This guide explains how to implement the authentication flow in the Traveling iOS app. The current implementation includes a test view (`SimpleLoginTestView`) that demonstrates the complete login flow.

## Architecture Components

### 1. Core Services

#### **AuthService**

- **Location**: `Data/Networking/Services/AuthService.swift`
- **Purpose**: Handles authentication operations (login, token refresh)
- **Network Client**: Uses `URLNetworkClient` (without interceptor)
- **Why**: Login and refresh endpoints don't require prior authentication

```swift
// Usage Example
let authService = AuthService(client: URLNetworkClient(), requestBuilder: RequestBuilder())
let loginResponse = try await authService.login(email: "user@example.com", password: "password")
```

#### **UserService**

- **Location**: `Data/Networking/Services/UserService.swift`
- **Purpose**: Handles user-related operations that require authentication
- **Network Client**: Uses `NetworkClient` (with `AuthInterceptor`)
- **Why**: User endpoints require authentication and automatic token refresh

```swift
// Usage Example
let interceptor = AuthInterceptor(tokenManager: KeychainTokenManager())
let authClient = NetworkClient(interceptor: interceptor)
let userService = UserService(client: authClient, requestBuilder: RequestBuilder())
let profile = try await userService.getUserProfile()
```

### 2. Token Management

#### **KeychainTokenManager**

- **Location**: `Services/KeychainTokenManager.swift`
- **Purpose**: Securely stores and retrieves OAuth tokens in the Keychain
- **Protocol**: Implements `TokenManaging`

```swift
// Usage Example
let tokenManager = KeychainTokenManager()

// Save tokens after login
try tokenManager.saveTokens(tokens)

// Retrieve tokens
let accessToken = tokenManager.getAccessToken()
let refreshToken = tokenManager.getRefreshToken()

// Clear tokens on logout
tokenManager.clearTokens()
```

### 3. Network Layer

#### **NetworkClient** (with interceptor)

- **Location**: `Data/Networking/Core/Services/NetworkClient.swift`
- **Features**:
  - Automatically injects Bearer token via `AuthInterceptor.adapt()`
  - Detects 401 Unauthorized responses
  - Automatically refreshes tokens via `AuthInterceptor.shouldRetry()`
  - Retries original request with new token
- **Use for**: All authenticated endpoints (e.g., `/v1/auth/me`, `/v1/poi/*`)

#### **URLNetworkClient** (without interceptor)

- **Location**: `Data/Networking/Core/Services/URLNetworkClient.swift`
- **Features**: Direct URLSession wrapper
- **Use for**: Public endpoints and authentication endpoints (login, refresh)

### 4. Request Flow

#### Login Flow

```
User Input (email, password)
    ↓
AuthService.login()
    ↓
URLNetworkClient.execute()  [POST /v1/auth/login]
    ↓
LoginResponse { accessToken, refreshToken }
    ↓
KeychainTokenManager.saveTokens()
    ↓
Login Success
```

#### Authenticated Request Flow

```
Request to protected endpoint
    ↓
NetworkClient.execute()
    ↓
AuthInterceptor.adapt()  [Injects Bearer token]
    ↓
API Call
    ↓
Response (200 OK or 401 Unauthorized)
    │
    ├─ 200 OK → Return data
    │
    └─ 401 Unauthorized
           ↓
       AuthInterceptor.shouldRetry()
           ↓
       POST /v1/auth/refresh (with refresh token)
           ↓
       New tokens received
           ↓
       KeychainTokenManager.saveTokens()
           ↓
       Retry original request with new token
           ↓
       Return data
```

## Implementation Steps

### Step 1: Test the Current Implementation

The app currently includes `SimpleLoginTestView` which demonstrates the complete flow:

1. **Run the app** (make sure backend is running on `http://localhost:3000`)
2. **Test credentials**:
   - Email: `test@softserve.com`
   - Password: `password123`
3. **Observe**:
   - Login form → User profile display
   - Automatic token refresh (if you wait for token expiration)

### Step 2: Integrate into Your Feature

To implement login in your own feature (e.g., Login screen):

#### A. Create a ViewModel

```swift
@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let tokenManager: TokenManaging
    private let authService: AuthService

    init(tokenManager: TokenManaging = KeychainTokenManager()) {
        self.tokenManager = tokenManager

        // Create base URL and builders
        guard let baseURL = URL(string: "http://localhost:3000") else {
            fatalError("Invalid base URL")
        }
        let endpointBuilder = EndPointBuilder(baseURL: baseURL)
        let payloadBuilder = PayloadBuilder()
        let requestBuilder = RequestBuilder(endPointBuilder: endpointBuilder, payloadBuilder: payloadBuilder)

        // Create AuthService
        let simpleClient = URLNetworkClient()
        self.authService = AuthService(client: simpleClient, requestBuilder: requestBuilder)
    }

    func login() async {
        isLoading = true
        errorMessage = ""

        do {
            // 1. Login
            let response = try await authService.login(email: email, password: password)

            // 2. Save tokens
            let tokens = OAuthTokens(
                accessToken: response.data.accessToken,
                refreshToken: response.data.refreshToken
            )
            try tokenManager.saveTokens(tokens)

            // 3. Navigate to main app
            // (Implement your navigation logic here)

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
```

#### B. Create Your Login View

```swift
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }

            Button("Login") {
                Task { await viewModel.login() }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
    }
}
```

### Step 3: Check Authentication State

To determine if user is logged in (e.g., in app startup):

```swift
struct TravelingApp: App {
    @State private var isAuthenticated = false
    private let tokenManager = KeychainTokenManager()

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                HomeView() // Your main app view
            } else {
                LoginView()
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }

    private func checkAuthStatus() {
        // Check if we have valid tokens
        isAuthenticated = tokenManager.getAccessToken() != nil
    }
}
```

### Step 4: Handle Logout

```swift
func logout() {
    // Clear tokens
    tokenManager.clearTokens()

    // Navigate to login screen
    // (Implement your navigation logic)
}
```

### Step 5: Making Authenticated Requests

For any feature that needs authenticated API calls:

```swift
class MyFeatureViewModel: ObservableObject {
    private let userService: UserService

    init() {
        // Create base URL and builders
        guard let baseURL = URL(string: "http://localhost:3000") else {
            fatalError("Invalid base URL")
        }
        let endpointBuilder = EndPointBuilder(baseURL: baseURL)
        let payloadBuilder = PayloadBuilder()
        let requestBuilder = RequestBuilder(endPointBuilder: endpointBuilder, payloadBuilder: payloadBuilder)

        // Initialize with NetworkClient (includes interceptor)
        let tokenManager = KeychainTokenManager()
        let interceptor = AuthInterceptor(tokenManager: tokenManager)
        let authClient = NetworkClient(interceptor: interceptor)

        self.userService = UserService(client: authClient, requestBuilder: requestBuilder)
    }

    func loadUserProfile() async {
        do {
            let profile = try await userService.getUserProfile()
            // Use profile data
        } catch {
            // Handle error (e.g., token expired, network error)
            // If tokens are invalid, the interceptor will try to refresh
            // If refresh fails, user will need to login again
        }
    }
}
```

## Important Notes

### ✅ DO:

- Use `URLNetworkClient` for login and refresh endpoints
- Use `NetworkClient` (with interceptor) for authenticated endpoints
- Store tokens securely using `KeychainTokenManager`
- Handle errors gracefully (network errors, invalid credentials, etc.)
- Clear tokens on logout
- Check for token existence to determine auth state

### ❌ DON'T:

- Don't use `NetworkClient` with interceptor for login/refresh (creates infinite loop)
- Don't store tokens in UserDefaults or other insecure storage
- Don't manually inject Bearer tokens when using `NetworkClient` (interceptor handles it)
- Don't manually refresh tokens (interceptor handles it automatically)

## Backend Requirements

Your backend must implement these endpoints:

### POST `/v1/auth/login`

```json
// Request
{
  "email": "user@example.com",
  "password": "password123"
}

// Response
{
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe"
    },
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG..."
  }
}
```

### POST `/v1/auth/refresh`

```json
// Request
{
  "refreshToken": "eyJhbG..."
}

// Response
{
  "data": {
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG..."
  }
}
```

### GET `/v1/auth/me`

```json
// Request Headers
{
  "Authorization": "Bearer eyJhbG..."
}

// Response
{
  "data": {
    "user": {
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "id": "123"
    }
  }
}
```

## Testing Checklist

- [ ] User can login with valid credentials
- [ ] Error message shown for invalid credentials
- [ ] Tokens are stored in Keychain after login
- [ ] User can logout (tokens cleared)
- [ ] Authenticated requests work (e.g., `/me` endpoint)
- [ ] Token refresh works automatically on 401
- [ ] App redirects to login when tokens are invalid/expired
- [ ] Network errors are handled gracefully

## File Locations Reference

```
Traveling/
├── Data/
│   └── Networking/
│       ├── Services/
│       │   ├── AuthService.swift          # Login/Refresh
│       │   └── UserService.swift          # User profile
│       ├── Core/
│       │   └── Services/
│       │       ├── NetworkClient.swift    # With interceptor
│       │       └── URLNetworkClient.swift # Without interceptor
│       ├── Interceptors/
│       │   └── AuthInterceptor.swift      # Token injection & refresh
│       └── Endpoints/
│           └── Auth/
│               └── UserEndpoint.swift     # API endpoints
├── Services/
│   ├── KeychainTokenManager.swift         # Token storage
│   └── TokenManaging.swift                # Protocol
├── Models/
│   └── OAuthTokens.swift                  # Token model
└── Features/
    └── Testing/
        └── SimpleLoginTestView.swift      # Test implementation
```

## Next Steps

1. Review `SimpleLoginTestView.swift` to understand the flow
2. Test with the backend running on `localhost:3000`
3. Implement your own `LoginView` based on the examples above
4. Add proper navigation between login and authenticated states
5. Add error handling and loading states for better UX
6. Consider adding biometric authentication (Face ID/Touch ID) as an enhancement

## Support

If you encounter issues:

1. Check that backend is running on `http://localhost:3000`
2. Verify API endpoints match the backend implementation
3. Check Xcode console for error messages
4. Review token storage in Keychain (use Keychain Access app on macOS)
