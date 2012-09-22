//
//  com_hitchhikers_SearchResultsController.m
//  dont-panic
//
//  Created by Rohit on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_hitchhikers_SearchResultsController.h"
#import <AddressBook/AddressBook.h>
NSMutableArray *results;
@implementation com_hitchhikers_SearchResultsController

@synthesize country;
@synthesize viewType;
@synthesize table;
@synthesize map;
@synthesize managedObjectContext;
@synthesize baseLocation;
@synthesize admin;
@synthesize text;

-(void)getResultsForQuery:(NSString *)query {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    results = [[NSMutableArray alloc]initWithCapacity:1];
    if([[self title] isEqual:@"Countries"]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country"
                                              inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (Country *info in fetchedObjects) {
            [results addObject:info];
        }
    }
    if([[self title] isEqual:@"Office Locations"]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Office"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        if(self.country != nil) {
            NSPredicate *filter = [NSPredicate predicateWithFormat:@"place.city.country == %@",country];
            [fetchRequest setPredicate:filter];
        }
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (Office *info in fetchedObjects) {
            [results addObject:[info place]];
        }
    }
    if([[self title] isEqual:@"TWers"]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (Country *info in fetchedObjects) {
            [results addObject:info];
        }
    }
    if([[self title] isEqual:@"Admins"]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Admin"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (Admin *info in fetchedObjects) {
            [results addObject:info];
        }
    }
    if([[self title] isEqual:@"Transportation"]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlaceType"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@",@"Transport"]];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (PlaceType *info in fetchedObjects) {
            for (Place *place in info.places) {
                [results addObject:place];
            }
        }
    }
    if([[self title] isEqual:@"Hangouts"] || [self title] == nil) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlaceType"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@",@"Hangout"]];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (PlaceType *info in fetchedObjects) {
            for (Place *place in info.places) {
                [results addObject:place];
            }
        }
    }
    if([[self title] isEqual:@"Routes"]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];

        NSPredicate *filter = [NSPredicate predicateWithFormat:@"office != NULL"];
        [fetchRequest setPredicate:filter];

        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (Place *info in fetchedObjects) {
            [results addObject:info];
        }
    }
    if(query != nil) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",query];
        [results filterUsingPredicate:filter];
    } 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *os = @"iPhone";
    self = [super initWithNibName:[NSString localizedStringWithFormat:@"%@View_%@", nibNameOrNil, os] bundle:nibBundleOrNil];
    self.viewType = nibNameOrNil;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getResultsForQuery:nil];
    [super viewWillAppear:animated];
    if([self.viewType isEqual:@"Map"]) {
        [self initMap:self.map];
    } else if([self.viewType isEqual:@"Detail"]) {
        [text loadHTMLString:[NSString stringWithFormat:@" <font color='#996633' face='sans-serif'><table border='0'><tr><td><h1>Name</h1></td><td><h1>: %@</h1></td></tr><tr><td><h2>Office</h2></td><td><h2>: %@</h2></td></tr><tr><td>Address</td><td>: %@,%@<br/>&nbsp;&nbsp;%@ %@</td></tr></table>Email : <a href='mailto:%@'>%@</a><br/>Phone : <a href='tel:%@'>%@</a></font>",admin.name, admin.office.place.name,admin.office.place.address1,admin.office.place.address2,admin.office.place.city.name, admin.office.place.city.country.name, admin.email, admin.email, admin.phoneNumber, admin.phoneNumber] baseURL:nil];
        self.baseLocation = admin.office.place;
        [self initMap:self.map];
    } else {
        [self.table reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.textLabel.text = [[results objectAtIndex:indexPath.row] name];
    cell.textLabel.textColor = [UIColor brownColor];
    return cell;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getResultsForQuery:[searchBar text]];
    if([self.viewType isEqual:@"Map"]) {
        [self initMap:self.map];
    } else {
        [self.table reloadData];
    }
}

-(void) initializeSubController:(com_hitchhikers_SearchResultsController *)controller obj:(NSObject*)obj {
    if([self.title isEqualToString:@"Countries"]) {
        controller.title=@"Office Locations";
        controller.country = obj;
    }
    if([controller.viewType isEqualToString:@"Map"]) {
        controller.baseLocation = obj;
    }
    if([controller.viewType isEqualToString:@"Detail"]) {
        controller.admin = obj;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [results objectAtIndex:indexPath.row];
    com_hitchhikers_SearchResultsController *searchController = [com_hitchhikers_SearchResultsController alloc];
    searchController.managedObjectContext = self.managedObjectContext;
    if([object isKindOfClass:[Place class]]) {
        searchController = [searchController initWithNibName:@"Map" bundle:nil];
    } else if([object isKindOfClass:[Admin class]]) {
        searchController = [searchController initWithNibName:@"Detail" bundle:nil];
    } else {
        searchController = [searchController initWithNibName:@"Search" bundle:nil];
    }
    [self initializeSubController:searchController obj:object];
    [self.navigationController pushViewController:searchController animated:true];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D location=userLocation.coordinate;
    
    if(self.baseLocation != nil) {
        CLLocationDegrees latitude = [[baseLocation latitude] doubleValue];
        CLLocationDegrees longitude = [[baseLocation longitude] doubleValue];
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(latitude, longitude);
        location = point;
    }
    mapView.showsUserLocation=TRUE;
    mapView.mapType=MKMapTypeHybrid;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=5;
    span.longitudeDelta=5;
    region.span=span;
    region.center=location;
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
}


- (void)initMap:(MKMapView *)mapView
{
    
    [mapView removeAnnotations:[mapView annotations]];
    if(self.baseLocation != nil) {
        CLLocationDegrees latitude = [[baseLocation latitude] doubleValue];
        NSMutableDictionary *completeAddress = [[NSMutableDictionary alloc] initWithCapacity:5];
        [completeAddress setValue:[NSString stringWithFormat:@"%@,",baseLocation.name] forKey:kABPersonAddressStreetKey];
        [completeAddress setValue:baseLocation.address1 forKey:@"address1"];
        [completeAddress setValue:baseLocation.address2 forKey:@"address2"];
        [completeAddress setValue:baseLocation.city.name forKey:@"city"];
        [completeAddress setValue:baseLocation.city.country.name forKey:kABPersonAddressCountryKey];
        CLLocationDegrees longitude = [[baseLocation longitude] doubleValue];
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(latitude, longitude);
        MKPlacemark *annotation = [[MKPlacemark alloc] initWithCoordinate:point addressDictionary:completeAddress];
        [mapView addAnnotation:annotation];
        mapView.showsUserLocation=TRUE;
        mapView.mapType=MKMapTypeHybrid;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=0.2;
        span.longitudeDelta=0.2;
        region.span=span;
        region.center=point;
        [mapView setRegion:region animated:TRUE];
        [mapView regionThatFits:region];
    }

    for(Place *result in results) {
        CLLocationDegrees latitude = [[result latitude] doubleValue];
        CLLocationDegrees longitude = [[result longitude] doubleValue];
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(latitude, longitude);
        MKPointAnnotation *annotation = [MKPointAnnotation alloc];
        [annotation setCoordinate:point];
        [annotation setTitle:[result name]];
        [annotation setSubtitle:[result desc]];
        [mapView addAnnotation:annotation];
    }
    

}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation
{
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"ReusedPin";
    pinView = (MKPinAnnotationView*)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    if ([annotation class] == MKPlacemark.class)
    {
        MKPlacemark *placeMark = (MKPlacemark *)annotation;
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,150,40)];
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
        [textView setText:[NSString stringWithFormat:@"%@\n%@,%@",[placeMark.addressDictionary objectForKey:@"address1"],[placeMark.addressDictionary objectForKey:@"address2"],[placeMark.addressDictionary objectForKey:@"city"]]];
        pinView.rightCalloutAccessoryView = textView;
        return pinView;
    }
    else {
        return [mV viewForAnnotation:annotation];
    }
}

@end
