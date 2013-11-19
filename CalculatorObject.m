//
//  CalculatorObject.m
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "CalculatorObject.h"

__strong static CalculatorObject *sharedInstance = nil;

static NSString *var = @"x";

@implementation CalculatorObject



+ (CalculatorObject *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CalculatorObject alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self resetDefaultValues];
    }
    
    return self;
}

- (CGFloat)areaUnderCurveOfFunction:(NSString *)function startingAtX:(CGFloat)xNot andEndingAtX:(CGFloat)xSubOne inDirection:(ReimannSumDirection)direction
{
    CGFloat deltaX = ((self.endingNumber - self.startingNumber) / self.number);
    
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];
    
    __block CGFloat total = 0.0;
    
    
    
    if (direction == ReimannSumDirectionLeft) {
            // left sum
        for (CGFloat k = self.startingNumber; k < self.endingNumber; k += deltaX) {
            
            NSDictionary *substitutions = @{var: [NSNumber numberWithDouble:k]};
            NSNumber *fOfX = [varsSwapped numberByEvaluatingStringWithSubstitutions:substitutions];
            
            total += fOfX.doubleValue;
        }
    }else if (direction == ReimannSumDirectionRight) {
            // right sum
        for (NSInteger k = self.startingNumber + 1; k <= self.endingNumber; k += deltaX) {
            
            NSDictionary *substitutions = @{var: [NSNumber numberWithDouble:k]};
            NSNumber *fOfX = [varsSwapped numberByEvaluatingStringWithSubstitutions:substitutions];
            
            total += fOfX.doubleValue;
        }
    }
    
    total *= deltaX;
    
    return total;
}

- (void)resetDefaultValues
{
    self.startingNumber = 0.0;
    self.endingNumber = 4.0;
    self.number = 4.0;
}

@end
