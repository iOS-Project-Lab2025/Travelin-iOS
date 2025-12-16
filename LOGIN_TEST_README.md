# Quick Start: Testing Login Flow

## Test View Location

`Traveling/Features/Testing/SimpleLoginTestView.swift`

## Prerequisites

1. Backend running on `http://localhost:3000`
2. Backend implements these endpoints:
   - `POST /v1/auth/login`
   - `POST /v1/auth/refresh`
   - `GET /v1/auth/me`

## Test Credentials

```
Email: test@softserve.com
Password: password123
```

## What It Does

### 1. Login Form

- Enter email and password
- Click "Login" button
- Shows loading indicator while authenticating

### 2. Success State

- Displays user profile information from `/me` endpoint
- Shows:
  - Email
  - First Name (if available)
  - Last Name (if available)
  - User ID (if available)

### 3. Logout

- Clears tokens from Keychain
- Returns to login form

## Key Components

### Services Used

```swift
// Create builders
guard let baseURL = URL(string: "http://localhost:3000") else {
    fatalError("Invalid base URL")
}
let endpointBuilder = EndPointBuilder(baseURL: baseURL)
let payloadBuilder = PayloadBuilder()
let requestBuilder = RequestBuilder(endPointBuilder: endpointBuilder, payloadBuilder: payloadBuilder)

// For login (no auth required)
AuthService(client: URLNetworkClient(), requestBuilder: requestBuilder)

// For authenticated requests (/me endpoint)
let interceptor = AuthInterceptor(tokenManager: KeychainTokenManager())
UserService(client: NetworkClient(interceptor: interceptor), requestBuilder: requestBuilder)

// For token storage
KeychainTokenManager()
```

### Flow

```
Login → Save Tokens → Fetch Profile → Display Info
```

## Running the Test

1. **Start Backend**

   ```bash
   # Make sure backend is running on port 3000
   ```

2. **Run iOS App**

   - Open project in Xcode
   - Run on simulator or device
   - `ContentView` is already configured to show `SimpleLoginTestView`

3. **Test Login**
   - Enter test credentials
   - Verify profile information appears
   - Click logout
   - Verify return to login form

## Implementation Reference

See `LOGIN_IMPLEMENTATION_GUIDE.md` for detailed documentation on:

- Architecture overview
- Step-by-step integration guide
- Code examples
- Best practices
- Full API contracts

## Quick Code Example

```swift
// Minimal login implementation
@MainActor
class LoginViewModel: ObservableObject {
    private let tokenManager = KeychainTokenManager()
    private let authService: AuthService

    init() {
        // Create builders
        guard let baseURL = URL(string: "http://localhost:3000") else {
            fatalError("Invalid base URL")
        }
        let endpointBuilder = EndPointBuilder(baseURL: baseURL)
        let payloadBuilder = PayloadBuilder()
        let requestBuilder = RequestBuilder(endPointBuilder: endpointBuilder, payloadBuilder: payloadBuilder)

        // Create service
        let client = URLNetworkClient()
        authService = AuthService(client: client, requestBuilder: requestBuilder)
    }

    func login(email: String, password: String) async throws {
        // 1. Login
        let response = try await authService.login(email: email, password: password)

        // 2. Save tokens
        let tokens = OAuthTokens(
            accessToken: response.data.accessToken,
            refreshToken: response.data.refreshToken
        )
        try tokenManager.saveTokens(tokens)

        // 3. Navigate to main app
    }
}
```

## Files Modified/Created

### New Files

- ✅ `UserService.swift` - Service for authenticated requests
- ✅ `SimpleLoginTestView.swift` - Test view implementation
- ✅ `LOGIN_IMPLEMENTATION_GUIDE.md` - Full documentation


### Modified Files

- ✅ `ContentView.swift` - Updated to show test view

### Existing Files (Referenced)

- `AuthService.swift` - Login/refresh service (uses public client)
- `UserService.swift` - User profile service (uses authenticated client)
- `KeychainTokenManager.swift` - Token storage
- `URLNetworkClient.swift` - Unified network client (with optional interceptor)
- `AuthInterceptor.swift` - Token injection & refresh
- `UserEndpoint.swift` - API endpoint definitions

