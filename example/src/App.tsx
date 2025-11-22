import {
  Text,
  View,
  StyleSheet,
  Image,
  ActivityIndicator,
  TouchableOpacity,
  Platform,
} from 'react-native';
import { scanFromPath } from '@odling/rn-image-qr-scan';
import { useState, useRef } from 'react';
import { captureRef } from 'react-native-view-shot';

const qrImage = require('./assets/images/Example.png');

export default function App() {
  const [result, setResult] = useState<string[]>([]);
  const [isScanning, setIsScanning] = useState(false);
  const viewRef = useRef(null);

  /**
   * Loads the qr directly from the assets folder on ios.
   * Captures the screen and scans the screenshot on android
   */
  const handleScan = async () => {
    try {
      setIsScanning(true);

      const assetSource = Image.resolveAssetSource(qrImage);
      let imageUri = assetSource?.uri ?? '';

      if (Platform.OS === 'android')
        // Capture the view as an image
        imageUri = await captureRef(viewRef, {
          format: 'png',
          quality: 1,
          result: 'tmpfile',
        });

      const scanResult = await scanFromPath(imageUri);

      setResult(scanResult);
    } catch (error) {
      console.error('Scan error:', error);
      setResult([]);
    } finally {
      setIsScanning(false);
    }
  };

  const handleClear = () => {
    setResult([]);
  };

  return (
    <View style={styles.container} ref={viewRef} collapsable={false}>
      <View style={styles.qrContainer}>
        <Image source={qrImage} style={styles.qrImage} />
      </View>

      {result.length > 0 && (
        <View style={styles.resultContainer}>
          <Text style={styles.resultTitle}>Scanned Results</Text>
          <Text style={styles.resultText}>{result.join('\n')}</Text>
        </View>
      )}

      <TouchableOpacity
        style={styles.button}
        onPress={result.length > 0 ? handleClear : handleScan}
      >
        {!isScanning && (
          <Text style={styles.buttonText}>
            {result.length > 0 ? 'Clear' : 'Scan'}
          </Text>
        )}
        {isScanning && <ActivityIndicator size="small" color="black" />}
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 24,
    gap: 24,
    backgroundColor: 'white',
  },
  button: {
    borderRadius: 8,
    height: 56,
    alignItems: 'center',
    justifyContent: 'center',
    width: 220,
    fontSize: 16,
    backgroundColor: '#E0E0E0',
  },
  buttonText: {
    color: 'black',
    fontSize: 16,
    fontWeight: 'bold',
  },
  resultContainer: {
    gap: 8,
    borderRadius: 8,
    alignItems: 'center',
  },
  resultTitle: {
    color: 'black',
    fontSize: 16,
    fontWeight: 'bold',
  },
  resultText: {
    color: 'black',
    fontSize: 14,
    textAlign: 'center',
  },
  qrContainer: {
    backgroundColor: 'white',
  },
  qrImage: {
    width: 200,
    height: 200,
    resizeMode: 'contain',
  },
});
