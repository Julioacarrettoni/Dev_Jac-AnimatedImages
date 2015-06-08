# Dev_Jac-AnimatedImages
Simple category to load animated image files into an UIImageView.
It currently support GIF and APNG (Animated PNG, or Animated Portable Network Graphic) http://es.wikipedia.org/wiki/Animated_Portable_Network_Graphics

## Usage

Just add the category to your project (_CocoaPods support comming soon_)

It adds the following methods to `UIImageView`:

```objc
- (void) loadAnimatedPNGFromPath:(NSString*) path;
- (void) loadAnimatedPNGData:(NSData*) data;
- (void) loadAnimatedPNGFromALAsset:(ALAsset*) asset;
- (void) loadAnimatedPNGFromPathCGImageSourceRef:(CGImageSourceRef) isrc;
```
Invoking any of those into a `UIImageView` object will populate the required UIImageView properties:

- animationImages 
- animationDuration
- animationRepeatCount

## Example

Check the example folder on how to use it to load a GIF or a APNG, and how to use it to load images from the Camera Roll successfully using the `ALAsset` object and a `CGDataProviderRef`

![image](https://raw.githubusercontent.com/Julioacarrettoni/Dev_Jac-AnimatedImages/master/Example/Example/example_screenshot.png)

## License

MIT

## Contributing

Issues andPull Requests on GitHub are welcome.
