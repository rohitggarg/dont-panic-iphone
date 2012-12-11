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
@synthesize delegate;
@synthesize city;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    controllers = [[NSMutableDictionary alloc] init];
    keys = [NSArray arrayWithObjects:@"Office Locations", @"Countries", @"Favorites", @"Admins", @"Hangouts", @"Routes", @"Transportation", nil];
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
    searchController.city = city;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" 
                                                            message:[NSString stringWithFormat:@"about to call %@", target]
                                                           delegate:nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
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
    city = nil;
    [[[self navigationItem] leftBarButtonItem]setTitle:@"Set Location"];
    controllers = [[NSMutableDictionary alloc] init];
    com_hitchhikers_dontpanic_LoginViewController *view;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        view = [[com_hitchhikers_dontpanic_LoginViewController alloc] initWithNibName:@"LoginView_iPhone" bundle:nil];
    } else {
        view = [[com_hitchhikers_dontpanic_LoginViewController alloc] initWithNibName:@"LoginView_iPad" bundle:nil];
    }
    view.delegate = delegate;
    view.mainController = self;
    [self presentModalViewController:view animated:true];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

@end
