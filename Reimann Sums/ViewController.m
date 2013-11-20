//
//  ViewController.m
//  Reimann Sums
//
//  Created by Mick on 11/12/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorObject.h"

@interface ViewController ()



@property (weak , nonatomic) IBOutlet UITextField *functionInputField;
@property (weak , nonatomic) IBOutlet UITextField *startingNumberField;
@property (weak , nonatomic) IBOutlet UITextField *endingNumberField;
@property (weak , nonatomic) IBOutlet UITextField *numberOfRectanglesField;


@property (weak , nonatomic) IBOutlet UISegmentedControl *sumSelectionSegment;

@property (weak , nonatomic) IBOutlet UILabel *outputLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.functionInputField setDelegate:self];

    [self.functionInputField becomeFirstResponder];
}



- (IBAction)startApproximation:(UIButton *)sender
{
    [self.view endEditing:YES];

//    [self checkValidityOfFields];
    
    ReimannSumDirection direction = ReimannSumDirectionNone;
    
    if (self.sumSelectionSegment.selectedSegmentIndex == 0) {
        direction = ReimannSumDirectionLeft;
    }else if (self.sumSelectionSegment.selectedSegmentIndex == 1) {
        direction = ReimannSumDirectionRight;
    }

    CalculatorObject *calculator = [CalculatorObject sharedInstance];
    
    NSString *function = [calculator functionPreparedForMathParserFromString:self.functionInputField.text];
    
    CGFloat total = [[CalculatorObject sharedInstance] areaUnderCurveOfFunction:function
                                                                    startingAtX:self.startingNumberField.text.integerValue
                                                                   andEndingAtX:self.endingNumberField.text.integerValue
                                                                    inDirection:direction];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];
    
    [self.outputLabel setText:text];

}

- (BOOL)inputIsValid:(NSString *)input
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];

    return [formatter numberFromString:input] != nil;
}

- (void)checkValidityOfFields
{
    if (self.startingNumberField.text.length > 0) {
        if ([self inputIsValid:self.startingNumberField.text]) {
            self.startingNumber = [self.startingNumberField.text doubleValue];
        }else{
            [self validationFailedForField:@"\"From\""];
        }
    }

    if (self.endingNumberField.text.length > 0) {
        if ([self inputIsValid:self.endingNumberField.text]) {
            self.endingNumber = [self.endingNumberField.text doubleValue];
        }else{
            [self validationFailedForField:@"\"To\""];
        }
    }

    if (self.numberOfRectanglesField.text.length > 0) {
        if ([self inputIsValid:self.numberOfRectanglesField.text]) {
            self.number = [self.numberOfRectanglesField.text doubleValue];
        }else{
            [self validationFailedForField:@"\"Rectangles\""];
        }
    }
}

- (void)validationFailedForField:(NSString *)fieldName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@ field contains non-numerical characters",fieldName]
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)sumSegmentDidChangeValue:(UISegmentedControl *)sender
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
