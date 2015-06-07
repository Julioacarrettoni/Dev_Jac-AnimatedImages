//
//  UIImageView+DEVJACAnimatedImage.h
//  Example
//
//  Created by Julio Carrettoni on 6/7/15.
//  Copyright (c) 2015 Julio Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImageView (DEVJACAnimatedImage)

- (void) loadAnimatedPNGFromPath:(NSString*) path;
- (void) loadAnimatedPNGData:(NSData*) data;
- (void) loadAnimatedPNGFromALAsset:(ALAsset*) asset;
- (void) loadAnimatedPNGFromPathCGImageSourceRef:(CGImageSourceRef) isrc;

@end
