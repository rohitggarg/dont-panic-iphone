//
//  com_hitchhikers_dontpanic_LoginViewController.h
//  dont-panic
//
//  Created by Rohit Garg on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "com_hitchhikers_dontpanicAppDelegate.h"
#import "com_hitchhikers_dontpanicViewController.h"
#import "SBJson.h"

@interface com_hitchhikers_dontpanic_LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)skipPressed:(id)sender;
- (IBAction)goPressed:(id)sender;

- (IBAction)syncStarted:(id)sender;
@property (strong, nonatomic) com_hitchhikers_dontpanicAppDelegate *delegate;
@property (strong, nonatomic) com_hitchhikers_dontpanicViewController *mainController;
@end
