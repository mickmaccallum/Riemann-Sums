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


- (void)areaUnderCurveOfFunction:(NSString *)function
                       startingAtX:(CGFloat)a
                      andEndingAtX:(CGFloat)b
            withNumberOfRectangles:(NSInteger)rectangles
                       inDirection:(ReimannSumType)direction
                     withCompletion:(CalculationCompleteBlock)completionBlock
{
    NSLog(@"Function: %@        A: %f   B: %f   Rectangles: %ld",function,a,b,rectangles);
    
    CGFloat deltaX = ((b - a) / (CGFloat)rectangles);
    CGFloat deltaMultiple = deltaX;
    	
    __block CGFloat sum = 0.0;

    CGFloat iterator = 0.0;
    CGFloat limit = 0.0;
    CGFloat additive = 0.0;
    CGFloat multiple = 1.0;
    
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
            
            limit = rectangles;
            iterator = a;
            
            deltaMultiple *= (1.0 / 2.0);
            multiple = 2.0;
            
            NSNumber *fOfA = [function numberByEvaluatingStringWithSubstitutions:@{var: @(a)}];
            NSNumber *fOfB = [function numberByEvaluatingStringWithSubstitutions:@{var: @(b)}];
            
            NSLog(@"FofA: %f",fOfA.doubleValue);
            NSLog(@"FofB: %f",fOfB.doubleValue);
            
            sum += fOfA.doubleValue;
            sum += fOfB.doubleValue;
            
        }break;
            
        default:{
            
        }break;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        NSError *calculationError = nil;
        
        for (NSInteger i = 0 ; i < (NSInteger)limit ; i ++) {
            
            @autoreleasepool {
                
                CGFloat x = a + ((CGFloat)i * deltaX);
                
                if (direction == ReimannSumTypeMiddle) {
                    x += additive;
                }
                
                NSLog(@"X: %f",x);
                
                NSNumber *evalAtX = [function numberByEvaluatingStringWithSubstitutions:@{var: @(x)} error:&calculationError];
                
                if (calculationError) {
                    completionBlock(sum,calculationError);
                    return;
                }
                
                sum += (evalAtX.doubleValue * multiple);
            }
        }
        
        sum *= deltaMultiple;
        
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
