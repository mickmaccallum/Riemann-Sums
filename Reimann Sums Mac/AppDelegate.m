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
    
    
    
    CGFloat final = [calculator areaUnderCurveOfFunction:function
                                             startingAtX:self.startingField.doubleValue
                                            andEndingAtX:self.endingField.doubleValue
                                             inDirection:ReimannSumDirectionLeft];
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
