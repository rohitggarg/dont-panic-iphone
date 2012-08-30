//
//  Company.h
//  dont-panic
//
//  Created by Rohit on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Admin, Office;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *admins;
@property (nonatomic, retain) NSSet *offices;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addAdminsObject:(Admin *)value;
- (void)removeAdminsObject:(Admin *)value;
- (void)addAdmins:(NSSet *)values;
- (void)removeAdmins:(NSSet *)values;

- (void)addOfficesObject:(Office *)value;
- (void)removeOfficesObject:(Office *)value;
- (void)addOffices:(NSSet *)values;
- (void)removeOffices:(NSSet *)values;

@end
