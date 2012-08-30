//
//  com_hitchhikers_SearchResultsController.h
//  dont-panic
//
//  Created by Rohit on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
@interface com_hitchhikers_SearchResultsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
