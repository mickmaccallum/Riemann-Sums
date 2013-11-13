//
//  ViewController.h
//  Reimann Sums
//
//  Created by Mick on 11/12/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController < UITextFieldDelegate >

@property (assign , nonatomic) CGFloat startingNumber;
@property (assign , nonatomic) CGFloat endingNumber;
@property (assign , nonatomic) CGFloat number;



@property (weak , nonatomic) IBOutlet UITextField *functionInputField;
@property (weak , nonatomic) IBOutlet UITextField *startingNumberField;
@property (weak , nonatomic) IBOutlet UITextField *endingNumberField;
@property (weak , nonatomic) IBOutlet UITextField *numberOfRectanglesField;


@property (weak , nonatomic) IBOutlet UISegmentedControl *sumSelectionSegment;

@property (weak , nonatomic) IBOutlet UILabel *outputLabel;

@end
