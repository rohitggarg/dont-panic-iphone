//
//  Office.h
//  dont-panic
//
//  Created by Rohit on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Admin, Company, Place;

@interface Office : NSManagedObject

@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSSet *admins;
@end

@interface Office (CoreDataGeneratedAccessors)

- (void)addAdminsObject:(Admin *)value;
- (void)removeAdminsObject:(Admin *)value;
- (void)addAdmins:(NSSet *)values;
- (void)removeAdmins:(NSSet *)values;

@end
