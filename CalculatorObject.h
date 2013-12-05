//
//  CalculatorObject.h
//  Riemann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathParser.h"

enum SumType : NSInteger {
    SumTypeRiemannLeft,
    SumTypeRiemannMiddle,
    SumTypeRiemannRight,
    SumTypeRiemannTrapezoidal,
};

typedef enum SumType SumType;

typedef void(^CalculationCompleteBlock)(double sum, NSError *error);

@interface CalculatorObject : NSObject

- (void)areaUnderCurveOfFunction:(NSString *)function
                     startingAtX:(NSString *)start
                    andEndingAtX:(NSString *)finish
          withNumberOfRectangles:(unsigned int)number
                     inDirection:(SumType)sumType
              andCompletionBlock:(CalculationCompleteBlock)completion;

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;
- (NSString *)outputTextFromSum:(CGFloat)sum;

@end
