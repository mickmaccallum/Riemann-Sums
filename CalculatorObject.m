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


- (CGFloat)areaUnderCurveOfFunction:(NSString *)function
                       startingAtX:(CGFloat)a
                      andEndingAtX:(CGFloat)b
            withNumberOfRectangles:(CGFloat)rectangles
                       inDirection:(ReimannSumDirection)direction
{
    CGFloat deltaX = ((b - a) / rectangles);
	
    CGFloat sum = 0.0;
    
    switch (direction) {
        case ReimannSumDirectionNone: {
            
        }break;
         
        case ReimannSumDirectionLeft: {
            
            for (CGFloat i = 0; i < rectangles; i ++) {
                
                @autoreleasepool {
                
                    CGFloat x = a + (i * deltaX);
                    
                    NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)}];
                    
                    sum += evalAtX.doubleValue;
                }
                
            }
            
            sum *= deltaX;
            

        }break;
         
        case ReimannSumDirectionRight: {
            
            for (CGFloat i = 1; i <= rectangles; i ++) {
                CGFloat x = a + (i * deltaX);
                
                NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)}];
                
                sum += evalAtX.doubleValue;
            }

        }break;

        default:
            break;
    }
    
	sum *= deltaX;

    return sum;
}

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function
{
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    return varsSwapped;
}


    // Old way

    // Left

    //            CGFloat end = 0.0;
    //            for (double k = a; k <= b - deltaX; k += deltaX) {
    //
    //				@autoreleasepool {
    //
    //					NSDictionary *substitutions = @{var:@(k)};
    //					NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];
    //
    //					total += fOfX.doubleValue;
    //                    end =  k;
    //				}
    //                NSLog(@"end=%F", end);

    // Right

    //            for (double k = a + deltaX; k <= b; k += deltaX) {
    //
    //                @autoreleasepool {
    //
    //					NSDictionary *substitutions = @{var:@(k)};
    //					NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];
    //
    //					total += fOfX.doubleValue;
    //				}
    //            }



@end
