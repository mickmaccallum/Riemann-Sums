//
//  CalculatorObject.h
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathParser.h"

enum ReimannSumType {
    ReimannSumTypeNone = 0,
    ReimannSumTypeLeft = 2,
    ReimannSumTypeRight = 4,
    ReimannSumTypeMiddle = 8,
    ReimannSumTypeTrapezoid = 16
};

typedef enum ReimannSumType ReimannSumType;

typedef void(^CalculationCompleteBlock)(CGFloat sum, NSError *error);

@interface CalculatorObject : NSObject

- (void)areaUnderCurveOfFunction:(NSString *)function
                        startingAtX:(CGFloat)a
                       andEndingAtX:(CGFloat)b
             withNumberOfRectangles:(NSInteger)rectangles
                        inDirection:(ReimannSumType)direction
                     withCompletion:(CalculationCompleteBlock)completionBlock;

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;


+ (CalculatorObject *)sharedInstance;

@end
