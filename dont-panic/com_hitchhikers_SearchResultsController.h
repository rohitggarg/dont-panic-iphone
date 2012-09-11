//
//  com_hitchhikers_SearchResultsController.h
//  dont-panic
//
//  Created by Rohit on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Country.h"
#import "Office.h"
#import "Place.h"
#import "PlaceType.h"
#import "Admin.h"
#import "City.h"
#import "Company.h"

@interface com_hitchhikers_SearchResultsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate> {
}
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) IBOutlet MKMapView *map;
@property (nonatomic, strong) NSString * viewType;
@property (nonatomic, strong) Country *country;
@property (nonatomic, strong) Place *baseLocation;
@end
