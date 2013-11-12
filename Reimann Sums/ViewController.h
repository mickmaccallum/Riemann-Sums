//
//  ViewController.h
//  Reimann Sums
//
//  Created by Mick on 11/12/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (assign , nonatomic) NSInteger startingInteger;
@property (assign , nonatomic) NSInteger endingInteger;
@property (assign , nonatomic) CGFloat deltaX;
@property (assign , nonatomic) NSInteger number;





@property (weak , nonatomic) IBOutlet UITextField *functionInputField;
@property (weak , nonatomic) IBOutlet UILabel *outputLabel;

@end
