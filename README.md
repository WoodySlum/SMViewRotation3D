##SMViewRotation3D

This code allows you to give perspective to any UIView based objects. You can apply this library to a map view to have a TomTom map like.

![Screenshot of SMViewRotation3D](https://dl.dropbox.com/u/9858108/SMViewRotation3D-2.png "SMViewRotation3D map Screenshot")
![Screenshot of SMViewRotation3D](https://dl.dropbox.com/u/9858108/SMViewRotation3D-3.png "SMViewRotation3D raw Screenshot")

###Features

* Apply 3D transformation to any UIView 
* Rotation and pinch gestures supported
* Automatic rotation to the UIView
* Compass rotation based (such Maps)

###How to use it

First, include the following frameworks : QuartzCore and MapKit
Then include : 

``` objective-c
#import "SMViewRotation3D.h"
```

To enable the 3D effects, just create a property interface :
``` objective-c
@property (nonatomic) SMViewRotation3D *smViewRotation;
```

And init in viewDidLoad, and give to the view property the UIView based object you need :
``` objective-c
self.smViewRotation = [[SMViewRotation3D alloc] init];
self.smViewRotation.view = testView;
```

Then, to enable the effect, just call when needed :
``` objective-c
- (void) initWithTransformation;
```

Or if you need to disable some gestures :
``` objective-c
- (void) initWithTransformation:(BOOL)pinchToZoom setTwoFingersRotate:(BOOL)twoFingersRotation;
```

To stop/disable the effect, call :
``` objective-c
- (void) clearTransformation;
```

###Public methods

``` objective-c
- (void) initWithTransformation:(BOOL)pinchToZoom setTwoFingersRotate:(BOOL)twoFingersRotation;
- (void) initWithTransformation;
- (void) clearTransformation;
- (void) startAutorotate:(float) speed;
- (void) stopAutorotate;
- (void) clearRotation;
- (void) clearZoom;
- (void) startCompassRotate;
- (void) stopCompassRotate;
```

###Customizing

If you need more perspective effect, you can change the angle constant in SMViewRotation3D.h ; you can also add a corner radius to your view.

###Automatic Reference Counting (ARC) support
SMViewRotation3D supports ARC. If you need to include the lib into a non-arc project, just add the -f-objc-arc flag 

###Todo
* Fog effect
* ...

## Contact

- http://github.com/WoodySlum
- seb.mizrahi@gmail.com


## License

### MIT License

Copyright (c) 2012 Sebastien Mizrahi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


