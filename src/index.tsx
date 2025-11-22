import RnImageQrScan from './NativeRnImageQrScan';

export function scanFromPath(path: string): Promise<string[]> {
  return RnImageQrScan.scanFromPath(path);
}
