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
                     startingAtX:(NSString *)starting
                    andEndingAtX:(NSString *)ending
          withNumberOfRectangles:(NSInteger)n
                     inDirection:(SumType)direction
               withProgressBlock:(CalculationProgressBlock)progressBlock
              andCompletionBlock:(CalculationCompleteBlock)completionBlock
{

    CGFloat a = [starting numberByEvaluatingString].doubleValue;
    CGFloat b = [ending numberByEvaluatingString].doubleValue;
    
    
    
    CGFloat h = ((b - a) / (CGFloat)n);
    CGFloat deltaMultiple = h;
    	
    __block CGFloat sum = 0.0;

    NSInteger iterator = 0;
    CGFloat limit = n;
    CGFloat additive = 0.0;
    CGFloat multiple = 1.0;
    
    switch (direction) {
        case SumTypeNone:{
            
            NSError *error = [NSError errorWithDomain:@"CalculatorObject - code 1, no summation type specified." code:1 userInfo:nil];
            completionBlock(sum,error);
            
        }break;
        
        case SumTypeReimannLeft:{
            
            
        }break;
            
        case SumTypeReimannRight:{
            
            iterator = 1;
            limit ++;
            
        }break;
            
        case SumTypeReimannMiddle:{
            
            additive = (h / 2.0);
            
        }break;
            
        case SumTypeReimannTrapezoidal: {
            
            iterator = 1;
            
            deltaMultiple *= (1.0 / 2.0);
            multiple = 2.0;
            
            NSNumber *fOfA = [function numberByEvaluatingStringWithSubstitutions:@{var: @(a)}];
            NSNumber *fOfB = [function numberByEvaluatingStringWithSubstitutions:@{var: @(b)}];
            
            sum += fOfA.doubleValue;
            sum += fOfB.doubleValue;
            
        }break;
        
        case SumTypeSimpsonsRule:{
            
            [self areaUnderCurveUsingSimpsonsRule:function startingAt:a andEndingAt:b withNumberOfRectangles:n withProgressBlock:^(CGFloat progress) {
                progressBlock(progress);
            } andCompletionBlock:^(CGFloat sum, NSError *error) {
                completionBlock(sum,error);
            }];
            
            return;
        }break;
            
        default:{
            
        }break;
    }
    
    
    __block NSError *parseError = nil;
    
    DDParser *parser = [DDParser parserWithString:function error:&parseError];
    DDExpression *e = [parser parsedExpressionWithError:&parseError];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, kNilOptions) ,^{
        
        NSError *calculationError = nil;

        for (NSInteger i = iterator ; i < (NSInteger)limit ; i ++) {

            @autoreleasepool {
            
                CGFloat x = a + ((CGFloat)i * h);
                
                if (direction == SumTypeReimannMiddle) {
                    x += additive;
                }
                
                NSNumber *evalAtX = [e evaluateWithSubstitutions:@{var: @(x)} evaluator:nil error:&parseError];
                
                if (calculationError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(sum,calculationError);
                        return;                        
                    });
                }
                
                sum += (evalAtX.doubleValue * multiple);
                dispatch_async(dispatch_get_main_queue(), ^{
//                    progressBlock();
                });
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
                      withProgressBlock:(CalculationProgressBlock)progressBlock
                     andCompletionBlock:(CalculationCompleteBlock)completionBlock;
{
    CGFloat sum = 0.0;
    CGFloat term1 = (b - a) / 6.0;
    

    CGFloat fOfA = [[function numberByEvaluatingStringWithSubstitutions:@{var: @(a)}] doubleValue];
    CGFloat fOfB = [[function numberByEvaluatingStringWithSubstitutions:@{var: @(b)}] doubleValue];

    CGFloat func = [[function numberByEvaluatingStringWithSubstitutions:@{var: @((a + b) / 2.0)}] doubleValue];
    
    
    sum += fOfA;
    sum += fOfB;
    
    sum *= (func * 4.0);
    sum *= term1;
    
    completionBlock(sum,nil);

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
