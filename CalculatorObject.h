//
//  CalculatorObject.h
//  Reimann Sums
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorObject : NSObject

@property (assign , nonatomic) CGFloat startingNumber;
@property (assign , nonatomic) CGFloat endingNumber;
@property (assign , nonatomic) CGFloat number;


+ (CalculatorObject *)sharedInstance;

@end
