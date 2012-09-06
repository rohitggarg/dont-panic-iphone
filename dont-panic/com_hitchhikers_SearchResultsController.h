//
//  com_hitchhikers_SearchResultsController.h
//  dont-panic
//
//  Created by Rohit on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "Office.h"
#import "Place.h"
#import "PlaceType.h"
#import "Admin.h"
#import "City.h"
#import "Company.h"

@interface com_hitchhikers_SearchResultsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
