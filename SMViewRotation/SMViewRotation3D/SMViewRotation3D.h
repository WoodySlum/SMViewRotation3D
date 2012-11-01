//
//  SMViewRotation3D.h
//  Sebastien MIZRAHI
//

/**
 * Lib that allows you to transform any UIView in 3D, with gestures, autorotation and compass
 * Type : NSObject
 *
 * @author     S. Mizrahi
 * @version    SVN: $Id: SMViewRotation3D.h 23810 2012-11-01 11:07:44Z smizrahi $
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#define VERTICAL_ANGLE 50.0f
#define VIEW_CORNER_RADIUS 0.0f

@interface SMViewRotation3D : NSObject <CLLocationManagerDelegate> {
    id view;
    UIView *fogView;
    UIRotationGestureRecognizer *twoFingersRotate;
    UIPinchGestureRecognizer *twoFingerPinch;
    float vHorizontal_angle;
    float vVertical_angle;
    float vZoom_scale;
    float rotationSpeed;
    NSTimer *rotationTimer;
    BOOL libEnabled;
    BOOL enablePinchToZoom;
    BOOL enableTwoFingersRotate;
    BOOL enableFog;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) id view;

- (void) initWithTransformation:(BOOL)pinchToZoom setTwoFingersRotate:(BOOL)twoFingersRotation;
- (void) initWithTransformation;
- (void) clearTransformation;
- (void) startAutorotate:(float) speed;
- (void) stopAutorotate;
- (void) clearRotation;
- (void) clearZoom;
- (void) startCompassRotate;
- (void) stopCompassRotate;

@end

@interface SMViewRotation3D (PrivateMethods)

- (void) twoFingersRotate:(UIRotationGestureRecognizer *)recognizer;
- (void) twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;
- (void) setTransformation;
- (void) setFog;
- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading;

@end
