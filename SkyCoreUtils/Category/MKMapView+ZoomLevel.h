//
//  MKMapView+ZoomLevel.h
//  leziyou-iphone
//
//  Created by wei ding on 11-8-16.
//  Copyright 2011年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView(ZoomLevel)
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end
