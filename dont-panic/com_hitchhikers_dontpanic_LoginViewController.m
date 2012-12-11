//
//  com_hitchhikers_dontpanic_LoginViewController.m
//  dont-panic
//
//  Created by Rohit Garg on 11/12/12.
//
//

#import "com_hitchhikers_dontpanic_LoginViewController.h"

@interface com_hitchhikers_dontpanic_LoginViewController ()

@end

@implementation com_hitchhikers_dontpanic_LoginViewController

@synthesize delegate;
@synthesize mainController;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshDatabase:(NSString *) username withPassword:(NSString *)password
{
    NSString *url = @"http://dont-panic.herokuapp.com/data.json";
 
    UIAlertView *mainAlert = [[UIAlertView alloc] initWithTitle:@"Info"
                                           message:[NSString stringWithFormat:@"about to send request"]
                                          delegate:nil
                                 cancelButtonTitle: nil
                                 otherButtonTitles: nil];
    [mainAlert show];
    if(username != nil) {
        url = [url stringByAppendingFormat:@"?username=%@&password=%@",username,password];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    [mainAlert dismissWithClickedButtonIndex:-1 animated:false];
    if (err != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[NSString stringWithFormat:@"%@", [err localizedDescription]]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
        [alert show];
        
    } else {
        NSDictionary *values = [data JSONValue];
        [delegate backupCurrentDB];
        [delegate syncToDb:[delegate managedObjectContext] values:values];
        NSError *error;
        if(![[delegate managedObjectContext] save:&error]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Couldn't sync because %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [delegate revertDB];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:@"Sync successful!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [delegate makeCurrentDB:[delegate managedObjectContext]];
        }
        mainController.managedObjectContext = [delegate managedObjectContext];
    }
    [self dismissModalViewControllerAnimated:true];
}

- (void)viewDidUnload {
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}
- (IBAction)skipPressed:(id)sender {
    [self refreshDatabase:nil withPassword:nil];
}

- (IBAction)goPressed:(id)sender {
    [self refreshDatabase:[self.username text] withPassword:[self.password text]];
}

- (IBAction)syncStarted:(id)sender {

    
}
@end
