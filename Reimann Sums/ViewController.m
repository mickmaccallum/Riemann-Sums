//
//  ViewController.m
//  Reimann Sums
//
//  Created by Mick on 11/12/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "ViewController.h"

static NSString *var = @"x";

@interface ViewController ()

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

    CGFloat deltaX = ((self.endingNumber - self.startingNumber) / self.number);

    NSString *function = self.functionInputField.text;
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    __block CGFloat total = 0.0;

    if (self.number > 10) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"Working"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{

        if (self.sumSelectionSegment.selectedSegmentIndex == 0) {
            // left sum
            for (CGFloat k = self.startingNumber; k < self.endingNumber; k += deltaX) {

                NSDictionary *substitutions = @{var: [NSNumber numberWithDouble:k]};
                NSNumber *fOfX = [varsSwapped numberByEvaluatingStringWithSubstitutions:substitutions];

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

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([MBProgressHUD HUDForView:self.view]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }

            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];

            [self.outputLabel setText:text];
        });
    });
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
