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

- (double)areaUnderCurveOfFunction:(NSString *)function startingAtX:(double)xNot andEndingAtX:(double)xSubOne withNumberOfRectangles:(double)rectangles inDirection:(ReimannSumDirection)direction;

- (NSString *)functionPreparedForMathParserFromString:(NSString *)function;


+ (CalculatorObject *)sharedInstance;

@end
