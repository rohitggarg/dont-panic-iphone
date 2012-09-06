//
//  Company.h
//  dont-panic
//
//  Created by Rohit on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Office;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *offices;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addOfficesObject:(Office *)value;
- (void)removeOfficesObject:(Office *)value;
- (void)addOffices:(NSSet *)values;
- (void)removeOffices:(NSSet *)values;

@end
