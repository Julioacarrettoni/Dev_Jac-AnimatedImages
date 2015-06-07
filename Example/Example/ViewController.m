//
//  ViewController.m
//  Example
//
//  Created by Julio Carrettoni on 6/7/15.
//  Copyright (c) 2015 Julio Carrettoni. All rights reserved.
//

#import "ViewController.h"

#import "UIImageView+DEVJACAnimatedImage.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self onLoadGifButtonTUI:nil];
}

- (IBAction)onLoadGifButtonTUI:(id)sender {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
    [self.imageView loadAnimatedPNGFromPath:path];
}

- (IBAction)onLoadAnimatedPNGButtonTUI:(id)sender {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"lion-apng" ofType:@"png"];
    [self.imageView loadAnimatedPNGFromPath:path];
}

- (IBAction)onLoadFromCameraRollButtonTUI:(id)sender {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageView.image = info[@"UIImagePickerControllerOriginalImage"];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    [[ALAssetsLibrary new] assetForURL:assetURL
                           resultBlock:^(ALAsset *asset) {
                               [self.imageView loadAnimatedPNGFromALAsset:asset];
                           }
                          failureBlock:^(NSError *error) {
                              
                          }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
