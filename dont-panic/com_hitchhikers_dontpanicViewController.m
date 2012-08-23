//
//  com_hitchhikers_dontpanicViewController.m
//  dont-panic
//
//  Created by Rohit on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_hitchhikers_dontpanicViewController.h"
#import "com_hitchhikers_SearchResultsController.h"

NSArray *keys;
NSArray *objects;
@implementation com_hitchhikers_dontpanicViewController
@synthesize navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    keys = [NSArray arrayWithObjects:@"Office Locations", @"Countries", @"TWers", @"Admins", @"Hangouts", @"Routes", @"Transportation", nil];
    objects = [NSArray arrayWithObjects:@"Search", @"Search", @"Search", @"Search", @"Map", @"Map", @"Search", nil];
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
    com_hitchhikers_SearchResultsController *searchController = [[com_hitchhikers_SearchResultsController alloc] initWithNibName:[objects objectAtIndex:indexPath.row] bundle:nil];
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

@end
