//
//  SetLocationViewController.h
//  dont-panic
//
//  Created by Rohit Garg on 03/12/12.
//
//

#import <UIKit/UIKit.h>
#import "com_hitchhikers_dontpanicViewController.h"

@interface com_hitchhikers_dontpanic_SetLocationViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain) NSArray *data;
- (IBAction)cancelled:(id)sender;
- (IBAction)cleared:(id)sender;
@property (nonatomic,retain) com_hitchhikers_dontpanicViewController *controller;
@end
