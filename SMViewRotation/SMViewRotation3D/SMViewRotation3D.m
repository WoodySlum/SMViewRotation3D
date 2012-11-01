//
//  SMViewRotation3D.m
//  Sebastien MIZRAHI
//

/**
 * Lib that allows you to transform any UIView in 3D, with gestures, autorotation and compass
 * Type : NSObject
 *
 * @author     S. Mizrahi
 * @version    SVN: $Id: SMViewRotation3D.m 23810 2012-11-01 11:07:44Z smizrahi $
 */

#import "SMViewRotation3D.h"

@implementation SMViewRotation3D

@synthesize view;


#pragma mark - Init

/**
 * Constructor
 */
-(id) init {
    self = [super init];
    if (self) {
        libEnabled = NO;
        enablePinchToZoom = YES;
        enableTwoFingersRotate = YES;
        enableFog = NO;
    }
    
    return self;
}

/**
 * Method called to enable the 3D effect
 *
 * @param BOOL pinchToZoom Allow the pinch to zoom gesture
 * @param BOOL twoFingersRotate Allow the 2 fingers rotation gesture
 */
- (void) initWithTransformation:(BOOL)pinchToZoom setTwoFingersRotate:(BOOL)twoFingersRotation {
    enablePinchToZoom = pinchToZoom;
    enableTwoFingersRotate = twoFingersRotation;
    [self initWithTransformation];
}

/**
 * Method called to enable the 3D effect
 */
- (void) initWithTransformation {
    UIView *tView = (UIView *) view;
    libEnabled = YES;
    rotationSpeed = 10.0f;
    vHorizontal_angle = 0.0f;
    vZoom_scale = 1.0f;
    vVertical_angle = VERTICAL_ANGLE * M_PI / 180.0f;
    [self setFog];

    // Test if MKMapView is in subviews. If yes, pinch gesture will be disabled
    if ([tView isMemberOfClass:[MKMapView class]]) {
        enablePinchToZoom = NO;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    if (enableFog) fogView.alpha = 1.0f;
    [self setTransformation];
    tView.layer.cornerRadius = VIEW_CORNER_RADIUS;
    
    [UIView commitAnimations];
    
    // Create gesture recognizer (rotation)
    if (enableTwoFingersRotate) {
        twoFingersRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersRotate:)];
        [tView addGestureRecognizer: twoFingersRotate];
    }
    
    // Create gesture recognizer (pinch)
    if (enablePinchToZoom) {
        twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
        [tView addGestureRecognizer: twoFingerPinch];
    }
}

#pragma mark - Gestures

/**
 * Method called when a two fingers rotation gesture is recognized
 *
 * @param UIRotationGestureRecognizer recognizer The gesture recognizer
 */
- (void)twoFingersRotate:(UIRotationGestureRecognizer *)recognizer
{
    [self stopAutorotate];
    vHorizontal_angle = [recognizer rotation] * (180 / M_PI) / 30;
    [self setTransformation];
}

/**
 * Method called when a two fingers pinch gesture is recognized
 *
 * @param UIRotationGestureRecognizer recognizer The gesture recognizer
 */
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    if ((recognizer.scale >= 1.0f) && (recognizer.scale <= 4.0f)) {
        vZoom_scale = recognizer.scale;
    }
    
    [self setTransformation];
}

#pragma mark - Transformation

/**
 * This method apply a transformation to an UIView
 */
- (void) setTransformation {
    UIView *tView = (UIView *) view;
    
    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform.m34 = 1.0 / -500;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;

    rotationTransform = CATransform3DRotate(rotationTransform, vVertical_angle, 1.0f, 0.0f, 0.0f);
    rotationTransform = CATransform3DRotate(rotationTransform, vHorizontal_angle, 0.0, 0.0, 1.0);
    rotationTransform = CATransform3DScale(rotationTransform, vZoom_scale, vZoom_scale, vZoom_scale);
    tView.layer.transform = rotationTransform;

}

#pragma mark - Clear methods

/**
 * This method stops all the transformations applied by the library
 */
- (void) clearTransformation {
    UIView *tView = (UIView *) view;
    
    vHorizontal_angle   = 0.0f;
    vVertical_angle     = 0.0f;
    vZoom_scale         = 1.0f;
    [self stopAutorotate];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [self setTransformation];
    tView.layer.cornerRadius = 0.0f;
    
    if (enableFog) {
        fogView.alpha = 0.0f;
    }
    [UIView commitAnimations];
    
    if (enableFog) {
        [fogView removeFromSuperview];
        fogView = nil;
    }
    
    if (locationManager) {
        [locationManager stopUpdatingHeading];
        locationManager = nil;
    }
    
    libEnabled = NO;
    
    // Gestures
    [tView removeGestureRecognizer: twoFingerPinch];
    [tView removeGestureRecognizer: twoFingersRotate];
    twoFingerPinch = nil;
    twoFingersRotate = nil;
}

/**
 * This method reinitialize view rotation
 */
- (void) clearRotation {
    vHorizontal_angle = 0.0f;
    [self setTransformation];
}

/**
 * This method reinitialize the zoom
 */
- (void) clearZoom {
    vZoom_scale = 1.0f;
    [self setTransformation];
}

#pragma mark - Fog effect (experimental)

/**
 * This method display a fog effect (experimental)
 */
- (void) setFog {
    UIView *tView = (UIView *) view;
    CGRect initialViewFrame = tView.frame;
    initialViewFrame.size.height = initialViewFrame.size.height;
    initialViewFrame.origin.y += 10.0f;
    fogView = [[UIView alloc] init];
    fogView.frame = initialViewFrame;
    
    fogView.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = fogView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.8f] CGColor], nil];
    [fogView.layer insertSublayer:gradient atIndex:0];
    [fogView setUserInteractionEnabled: NO];
    
    [tView.superview.superview addSubview:fogView];
    fogView.alpha = 0.0f;
}


#pragma mark - Actions

/**
 * Enables an automatic 3D horizontal orientation, using a NSTimer
 *
 * @param float speed Speed of effect (e.g. : 10)
 */
- (void) startAutorotate:(float) speed {
    if (libEnabled && (rotationTimer == nil)) {
        rotationSpeed = speed;
        rotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(incrementRotation)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

/**
 * Used to increment the horizontal angle
 */
- (void) incrementRotation {
    vHorizontal_angle += (0.001f * rotationSpeed);
    if (vHorizontal_angle > 360) vHorizontal_angle = 0;
    [self setTransformation];
}

/**
 * Stop auto rotation of the view
 */
- (void) stopAutorotate {
    [rotationTimer invalidate];
    rotationTimer = nil;
}

/**
 * Start rotation with the phone's compass
 */
- (void) startCompassRotate {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingHeading];
}

/**
 * Stop rotation with the phone's compass
 */
- (void) stopCompassRotate {
    if (locationManager) {
        locationManager = nil;
    }
    [locationManager stopUpdatingHeading];
}

#pragma mark - CLLocation manager delegate

/**
 * Method used when updating compass
 */
- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    vHorizontal_angle =  ((newHeading.magneticHeading) / 180.0f * M_PI) + 90.0f;
    if (vHorizontal_angle > 360.0f) vHorizontal_angle -= 360.0f;
    [self setTransformation];
}

#pragma mark - Destructor

- (void)dealloc {
    [self clearTransformation];
}


@end
