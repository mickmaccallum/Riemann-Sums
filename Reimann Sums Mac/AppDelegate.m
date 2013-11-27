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

    ReimannSumType direction = ReimannSumTypeNone;
    
    if (self.directionSegment.selectedSegment == 0) {
        direction = ReimannSumTypeLeft;
    }else if (self.directionSegment.selectedSegment == 1) {
        direction = ReimannSumTypeMiddle;
    }else if (self.directionSegment.selectedSegment == 2) {
        direction = ReimannSumTypeRight;
    }

	CGFloat start = [[self.startingField cell] placeholderString].doubleValue;
	CGFloat finish = [[self.endingField cell] placeholderString].doubleValue;
	CGFloat number = [[self.numberOfRectanglesField cell] placeholderString].doubleValue;

	if (self.startingField.stringValue.length != 0) {
		start = self.startingField.doubleValue;
	}

	if (self.endingField.stringValue.length != 0) {
		finish = self.endingField.doubleValue;
	}

	if (self.numberOfRectanglesField.stringValue.length != 0) {
		number = self.numberOfRectanglesField.integerValue;
	}

	NSString *fOfX = [[self.functionField cell] placeholderString];

	if (self.functionField.stringValue.length != 0) {
		fOfX = self.functionField.stringValue;
	}

	NSString *function = [calculator functionPreparedForMathParserFromString:fOfX];


    CGFloat final = [calculator areaUnderCurveOfFunction:function
                                             startingAtX:start
                                            andEndingAtX:finish
                                  withNumberOfRectangles:number
                                             inDirection:direction];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterScientificStyle];
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
