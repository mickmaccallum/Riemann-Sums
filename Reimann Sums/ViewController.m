//
//  ViewController.m
//  Riemann Sums
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
    
    NSString *startingNumber = self.startingNumberField.placeholder;
    NSString *endingNumber = self.endingNumberField.placeholder;
    CGFloat number = self.numberOfRectanglesField.placeholder.integerValue;
    
    if (self.startingNumberField.text.length > 0) {
        if ([self inputIsValid:self.startingNumberField.text]) {
            startingNumber = self.startingNumberField.text;
        }else{
            [self validationFailedForField:@"\"From\""];
        }
    }
    
    
    if (self.endingNumberField.text.length > 0) {
        if ([self inputIsValid:self.endingNumberField.text]) {
            endingNumber = self.endingNumberField.text;
        }else{
            [self validationFailedForField:@"\"To\""];
        }
    }
    
    if (self.numberOfRectanglesField.text.length > 0) {
        if ([self inputIsValid:self.numberOfRectanglesField.text]) {
            number = [self.numberOfRectanglesField.text doubleValue];
        }else{
            [self validationFailedForField:@"\"Rectangles\""];
        }
    }
    
    SumType direction = SumTypeNone;
    
    if (self.sumSelectionSegment.selectedSegmentIndex == 0) {
        direction = SumTypeRiemannLeft;
    }else if (self.sumSelectionSegment.selectedSegmentIndex == 1) {
        direction = SumTypeRiemannMiddle;
    }else if (self.sumSelectionSegment.selectedSegmentIndex == 2) {
        direction = SumTypeRiemannRight;
    }else if (self.sumSelectionSegment.selectedSegmentIndex == 3) {
        direction = SumTypeRiemannTrapezoidal;
    }else if (self.sumSelectionSegment.selectedSegmentIndex == 4) {
        direction = SumTypeSimpsonsRule;
    }else{
        [self validationFailedForField:@"Direction Segment"];
        return;
    }
    

    CalculatorObject *calculator = [[CalculatorObject alloc] init];
    
    NSString *function = [calculator functionPreparedForMathParserFromString:((self.functionInputField.text.length > 0) ? self.functionInputField.text : self.functionInputField.placeholder)];

    [calculator areaUnderCurveOfFunction:function
                             startingAtX:startingNumber
                            andEndingAtX:endingNumber
                  withNumberOfRectangles:number
                             inDirection:direction
                       withProgressBlock:^(CGFloat progress) {
                           
                       } andCompletionBlock:^(CGFloat sum, NSError *error) {
                           if (!error) {
                               NSString *labelText = [calculator outputTextFromSum:sum];
                               [self.outputLabel setText:labelText];
                           }else{
                               [self.outputLabel setText:error.domain];
                           }                           
                       }];
}

- (BOOL)inputIsValid:(NSString *)input
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];

    return [formatter numberFromString:input] != nil;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
