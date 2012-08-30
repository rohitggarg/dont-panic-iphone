//
//  Office.h
//  dont-panic
//
//  Created by Rohit on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, Place;

@interface Office : NSManagedObject

@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) Place *place;

@end
