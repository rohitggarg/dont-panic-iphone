//
//  SetLocationViewController.m
//  dont-panic
//
//  Created by Rohit Garg on 03/12/12.
//
//

#import "com_hitchhikers_dontpanic_SetLocationViewController.h"
#import "City.h"
#import "com_hitchhikers_dontpanicViewController.h"
@interface com_hitchhikers_dontpanic_SetLocationViewController ()

@end

@implementation com_hitchhikers_dontpanic_SetLocationViewController
@synthesize data;
@synthesize controller;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[data objectAtIndex:(row)] name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    controller.city = [data objectAtIndex:row];
    [[[controller navigationItem] leftBarButtonItem] setTitle:[[data objectAtIndex:row] name]]; 
    [self dismissModalViewControllerAnimated:true];
}

- (IBAction)cancelled:(id)sender {
    [self dismissModalViewControllerAnimated:true];
}

- (IBAction)cleared:(id)sender
{
    controller.city = nil;
    [[[controller navigationItem] leftBarButtonItem] setTitle:@"Set Location"];
    [self dismissModalViewControllerAnimated:true];
}
@end
