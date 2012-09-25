//
//  com_hitchhikers_dontpanicAppDelegate.m
//  dont-panic
//
//  Created by Rohit on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_hitchhikers_dontpanicAppDelegate.h"

#import "com_hitchhikers_dontpanicViewController.h"
#import "Place.h"
#import "Company.h"
#import "Office.h"
#import "PlaceType.h"
#import "Country.h"
#import "City.h"
#import "Admin.h"
@implementation com_hitchhikers_dontpanicAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)syncToDb:(NSManagedObjectContext *)context values:(NSDictionary *)values {
    PlaceType *officeType = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceType" inManagedObjectContext:context];
    officeType.name = @"Office";
    NSMutableDictionary *companyDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    for(NSDictionary *companies in [values valueForKey:@"companies"]) {
        Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:context];
        company.name = [companies valueForKey:@"name"];
        [companyDict setValue:company forKey:[NSString stringWithFormat:@"%d",[companies valueForKey:@"id"]]];
    }
    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    for(NSDictionary *countries in [values valueForKey:@"countries"]) {
        Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:context];
        country.name = [countries valueForKey:@"name"];
        for(NSDictionary *cities in [values valueForKey:@"cities"]) {
            if([[cities valueForKey:@"country_id"] isEqual:[countries valueForKey:@"id"]]) {
                City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
                city.name = [cities valueForKey:@"name"];
                city.country = country;
                [cityDict setValue:city forKey:[NSString stringWithFormat:@"%d",[cities valueForKey:@"id"]]];
                for(NSDictionary *offices in [values valueForKey:@"offices"]){
                    if([[offices valueForKey:@"city_id"] isEqual:[cities valueForKey:@"id"]]) {
                        Office *office = [NSEntityDescription insertNewObjectForEntityForName:@"Office" inManagedObjectContext:context];
                        office.company = [companyDict valueForKey:[NSString stringWithFormat:@"%d",[offices valueForKey:@"company_id"]]];
                        office.place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
                        if([offices valueForKey:@"latitude"] != NSNull.null)
                            office.place.latitude = [offices valueForKey:@"latitude"];
                        if([offices valueForKey:@"longitude"] != NSNull.null)
                            office.place.longitude = [offices valueForKey:@"longitude"];
                        office.place.name = [offices valueForKey:@"name"];
                        office.place.address = [offices valueForKey:@"address"];
                        office.place.contactNo = [offices valueForKey:@"phone_numbers"];
                        office.place.desc = [offices valueForKey:@"email"];
                        office.place.type = officeType;
                        office.place.city = [cityDict valueForKey:[NSString stringWithFormat:@"%d",[offices valueForKey:@"city_id"]]];
                        for(NSDictionary *admins in [values valueForKey:@"administrators"]) {
                            if([[admins valueForKey:@"office_id"] isEqual:[offices valueForKey:@"id"]]) {
                                Admin *admin = [NSEntityDescription insertNewObjectForEntityForName:@"Admin" inManagedObjectContext:context];
                                admin.name = [admins valueForKey:@"name"];
                                admin.email = [admins valueForKey:@"email"];
                                admin.phoneNumber = [admins valueForKey:@"phone_numbers"];
                                admin.office = office;
                            }
                        }
                    }
                }
            }
        }
    }
    for(NSDictionary *placeTypes in [values valueForKey:@"place_types"]) {
        PlaceType *placeType = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceType" inManagedObjectContext:context];
        placeType.name = [placeTypes valueForKey:@"name"];
        for(NSDictionary *places in [values valueForKey:@"places"]) {
            if([[places valueForKey:@"place_type_id"] isEqual:[placeTypes valueForKey:@"id"]]) {
                Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
                if([places valueForKey:@"latitude"] != NSNull.null)
                    place.latitude = [places valueForKey:@"latitude"];
                if([places valueForKey:@"longitude"] != NSNull.null)
                    place.longitude = [places valueForKey:@"longitude"];
                place.name = [places valueForKey:@"name"];
                place.address = [places valueForKey:@"address"];
                place.contactNo = [places valueForKey:@"phone_numbers"];
                place.desc = [places valueForKey:@"description"];
                place.type = placeType;
                place.city = [cityDict valueForKey:[NSString stringWithFormat:@"%d",[places valueForKey:@"city_id"]]];
            }
        }
    }
}

- (void)backupCurrentDB {
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalStorage_1.sqlite"];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
}
- (void)revertDB {
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalStorage.sqlite"];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
}
- (void)makeCurrentDB:(NSManagedObjectContext *)context {
    NSError *error;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalStorage.sqlite"];
    NSURL *storeURL1 = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalStorage_1.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    [[NSFileManager defaultManager] moveItemAtURL:storeURL1 toURL:storeURL error:&error];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self managedObjectContext];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    com_hitchhikers_dontpanicViewController *view;
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        view = [[com_hitchhikers_dontpanicViewController alloc] initWithNibName:@"com_hitchhikers_dontpanicViewController_iPhone" bundle:nil];
    } else {
        view = [[com_hitchhikers_dontpanicViewController alloc] initWithNibName:@"com_hitchhikers_dontpanicViewController_iPad" bundle:nil];
    }
    view.managedObjectContext = _managedObjectContext;
    view.delegate = self;
    self.viewController = [[UINavigationController alloc] initWithRootViewController:view];
    view.navigationController = self.viewController;
    view.title = @"Please select...";
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LocalStorage" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalStorage.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
