# @odling/rn-image-qr-scan

A React Native module that allows you to scan QR codes directly from an image file path.

## Installation

```sh
npm install @odling/rn-image-qr-scan
```

or

```sh
yarn add @odling/rn-image-qr-scan
```

## Usage

```js
import { scanFromPath } from '@odling/rn-image-qr-scan';

// ...

try {
  // Pass the local file path of the image
  const result = await scanFromPath('file:///path/to/image.jpg');
  console.log('QR Code data:', result); // Returns an array of strings found in the QR code(s)
} catch (error) {
  console.error('Failed to scan QR code:', error);
}
```

## Credits

This module was inspired by and references the article **"Implement QR Code Scanning from an Image in React Native"** by [Max Wang](https://medium.com/@maxslashwang).

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
