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
    ReimannSumDirectionLeft = 0,
    ReimannSumDirectionRight = 0 << 1
};

typedef enum ReimannSumDirection ReimannSumDirection;


@interface CalculatorObject : NSObject

@property (assign , nonatomic) CGFloat startingNumber;
@property (assign , nonatomic) CGFloat endingNumber;
@property (assign , nonatomic) CGFloat number;

- (CGFloat)areaUnderCurveOfFunction:(NSString *)function startingAtX:(CGFloat)xNot andEndingAtX:(CGFloat)xSubOne inDirection:(ReimannSumDirection)direction;

+ (CalculatorObject *)sharedInstance;

@end
