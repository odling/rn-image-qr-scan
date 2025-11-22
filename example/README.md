# Example App for @odling/rn-image-qr-scan

This is an example application demonstrating the usage of the `@odling/rn-image-qr-scan` module.

## Prerequisites

- [Node.js](https://nodejs.org/)
- [Yarn](https://yarnpkg.com/)
- [React Native development environment](https://reactnative.dev/docs/environment-setup) set up for iOS and/or Android.

## Getting Started

1. **Install dependencies:**

   From the root of the repository (if using a monorepo structure) or inside the `example` folder:

   ```sh
   yarn install
   ```

2. **Install iOS Pods (iOS only):**

   ```sh
   cd ios
   pod install
   cd ..
   ```

3. **Run the Metro Bundler:**

   ```sh
   yarn start
   ```

4. **Run the App:**

   - **Android:**
     ```sh
     yarn android
     ```

   - **iOS:**
     ```sh
     yarn ios
     ```

## Troubleshooting

If you encounter issues with the module resolution, ensure that the dependencies are correctly linked and that `metro.config.js` is properly configured to resolve the local module.
