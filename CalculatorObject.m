//
//  CalculatorObject.m
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "CalculatorObject.h"

static NSString *var = @"x";


@implementation CalculatorObject


- (instancetype)init
{
    self = [super init];

    if (self) {
        //
    }
    
    return self;
}


- (void)areaUnderCurveOfFunction:(NSString *)function
                       startingAtX:(CGFloat)a
                      andEndingAtX:(CGFloat)b
            withNumberOfRectangles:(NSInteger)rectangles
                       inDirection:(ReimannSumType)direction
                     withCompletion:(CalculationCompleteBlock)completionBlock
{
    
    NSLog(@"Function: %@        A: %f   B: %f   Rectangles: %ld",function,a,b,rectangles);
    
    CGFloat deltaX = ((b - a) / (CGFloat)rectangles);
    	
    __block CGFloat sum = 0.0;

    CGFloat iterator = 0.0;
    CGFloat limit = 0.0;
    CGFloat additive = 0.0;
    
    switch (direction) {
        case ReimannSumTypeNone:{
            
            NSError *error = [NSError errorWithDomain:@"CalculatorObject - code 1, no summation type specified." code:1 userInfo:nil];
            completionBlock(sum,error);
            
        }break;
        
        case ReimannSumTypeLeft:{
            
            limit = rectangles;
            
        }break;
            
        case ReimannSumTypeRight:{
            
            iterator = 1.0;
            limit = rectangles + 1.0;
            
        }break;
            
        case ReimannSumTypeMiddle:{
            
            limit = rectangles;
            additive = (deltaX / 2.0);
            
        }break;
            
        case ReimannSumTypeTrapezoid: {
            
        }break;
            
        default:{
            
        }break;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        NSError *calculationError = nil;
        
        for (NSInteger i = iterator ; i < limit ; i ++) {
            
            @autoreleasepool {
                
                CGFloat x = a + ((CGFloat)i * deltaX) + ((direction == ReimannSumTypeMiddle) ? additive : 0);
                
                NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)} error:&calculationError];
                
                if (calculationError) {
                    completionBlock(sum,calculationError);
                    return;
                }
                sum += evalAtX.doubleValue;
            }
        }
        
        sum *= deltaX;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            completionBlock(sum,nil);
            
        });
    });
}

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function
{
    NSString *powersFixed = [function stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    NSString *varsSwapped = [powersFixed stringByReplacingOccurrencesOfString:var withString:@"($x)"];

    return varsSwapped;
}


- (NSString *)outputTextFromSum:(CGFloat)sum
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    if (sum < 100000000000.0) {
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }else{
        [formatter setNumberStyle:NSNumberFormatterScientificStyle];
    }
    
    NSString *text = [formatter stringFromNumber:@(sum)];

    return text;
}

@end
