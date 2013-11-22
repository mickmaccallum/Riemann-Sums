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
                       inDirection:(ReimannSumDirection)direction
{
    CGFloat deltaX = ((b - a) / rectangles);
	
    __block CGFloat sum = 0.0;

    CGFloat iterator = 0.0;
    CGFloat limit = 0.0;

    if (direction == ReimannSumDirectionLeft) {

        limit = rectangles;
  
    }else if (direction == ReimannSumDirectionRight) {
        
        iterator = 1.0;
        limit = rectangles + 1.0;
        
    }else{
        
        return sum;
        
    }
    
    for (CGFloat i = iterator; i < limit; i ++) {
     
        @autoreleasepool {
            
            CGFloat x = a + (i * deltaX);
            
            NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)}];
            
            sum += evalAtX.doubleValue;
            
        }

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

@end
