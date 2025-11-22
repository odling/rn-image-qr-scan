#import "RnImageQrScan.h"
#import <UIKit/UIKit.h>
#import <Vision/Vision.h>
#import <TargetConditionals.h>
#import <React/RCTBridgeModule.h>

@implementation RnImageQrScan

- (void)scanFromPath:(NSString *)path
            resolve:(RCTPromiseResolveBlock)resolve
             reject:(RCTPromiseRejectBlock)reject
{
    NSURL *url = [NSURL URLWithString:path];
    if (url == nil) {
        reject(@"", [NSString stringWithFormat:@"Cannot get image from path: %@", path], nil);
        return;
    }

    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        reject(@"", [NSString stringWithFormat:@"Cannot get image from path: %@", path], nil);
        return;
    }

    UIImage *image = [UIImage imageWithData:data];
    if (image == nil) {
        reject(@"", [NSString stringWithFormat:@"Cannot get image from path: %@", path], nil);
        return;
    }

    CGImageRef cgImage = image.CGImage;
    if (cgImage == nil) {
        reject(@"", @"Cannot get cgImage from image", nil);
        return;
    }

    __block NSArray<NSString *> *resultsPayload = nil;
    __block NSError *completionError = nil;

    VNDetectBarcodesRequest *request = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(__kindof VNRequest * _Nonnull req, NSError * _Nullable error) {
        if (error != nil) {
            completionError = error;
            return;
        }

        NSArray<VNBarcodeObservation *> *observations = (NSArray<VNBarcodeObservation *> *)req.results;
        if (observations == nil) {
            completionError = [NSError errorWithDomain:@"RnImageQrScan"
                                                  code:-1
                                              userInfo:@{NSLocalizedDescriptionKey: @"Cannot get result from VNDetectBarcodesRequest"}];
            return;
        }

        NSMutableArray<NSString *> *payloads = [NSMutableArray arrayWithCapacity:observations.count];
        for (VNBarcodeObservation *obs in observations) {
            if (obs.payloadStringValue != nil) {
                [payloads addObject:obs.payloadStringValue];
            }
        }
        resultsPayload = [payloads copy];
    }];

    request.symbologies = @[VNBarcodeSymbologyQR];

    #if TARGET_OS_SIMULATOR
      request.revision = VNDetectBarcodesRequestRevision1;
    #endif

    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:cgImage options:@{}];
    NSError *performError = nil;
    BOOL ok = [handler performRequests:@[request] error:&performError];
    if (!ok) {
        NSString *msg = [NSString stringWithFormat:@"Error when performing request on VNImageRequestHandler: %@", performError.localizedDescription ?: @"Unknown error"];
        reject(@"", msg, performError);
        return;
    }

    if (completionError != nil) {
        NSString *msg = [NSString stringWithFormat:@"Cannot get result from VNDetectBarcodesRequest: %@", completionError.localizedDescription ?: @"Unknown error"];
        reject(@"", msg, completionError);
        return;
    }

    if (resultsPayload == nil) {
        resolve(@[]);
        return;
    }

    resolve(resultsPayload);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnImageQrScanSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"RnImageQrScan";
}

@end
