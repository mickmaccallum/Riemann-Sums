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


@interface CalculatorObject : NSObject

- (CGFloat)areaUnderCurveOfFunction:(NSString *)function startingAtX:(CGFloat)xNot andEndingAtX:(CGFloat)xSubOne withNumberOfRectangles:(CGFloat)rectangles inDirection:(ReimannSumType)direction;

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;


+ (CalculatorObject *)sharedInstance;

@end
