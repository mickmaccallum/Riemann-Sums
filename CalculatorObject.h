//
//  CalculatorObject.h
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathParser.h"

enum ReimannSumDirection {
    ReimannSumDirectionNone = 0,
    ReimannSumDirectionLeft = 2,
    ReimannSumDirectionRight = 4
};

typedef enum ReimannSumDirection ReimannSumDirection;


@interface CalculatorObject : NSObject

- (CGFloat)areaUnderCurveOfFunction:(NSString *)function startingAtX:(CGFloat)xNot andEndingAtX:(CGFloat)xSubOne withNumberOfRectangles:(CGFloat)rectangles inDirection:(ReimannSumDirection)direction;

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;


+ (CalculatorObject *)sharedInstance;

@end
