//
//  com_hitchhikers_dontpanicAppDelegate.h
//  dont-panic
//
//  Created by Rohit on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class com_hitchhikers_dontpanicViewController;

@interface com_hitchhikers_dontpanicAppDelegate : UIResponder <UIApplicationDelegate> 
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)backupCurrentDB;
- (void)revertDB;
- (void)makeCurrentDB:(NSManagedObjectContext *)context;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)syncToDb:(NSManagedObjectContext *)context values:(NSDictionary *)values;

@end
