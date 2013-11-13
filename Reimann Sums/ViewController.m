//
//  ViewController.m
//  Reimann Sums
//
//  Created by Mick on 11/12/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "ViewController.h"
#import "DDMathParser.h"

static NSString *var = @"x";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.functionInputField setDelegate:self];

    self.startingNumber = 0.0;
    self.endingNumber = 4.0;
    self.number = 4.0;

    [self.functionInputField becomeFirstResponder];
}



- (IBAction)startApproximation:(UIButton *)sender
{
    [self.view endEditing:YES];

    [self checkValidityOfFields];

    NSLog(@"Starting: %f",self.startingNumber);
    NSLog(@"Ending: %f",self.endingNumber);
    NSLog(@"Rectangles: %f",self.number);

    CGFloat deltaX = ((self.endingNumber - self.startingNumber) / self.number);
    NSLog(@"DeltaX: %f",deltaX);

    NSString *function = self.functionInputField.text;
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    CGFloat total = 0.0;

    if (self.sumSelectionSegment.selectedSegmentIndex == 0) {
        // left sum
        for (CGFloat k = self.startingNumber; k < self.endingNumber; k += deltaX) {

            NSDictionary *substitutions = @{var: [NSNumber numberWithDouble:k]};
            NSNumber *fOfX = [varsSwapped numberByEvaluatingStringWithSubstitutions:substitutions];

            NSLog(@"Adding: %f",fOfX.doubleValue);
            total += fOfX.doubleValue;
        }
    }else if (self.sumSelectionSegment.selectedSegmentIndex == 1) {
        // right sum
        for (NSInteger k = self.startingNumber + 1; k <= self.endingNumber; k += deltaX) {

            NSDictionary *substitutions = @{var: [NSNumber numberWithDouble:k]};
            NSNumber *fOfX = [varsSwapped numberByEvaluatingStringWithSubstitutions:substitutions];

            total += fOfX.doubleValue;
        }
    }

    total *= deltaX;

    [self.outputLabel setText:[NSString stringWithFormat:@"%.4f",total]];
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
    [self.outputLabel setText:nil];
    [self startApproximation:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
