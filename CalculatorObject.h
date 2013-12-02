//
//  CalculatorObject.h
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathParser.h"

enum SumType {
    SumTypeNone,
    SumTypeReimannLeft,
    SumTypeReimannRight,
    SumTypeReimannMiddle,
    SumTypeReimannTrapezoidal,
    SumTypeSimpsonsRule
};

typedef enum SumType SumType;

typedef void(^CalculationCompleteBlock)(CGFloat sum, NSError *error);

@interface CalculatorObject : NSObject

- (void)areaUnderCurveOfFunction:(NSString *)function
                        startingAtX:(CGFloat)a
                       andEndingAtX:(CGFloat)b
             withNumberOfRectangles:(NSInteger)n
                        inDirection:(SumType)direction
                     withCompletion:(CalculationCompleteBlock)completionBlock;

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;
- (NSString *)outputTextFromSum:(CGFloat)sum;

@end
