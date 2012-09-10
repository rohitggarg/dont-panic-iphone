//
//  com_hitchhikers_SearchResultsController.m
//  dont-panic
//
//  Created by Rohit on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_hitchhikers_SearchResultsController.h"
NSString *viewType;
NSMutableArray *results;
@implementation com_hitchhikers_SearchResultsController

@synthesize table;
@synthesize map;
@synthesize managedObjectContext;

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
    if([[self title] isEqual:@"Hangouts"]) {
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
    if(query != nil) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",query];
        [results filterUsingPredicate:filter];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *os = @"iPhone";
    self = [super initWithNibName:[NSString localizedStringWithFormat:@"%@View_%@", nibNameOrNil, os] bundle:nibBundleOrNil];
    viewType = nibNameOrNil;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getResultsForQuery:nil];
    [super viewWillAppear:animated];
    if([viewType isEqual:@"Map"]) {
        map.showsUserLocation=TRUE;
        map.mapType=MKMapTypeHybrid;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=5;
        span.longitudeDelta=5;
        
        CLLocationCoordinate2D location=self.map.userLocation.coordinate;
        
        region.span=span;
        region.center=location;
        [map setRegion:region animated:TRUE];
        [map regionThatFits:region];
        [self mapViewWillStartLoadingMap:self.map];
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
    if([viewType isEqual:@"Map"]) {
        [self mapViewWillStartLoadingMap:self.map];
    } else {
        [self.table reloadData];
    }
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

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    [mapView removeAnnotations:[mapView annotations]];
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

@end
