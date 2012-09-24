//
//  com_hitchhikers_dontpanicViewController.m
//  dont-panic
//
//  Created by Rohit on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_hitchhikers_dontpanicViewController.h"
#import "com_hitchhikers_SearchResultsController.h"
#import "SBJson.h"

NSArray *keys;
NSArray *objects;
NSMutableDictionary *controllers;
@implementation com_hitchhikers_dontpanicViewController

@synthesize navigationController;
@synthesize managedObjectContext;
@synthesize currentLocation;
@synthesize map;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    controllers = [[NSMutableDictionary alloc] init];
    keys = [NSArray arrayWithObjects:@"Office Locations", @"Countries", @"TWers", @"Admins", @"Hangouts", @"Routes", @"Transportation", nil];
    objects = [NSArray arrayWithObjects:@"Search", @"Search", @"Search", @"Search", @"Map", @"Map", @"Search", nil];
    map = [[CLLocationManager alloc] init];
    map.delegate = self;
    [map startUpdatingLocation];
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [keys count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [objects objectAtIndex:indexPath.row];
    com_hitchhikers_SearchResultsController *searchController = [controllers objectForKey:key];
    if(searchController == nil) {
        searchController = [com_hitchhikers_SearchResultsController alloc];
        searchController.managedObjectContext = self.managedObjectContext;
        searchController = [searchController initWithNibName:key bundle:nil];
        [controllers setValue:searchController forKey:key];
    }
    searchController.title = [keys objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:searchController animated:true];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [keys objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor brownColor];
        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cell.textLabel.text]];
    }
    return cell;

}

-(IBAction) panicButtonPushed:(id)sender
{
    if(currentLocation == nil)
        NSLog(@"current location not known");
    else {
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Office"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        double shortestDistance = 99999999999.0;
        Office *closestOffice = nil;
        for (Office *info in fetchedObjects) {
            CLLocation *location = [[CLLocation alloc]initWithLatitude:info.place.latitude.doubleValue longitude:info.place.longitude.doubleValue];
            double distance = [currentLocation distanceFromLocation:location];
            if(distance < shortestDistance && [info.admins count] > 0) {
                shortestDistance = distance;
                closestOffice = info;
            }
        }
        if(closestOffice != nil) {
            NSString *osVersion = [[UIDevice currentDevice] systemVersion];
            NSString *target=[NSString stringWithFormat:@"tel:%@",
            [((Admin *)[closestOffice.admins anyObject]).phoneNumber stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceCharacterSet]]];
            if ([osVersion floatValue] >= 3.1) { 
                UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame]; 
                // Assume we are in a view controller and have access to self.view 
                webview.hidden = TRUE;
                [self.view addSubview:webview]; 
                [webview loadHTMLString:[NSString stringWithFormat:@"<a href='%@' id='no'>no</a><script>window.location = document.getElementById('no').href;</script>",target] baseURL:nil]; 
            } else { 
                NSURL *url = [NSURL URLWithString:
                              target ];
                // On 3.0 and below, dial as usual 
                [[UIApplication sharedApplication] openURL: url];
            }
        }
    }
}

-(IBAction) syncButtonPushed:(id)sender
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dont-panic.herokuapp.com/data.json"]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    if (err != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[NSString stringWithFormat:@"%@", [err localizedDescription]]
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
        [alert show];
        
    } else {
        NSDictionary *values = [data JSONValue];
        //place_types
        //countries
        //cities
        //companies
        //administrators
        //offices - no place type
        //places
        PlaceType *officeType = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceType" inManagedObjectContext:managedObjectContext];
        officeType.name = @"Office";
        NSMutableDictionary *companyDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        for(NSDictionary *companies in [values valueForKey:@"companies"]) {
            Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:managedObjectContext];
            company.name = [companies valueForKey:@"name"];
            [companyDict setValue:company forKey:[companies valueForKey:@"id"]];
        }
        NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        for(NSDictionary *countries in [values valueForKey:@"countries"]) {
            Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:managedObjectContext];
            country.name = [countries valueForKey:@"name"];
            for(NSDictionary *cities in [values valueForKey:@"cities"]) {
                if([[cities valueForKey:@"country_id"] isEqual:[countries valueForKey:@"id"]]) {
                    City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:managedObjectContext];
                    city.name = [cities valueForKey:@"name"];
                    city.country = country;
                    [cityDict setValue:city forKey:[cities valueForKey:@"id"]];
                    for(NSDictionary *offices in [values valueForKey:@"offices"]){
                        if([[offices valueForKey:@"city_id"] isEqual:[cities valueForKey:@"id"]]) {
                            Office *office = [NSEntityDescription insertNewObjectForEntityForName:@"Office" inManagedObjectContext:managedObjectContext];
                            office.company = [companyDict valueForKey:[offices valueForKey:@"company_id"]];
                            office.place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:managedObjectContext];
                            office.place.latitude = [[NSDecimalNumber alloc] initWithString:[offices valueForKey:@"latitude"]];
                            office.place.longitude = [[NSDecimalNumber alloc] initWithString:[offices valueForKey:@"longitude"]];
                            office.place.name = [offices valueForKey:@"name"];
                            office.place.address1 = [offices valueForKey:@"address1"];
                            office.place.address2 = [offices valueForKey:@"address2"];
                            office.place.contactNo = [offices valueForKey:@"contactNo"];
                            office.place.desc = [offices valueForKey:@"desc"];
                            office.place.type = officeType;
                            for(NSDictionary *admins in [values valueForKey:@"administrators"]) {
                                if([[admins valueForKey:@"office_id"] isEqual:[offices valueForKey:@"id"]]) {
                                    Admin *admin = [NSEntityDescription insertNewObjectForEntityForName:@"Admin" inManagedObjectContext:managedObjectContext];
                                    admin.name = [admins valueForKey:@"name"];
                                    admin.email = [admins valueForKey:@"email"];
                                    admin.phoneNumber = [admins valueForKey:@"phoneNumber"];
                                    admin.office = office;
                                }
                            }
                        }
                    }
                }
            }
        }
        for(NSDictionary *placeTypes in [values valueForKey:@"place_types"]) {
            PlaceType *placeType = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceType" inManagedObjectContext:managedObjectContext];
            placeType.name = [placeTypes valueForKey:@"name"];
            for(NSDictionary *places in [values valueForKey:@"places"]) {
                if([[places valueForKey:@"place_type"] isEqual:[placeType valueForKey:@"id"]]) {
                    Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:managedObjectContext];
                    place.latitude = [[NSDecimalNumber alloc] initWithString:[places valueForKey:@"latitude"]];
                    place.longitude = [[NSDecimalNumber alloc] initWithString:[places valueForKey:@"longitude"]];
                    place.name = [places valueForKey:@"name"];
                    place.address1 = [places valueForKey:@"address1"];
                    place.address2 = [places valueForKey:@"address2"];
                    place.contactNo = [places valueForKey:@"contactNo"];
                    place.desc = [places valueForKey:@"desc"];
                    place.type = placeType;
                    place.city = [cityDict valueForKey:[places valueForKey:@"city_id"]];
                }
            }
        }
        NSError *error;
        if(![managedObjectContext save:&error]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:[NSString stringWithFormat:@"Couldn't sync because %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" 
														message:@"Sync successful!"
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
            [alert show];
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

@end
