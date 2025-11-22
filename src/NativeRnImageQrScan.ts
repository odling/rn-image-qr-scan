import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  scanFromPath(path: string): Promise<string[]>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RnImageQrScan');
