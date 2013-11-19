//
//  CalculatorObject.m
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import "CalculatorObject.h"

__strong static CalculatorObject *sharedInstance = nil;

@implementation CalculatorObject



+ (CalculatorObject *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CalculatorObject alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self resetDefaultValues];
    }
    
    return self;
}

- (void)resetDefaultValues
{
    self.startingNumber = 0.0;
    self.endingNumber = 4.0;
    self.number = 4.0;
}

@end
