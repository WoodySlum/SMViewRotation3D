//
//  ViewController.h
//  SMViewRotation
//
//  Created by Seb on 28/10/12.
//  Copyright (c) 2012 S. MIZRAHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMViewRotation3D.h"


@interface ViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet UIView *testView;
    IBOutlet MKMapView *testMapView;
    
    // Buttons
    IBOutlet UIButton *enable3D;
    IBOutlet UIButton *disable3D;
    IBOutlet UIButton *enableAutorotate;
    IBOutlet UIButton *disableAutorotate;
    IBOutlet UIButton *enableCompassRotation;
    IBOutlet UIButton *disableCompassRotation;
    IBOutlet UIButton *enableMap;
    IBOutlet UIButton *disableMap;
}

@property (nonatomic) SMViewRotation3D *smViewRotation;

@end
