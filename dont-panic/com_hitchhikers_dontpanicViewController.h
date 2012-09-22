//
//  com_hitchhikers_dontpanicViewController.h
//  dont-panic
//
//  Created by Rohit on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface com_hitchhikers_dontpanicViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocationManager *map;

-(IBAction) panicButtonPushed:(id)sender;
-(IBAction) syncButtonPushed:(id)sender;
@end
