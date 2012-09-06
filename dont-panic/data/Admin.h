//
//  Admin.h
//  dont-panic
//
//  Created by Rohit on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Office;

@interface Admin : NSManagedObject

@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Office *office;

@end
