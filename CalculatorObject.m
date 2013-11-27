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

@interface CalculatorObject ()

@property (strong) dispatch_queue_t queue;

@end

@implementation CalculatorObject


+ (CalculatorObject *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CalculatorObject alloc] init];
        
        sharedInstance.queue = dispatch_queue_create("com.Summation.MainLoopQueue", DISPATCH_QUEUE_SERIAL);

    });
    
    return sharedInstance;
}


- (CGFloat)areaUnderCurveOfFunction:(NSString *)function
                       startingAtX:(CGFloat)a
                      andEndingAtX:(CGFloat)b
            withNumberOfRectangles:(CGFloat)rectangles
                       inDirection:(ReimannSumType)direction
{
    CGFloat deltaX = ((b - a) / rectangles);
    	
    __block CGFloat sum = 0.0;

    CGFloat iterator = 0.0;
    CGFloat limit = 0.0;
    CGFloat additive = 0.0;
    
    switch (direction) {
        case ReimannSumTypeNone:
            
            return sum;
            
            break;
        case ReimannSumTypeLeft:
            
            limit = rectangles;
            
            break;
        case ReimannSumTypeRight:
            
            iterator = 1.0;
            limit = rectangles + 1.0;
            
            break;
        case ReimannSumTypeMiddle:
            
            limit = rectangles;
            additive = (deltaX / 2.0);
            break;
        case ReimannSumTypeTrapezoid:
            
            break;
        default :
            break;
    }
    
    for (NSInteger i = iterator; i < limit; i ++) {
     
        @autoreleasepool {
            
            CGFloat x = a + ((CGFloat)i * deltaX) + additive;
            
            NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)}];
            
            sum += evalAtX.doubleValue;
            
        }

    }
    
    sum *= deltaX;
    
    return sum;
}

- (CGFloat)middleSum:(CGFloat)delta start:(CGFloat)a end:(CGFloat)b func:(NSString *)function limit:(CGFloat)limit
{

    CGFloat sum = 0.0;
    
    for (int i = 0 ; i < limit ; i ++) {
        
        CGFloat x = a + ((CGFloat)i * delta) + (delta / 2.0);

        NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)}];
        
        sum += evalAtX.doubleValue;
    }
    
    sum *= delta;
    
    return sum;
}

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function
{
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    return varsSwapped;
}

@end
