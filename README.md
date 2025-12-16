# Travelin-iOS

## Authentication System

### Quick Test

To test the authentication flow:

1. Run backend on `http://localhost:3000`
2. Open app - `SimpleLoginTestView` is already configured in `ContentView`
3. Use test credentials: Ask for it to the proyect owners

### Documentation

- 📖 **[LOGIN_IMPLEMENTATION_GUIDE.md](LOGIN_IMPLEMENTATION_GUIDE.md)** - Complete implementation guide for developers
- 🚀 **[LOGIN_TEST_README.md](LOGIN_TEST_README.md)** - Quick start guide for testing

### Test View

`Traveling/Features/Testing/SimpleLoginTestView.swift` - Simple login form that demonstrates:

- Login with email/password
- Token storage in Keychain
- Fetching authenticated user profile (`/me` endpoint)
- Logout functionality

### Architecture Overview

- **URLNetworkClient** - Unified HTTP client with optional interceptor support (consolidated)
- **AuthService** - Handles login and token refresh (uses `URLNetworkClient` without interceptor)
- **UserService** - Handles authenticated requests (uses `URLNetworkClient` with `AuthInterceptor`)
- **KeychainTokenManager** - Secure token storage
- **AuthInterceptor** - Automatic token injection and refresh on 401

For detailed architecture and implementation steps, see:

- [LOGIN_IMPLEMENTATION_GUIDE.md](LOGIN_IMPLEMENTATION_GUIDE.md) - Authentication implementation
- [NETWORK_CLIENT_ARCHITECTURE.md](NETWORK_CLIENT_ARCHITECTURE.md) - **NEW**: Consolidated network layer architecture
