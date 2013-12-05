//
//  CalculatorObject.m
//  Riemann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "CalculatorObject.h"

static NSString * const var = @"x";


@implementation CalculatorObject


- (void)areaUnderCurveOfFunction:(NSString *)function
                     startingAtX:(NSString *)starting
                    andEndingAtX:(NSString *)ending
          withNumberOfRectangles:(unsigned int)n
                     inDirection:(SumType)direction
              andCompletionBlock:(CalculationCompleteBlock)completionBlock
{
    
    switch (direction) {
        case SumTypeRiemannLeft:{
            
            [self leftSampledAreaFromFunction:function startingAt:starting endingAt:ending withRectangleCount:n andCompletionBlock:^(double sum, NSError *error) {
                completionBlock(sum,error);
            }];
            
        }break;
            
        case SumTypeRiemannRight:{
            
            [self rightSampledAreaFromFunction:function startingAt:starting endingAt:ending withRectangleCount:n andCompletionBlock:^(double sum, NSError *error) {
                completionBlock(sum,error);
            }];
            
        }break;
            
        case SumTypeRiemannMiddle:{
            [self midPointSampledAreaFromFunction:function startingAt:starting endingAt:ending withRectangleCount:n andCompletionBlock:^(double sum, NSError *error) {
                completionBlock(sum,error);
            }];
            
        }break;
            
        case SumTypeRiemannTrapezoidal: {
            
            [self trapezoidallySampledAreaFromFunction:function startingAt:starting endingAt:ending withRectangleCount:n andCompletionBlock:^(double sum, NSError *error) {
                completionBlock(sum,error);
            }];
           
        }break;
            
        default:{
            
        }break;
    }

}


- (void)leftSampledAreaFromFunction:(NSString *)function
                         startingAt:(NSString *)startingString
                           endingAt:(NSString *)endingString
                 withRectangleCount:(unsigned int)n
                 andCompletionBlock:(CalculationCompleteBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        double a = [[startingString numberByEvaluatingString] doubleValue];
        double b = [[endingString numberByEvaluatingString] doubleValue];

        double sum = 0.0;
        double h = (b - a) / n;
        
        NSError *parseError = nil;
        
        DDParser *parser = [DDParser parserWithString:function error:&parseError];
        DDExpression *expression = [parser parsedExpressionWithError:&parseError];
        
        double start = CFAbsoluteTimeGetCurrent();

        for (unsigned int i = 0 ; i < n ; i ++) {
            @autoreleasepool {
                
                const double x = a + i * h;
                
                NSDictionary * const substitutions = @{var: @(x)};
                
                double y = [[expression evaluateWithSubstitutions:substitutions evaluator:nil error:&parseError] doubleValue];
                
                sum += y;
            }
        }
        
        sum *= h;
        
        NSLog(@"Time: %f",CFAbsoluteTimeGetCurrent() - start);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sum,nil);
        });
    });
}

- (void)rightSampledAreaFromFunction:(NSString *)function
                         startingAt:(NSString *)startingString
                           endingAt:(NSString *)endingString
                 withRectangleCount:(NSUInteger)n
                 andCompletionBlock:(CalculationCompleteBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        double a = [[startingString numberByEvaluatingString] doubleValue];
        double b = [[endingString numberByEvaluatingString] doubleValue];
        
        double sum = 0.0;
        double h = (b - a) / n;
        
        NSError *parseError = nil;
        
        DDParser *parser = [DDParser parserWithString:function error:&parseError];
        DDExpression *expression = [parser parsedExpressionWithError:&parseError];
        
        double start = CFAbsoluteTimeGetCurrent();
        
        for (unsigned int i = 1 ; i <= n ; i ++) {
            @autoreleasepool {
                
                const double x = a + i * h;
                
                NSDictionary * const substitutions = @{var: @(x)};
                
                double y = [[expression evaluateWithSubstitutions:substitutions evaluator:nil error:&parseError] doubleValue];
                
                sum += y;
            }
        }
        
        sum *= h;
        
        NSLog(@"Time: %f",CFAbsoluteTimeGetCurrent() - start);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sum,nil);
        });
    });
}

- (void)midPointSampledAreaFromFunction:(NSString *)function
                         startingAt:(NSString *)startingString
                           endingAt:(NSString *)endingString
                 withRectangleCount:(NSUInteger)n
                 andCompletionBlock:(CalculationCompleteBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        double a = [[startingString numberByEvaluatingString] doubleValue];
        double b = [[endingString numberByEvaluatingString] doubleValue];
        
        double sum = 0.0;
        double h = (b - a) / n;
        double m = h / 2.0;

        NSError *parseError = nil;
        
        DDParser *parser = [DDParser parserWithString:function error:&parseError];
        DDExpression *expression = [parser parsedExpressionWithError:&parseError];
        
        double start = CFAbsoluteTimeGetCurrent();
        
        for (unsigned int i = 0 ; i < n ; i ++) {
            @autoreleasepool {
                
                const double x = i * h + a + m;
                
                NSDictionary * const substitutions = @{var: @(x)};
                
                double y = [[expression evaluateWithSubstitutions:substitutions evaluator:nil error:&parseError] doubleValue];
                
                sum += y;
            }
        }
        
        sum *= h;
        
        NSLog(@"Time: %f",CFAbsoluteTimeGetCurrent() - start);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sum,nil);
        });
    });
}

- (void)trapezoidallySampledAreaFromFunction:(NSString *)function
                         startingAt:(NSString *)startingString
                           endingAt:(NSString *)endingString
                 withRectangleCount:(NSUInteger)n
                 andCompletionBlock:(CalculationCompleteBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        double a = [[startingString numberByEvaluatingString] doubleValue];
        double b = [[endingString numberByEvaluatingString] doubleValue];
        
        double sum = 0.0;
        double h = (b - a) / n;

        static double m = 2.0;
        static double dm = (1.0 / 2.0);

        NSError *parseError = nil;
        
        DDParser *parser = [DDParser parserWithString:function error:&parseError];
        DDExpression *expression = [parser parsedExpressionWithError:&parseError];
        
        double fOfA = [[expression evaluateWithSubstitutions:@{var: @(a)} evaluator:nil error:&parseError] doubleValue];
        double fOfB = [[expression evaluateWithSubstitutions:@{var: @(b)} evaluator:nil error:&parseError] doubleValue];
        
        sum += fOfA;
        sum += fOfB;
        
        double start = CFAbsoluteTimeGetCurrent();
        
        for (unsigned int i = 1 ; i < n ; i ++) {
            @autoreleasepool {
                
                const double x = a + i * h;
                
                NSDictionary * const substitutions = @{var: @(x)};
                
                double y = [[expression evaluateWithSubstitutions:substitutions evaluator:nil error:&parseError] doubleValue];
                
                sum += (y * m);
            }
        }
        
        sum *= (h * dm);
        
        NSLog(@"Time: %f",CFAbsoluteTimeGetCurrent() - start);
        
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
