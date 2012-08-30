//
//  Admin.h
//  dont-panic
//
//  Created by Rohit on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Admin : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) Company *company;

@end
