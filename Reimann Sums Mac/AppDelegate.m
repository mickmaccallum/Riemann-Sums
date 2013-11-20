//
//  AppDelegate.m
//  Reimann Sums Mac
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "AppDelegate.h"
#import "CalculatorObject.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}


- (IBAction)startApproximations:(NSButton *)sender
{
    CalculatorObject *calculator = [CalculatorObject sharedInstance];
    
    NSString *function = [calculator functionPreparedForMathParserFromString:self.functionField.stringValue];
    NSLog(@"%@",function);
    
    ReimannSumDirection direction = ReimannSumDirectionNone;
    
    if (self.directionSegment.selectedSegment == 0) {
        direction = ReimannSumDirectionLeft;
    }else if (self.directionSegment.selectedSegment == 1) {
        direction = ReimannSumDirectionRight;
    }
    
    CGFloat final = [calculator areaUnderCurveOfFunction:function
                                             startingAtX:self.startingField.doubleValue
                                            andEndingAtX:self.endingField.doubleValue
                                  withNumberOfRectangles:self.numberOfRectanglesField.doubleValue
                                             inDirection:direction];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *text = [formatter stringFromNumber:@(final)];

    
    [self.resultsField setStringValue:text];
    
    
}


- (IBAction)resetTextFields:(NSButton *)sender
{
    NSView *view = self.window.contentView;
    
    for (NSTextField *subview in view.subviews) {
        if (subview.tag == 5) {
            NSTextField *field = (NSTextField *)subview;
            if ([field respondsToSelector:@selector(setStringValue:)]) {
                [field setStringValue:@""];
            }
        }
    }
}



@end
