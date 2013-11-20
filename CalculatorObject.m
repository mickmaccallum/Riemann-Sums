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
                       startingAtX:(CGFloat)xNot
                      andEndingAtX:(CGFloat)xSubOne
            withNumberOfRectangles:(CGFloat)rectangles
                       inDirection:(ReimannSumDirection)direction
{
    CGFloat deltaX = ((xSubOne - xNot) / rectangles);
    
    __block CGFloat total = 0.0;
    
    switch (direction) {
        case ReimannSumDirectionNone: {
            
        }break;
         
        case ReimannSumDirectionLeft: {
            
            for (CGFloat k = xNot; k < xSubOne - deltaX; k += deltaX) {

				@autoreleasepool {
					NSDictionary *substitutions = @{var:@(k)};
					NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];

					total += fOfX.doubleValue;
				}

            }

        }break;
         
        case ReimannSumDirectionRight: {
            
            for (CGFloat k = xNot + deltaX; k <= xSubOne; k += deltaX) {

                @autoreleasepool {
					NSDictionary *substitutions = @{var:@(k)};
					NSNumber *fOfX = [function numberByEvaluatingStringWithSubstitutions:substitutions];

					total += fOfX.doubleValue;
				}
            }

        }break;

        default:
            break;
    }
    
    CGFloat final = total * deltaX;
    
    return final;
}

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function
{
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    return varsSwapped;
}


@end
