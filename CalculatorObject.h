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
typedef void(^CalculationProgressBlock)(CGFloat progress);

@interface CalculatorObject : NSObject

- (void)areaUnderCurveOfFunction:(NSString *)function
                     startingAtX:(NSString *)a
                    andEndingAtX:(NSString *)b
          withNumberOfRectangles:(NSInteger)n
                     inDirection:(SumType)direction
               withProgressBlock:(CalculationProgressBlock)progressBlock
              andCompletionBlock:(CalculationCompleteBlock)completionBlock;


- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;
- (NSString *)outputTextFromSum:(CGFloat)sum;

@end
