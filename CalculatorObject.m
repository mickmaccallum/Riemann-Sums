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

- (double)areaUnderCurveOfFunction:(NSString *)function startingAtX:(double)xNot andEndingAtX:(double)xSubOne inDirection:(ReimannSumDirection)direction
{
    double deltaX = ((self.endingNumber - self.startingNumber) / self.number);
    
    __block double total = 0.0;
    
    switch (direction) {
        case ReimannSumDirectionNone: {
            
        }break;
         
        case ReimannSumDirectionLeft: {
            
            for (double k = self.startingNumber; k < self.endingNumber; k += deltaX) {
                
                NSDictionary *substitutions = @{var:@(k)};
                NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];
                
                
                total += fOfX.doubleValue;
                
                NSLog(@"Adding %f and new total is %f",fOfX.doubleValue,total);
            }

        }break;
         
        case ReimannSumDirectionRight: {
            
            for (double k = self.startingNumber + 1; k <= self.endingNumber; k += deltaX) {
                
                NSDictionary *substitutions = @{var:@(k)};
                NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];
                
                total += fOfX.doubleValue;
                
                NSLog(@"Adding %f and new total is %f",fOfX.doubleValue,total);

            }

        }break;
            
        default:
            break;
    }
    
    total *= deltaX;
    
    return total;
}

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function
{
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    return varsSwapped;
}

- (void)resetDefaultValues
{
    self.startingNumber = 0.0;
    self.endingNumber = 4.0;
    self.number = 4.0;
}

@end
