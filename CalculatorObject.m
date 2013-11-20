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


- (double)areaUnderCurveOfFunction:(NSString *)function
                       startingAtX:(double)xNot
                      andEndingAtX:(double)xSubOne
            withNumberOfRectangles:(double)rectangles
                       inDirection:(ReimannSumDirection)direction
{
    double deltaX = ((xSubOne - xNot) / rectangles);
    
    NSLog(@"Delta: %f",deltaX);
    
    __block double total = 0.0;
    
    switch (direction) {
        case ReimannSumDirectionNone: {
            
        }break;
         
        case ReimannSumDirectionLeft: {
            
            for (double k = xNot; k < xSubOne - deltaX; k += deltaX) {
                
                NSDictionary *substitutions = @{var:@(k)};
                NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];
                
                double add = fOfX.doubleValue + total;
                
                total = add;
                
//                total += fOfX.doubleValue;
                
                NSLog(@"Adding %f and new total is %f",fOfX.doubleValue,total);
            }

        }break;
         
        case ReimannSumDirectionRight: {
            
            for (double k = xNot + 1; k <= xSubOne; k += deltaX) {
                
                NSDictionary *substitutions = @{var:@(k)};
                NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];
                
                total += fOfX.doubleValue;
                
                NSLog(@"Adding %f and new total is %f",fOfX.doubleValue,total);

            }

        }break;
            
        default:
            break;
    }
    
    double final = total * deltaX;
    
    return final;
}

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function
{
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    return varsSwapped;
}


@end
