//
//  ViewController.m
//  SMViewRotation
//
//  Created by Seb on 28/10/12.
//  Copyright (c) 2012 S. MIZRAHI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize smViewRotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.smViewRotation = [[SMViewRotation3D alloc] init];
    self.smViewRotation.view = testView;
    
    [self applyButtonStyle:enable3D backgroundImage:@"greenButton.png"];
    [self applyButtonStyle:disable3D backgroundImage:@"orangeButton.png"];
    [self applyButtonStyle:enableAutorotate backgroundImage:@"blackButton.png"];
    [self applyButtonStyle:disableAutorotate backgroundImage:@"blackButton.png"];
    [self applyButtonStyle:enableCompassRotation backgroundImage:@"blackButton.png"];
    [self applyButtonStyle:disableCompassRotation backgroundImage:@"blackButton.png"];
    [self applyButtonStyle:enableMap backgroundImage:@"blackButton.png"];
    [self applyButtonStyle:disableMap backgroundImage:@"blackButton.png"];
    
    testMapView.showsUserLocation = YES;
    testMapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Design

// From http://nathanbarry.com/designing-buttons-ios5/
-(void) applyButtonStyle:(UIButton *) button backgroundImage:(NSString *) imageString {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *buttonImage = [[UIImage imageNamed: imageString]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:[imageString stringByReplacingOccurrencesOfString:@".png" withString:@"Highlight.png"]]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}

#pragma mark - Actions

-(IBAction)startTransformation:(id)sender {
    [self.smViewRotation initWithTransformation];
}

-(IBAction)stopTransformation:(id)sender {
    [self.smViewRotation clearTransformation];
}

-(IBAction)startAutorotate:(id)sender {
    [self.smViewRotation startAutorotate:10];
}

-(IBAction)stopAutorotate:(id)sender {
    [self.smViewRotation stopAutorotate];
}

-(IBAction)startCompassRotate:(id)sender {
    [self.smViewRotation startCompassRotate];
}

-(IBAction)stopCompassRotate:(id)sender {
    [self.smViewRotation stopCompassRotate];
}

-(IBAction)showMap:(id)sender {
    [testMapView setHidden: NO];
}

-(IBAction)hideMap:(id)sender {
    [testMapView setHidden: YES];
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.001;
    mapRegion.span.longitudeDelta = 0.001;
    
    [mapView setRegion:mapRegion animated: YES];
}

@end
