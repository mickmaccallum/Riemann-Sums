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
            withNumberOfRectangles:(NSInteger)n
                       inDirection:(SumType)direction
                     withCompletion:(CalculationCompleteBlock)completionBlock
{
    
    CGFloat deltaX = ((b - a) / (CGFloat)n);
    CGFloat deltaMultiple = deltaX;
    	
    __block CGFloat sum = 0.0;

    NSInteger iterator = 0;
    CGFloat limit = 0.0;
    CGFloat additive = 0.0;
    CGFloat multiple = 1.0;
    
    switch (direction) {
        case SumTypeNone:{
            
            NSError *error = [NSError errorWithDomain:@"CalculatorObject - code 1, no summation type specified." code:1 userInfo:nil];
            completionBlock(sum,error);
            
        }break;
        
        case SumTypeReimannLeft:{
            
            limit = n;
            
        }break;
            
        case SumTypeReimannRight:{
            
            iterator = 1;
            limit = n + 1.0;
            
        }break;
            
        case SumTypeReimannMiddle:{
            
            limit = n;
            additive = (deltaX / 2.0);
            
        }break;
            
        case SumTypeReimannTrapezoidal: {
            
            limit = n;
            iterator = 1;
            
            deltaMultiple *= (1.0 / 2.0);
            multiple = 2.0;
            
            NSNumber *fOfA = [function numberByEvaluatingStringWithSubstitutions:@{var: @(a)}];
            NSNumber *fOfB = [function numberByEvaluatingStringWithSubstitutions:@{var: @(b)}];
            
            sum += fOfA.doubleValue;
            sum += fOfB.doubleValue;
            
        }break;
        
        case SumTypeSimpsonsRule:{
            
            [self areaUnderCurveUsingSimpsonsRule:function startingAt:a andEndingAt:b withNumberOfRectangles:n withCompletion:^(CGFloat sum, NSError *error) {
                completionBlock(sum,error);
            }];
            return;
        }break;
            
        default:{
            
        }break;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        NSError *calculationError = nil;
        
        for (NSInteger i = iterator ; i < (NSInteger)limit ; i ++) {
            
            @autoreleasepool {
                
                CGFloat x = a + ((CGFloat)i * deltaX);
                
                if (direction == SumTypeReimannMiddle) {
                    x += additive;
                }
                
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

- (void)areaUnderCurveUsingSimpsonsRule:(NSString *)function
                             startingAt:(CGFloat)a
                            andEndingAt:(CGFloat)b
                 withNumberOfRectangles:(NSInteger)n
                         withCompletion:(CalculationCompleteBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        NSError *error = nil;
        
        CGFloat firstTerm = (b - a) / 6.0;
        
        NSNumber *fOfA = [function numberByEvaluatingStringWithSubstitutions:@{var: @(a)} error:&error];
        NSNumber *fOfB = [function numberByEvaluatingStringWithSubstitutions:@{var: @(b)} error:&error];
        NSNumber *aAndBOverTwo = [function numberByEvaluatingStringWithSubstitutions:@{var: @((a + b) / 2.0)} error:&error];
        
        
        CGFloat secondTerm = fOfA.doubleValue + (4.0 * aAndBOverTwo.doubleValue)+ fOfB.doubleValue;
        
        if (!error) {
            
            CGFloat sum = firstTerm * secondTerm;
            
            dispatch_async(dispatch_get_main_queue(), ^{
        
                completionBlock(sum,nil);

            });

        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completionBlock(0.0,error);
                
            });
        }
        
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
