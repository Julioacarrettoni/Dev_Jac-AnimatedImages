//
//  UIImageView+DEVJACAnimatedImage.m
//  Example
//
//  Created by Julio Carrettoni on 6/7/15.
//  Copyright (c) 2015 Julio Carrettoni. All rights reserved.
//

#import "UIImageView+DEVJACAnimatedImage.h"

#import <ImageIO/ImageIO.h>

@implementation UIImageView (DEVJACAnimatedImage)

- (void) loadAnimatedPNGFromPath:(NSString*) path {
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        [self loadAnimatedPNGData:data];
    }
}

- (void) loadAnimatedPNGData:(NSData*) data {
    CGImageSourceRef isrc = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    [self loadAnimatedPNGFromPathCGImageSourceRef:isrc];
    if (isrc) {
        CFRelease(isrc);
    }
}

static size_t getBytesAtPositionCallback(void *info, void *buffer, off_t position, size_t count) {
    return [(__bridge id)info getBytes:(uint8_t *)buffer fromOffset:position length:count error:NULL];
}

static void releaseInfoCallback(void *info) {
    CFRelease(info);
}

- (void) loadAnimatedPNGFromALAsset:(ALAsset*) asset {
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getBytesAtPositionCallback,
        .releaseInfo = releaseInfoCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain([asset defaultRepresentation]), [[asset defaultRepresentation] size], &callbacks);
    CGImageSourceRef isrc = CGImageSourceCreateWithDataProvider(provider, NULL);
    [self loadAnimatedPNGFromPathCGImageSourceRef:isrc];
    
    if (provider) {
        CFRelease(provider);
    }
    if (isrc) {
        CFRelease(isrc);
    }
}

- (void) loadAnimatedPNGFromPathCGImageSourceRef:(CGImageSourceRef) isrc {
    NSUInteger count =  CGImageSourceGetCount(isrc);
    
    NSMutableArray* frames = [NSMutableArray array];
    CGFloat totalTime = 0;
    if (count > 0) {
        for (NSInteger i = 0; i < count; i++) {
            NSDictionary* metadata = (NSDictionary*) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(isrc, i, NULL));
            if (metadata[(__bridge NSString*)kCGImagePropertyPNGDictionary]) {
                totalTime += [metadata[(__bridge NSString*)kCGImagePropertyPNGDictionary][(__bridge NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
            }
            else if (metadata[(__bridge NSString*)kCGImagePropertyGIFDictionary]) {
                totalTime += [metadata[(__bridge NSString*)kCGImagePropertyGIFDictionary][(__bridge NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
            }
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(isrc, i, NULL);
            [frames addObject:[UIImage imageWithCGImage:imageRef]];
        }
        
        NSDictionary* globalMetadata = (NSDictionary*) CFBridgingRelease(CGImageSourceCopyProperties(isrc, NULL));
        if (globalMetadata[(__bridge NSString*)kCGImagePropertyPNGDictionary]) {
            self.animationRepeatCount = [globalMetadata[(__bridge NSString*)kCGImagePropertyPNGDictionary][(__bridge NSString*)kCGImagePropertyGIFLoopCount] integerValue];
        }
        else if (globalMetadata[(__bridge NSString*)kCGImagePropertyGIFDictionary]) {
            self.animationRepeatCount = [globalMetadata[(__bridge NSString*)kCGImagePropertyGIFDictionary][(__bridge NSString*)kCGImagePropertyGIFLoopCount] integerValue];
        }
        
        self.image = nil;
        self.animationImages = frames;
        self.animationDuration = totalTime;
        [self startAnimating];
    }
}

@end