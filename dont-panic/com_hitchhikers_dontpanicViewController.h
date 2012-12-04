//
//  com_hitchhikers_dontpanicViewController.h
//  dont-panic
//
//  Created by Rohit on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "com_hitchhikers_dontpanicAppDelegate.h"
#import "City.h"

@interface com_hitchhikers_dontpanicViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) com_hitchhikers_dontpanicAppDelegate *delegate;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocationManager *map;
@property (nonatomic,strong) City *city;
-(IBAction) panicButtonPushed:(id)sender;
-(IBAction) syncButtonPushed:(id)sender;
@end
