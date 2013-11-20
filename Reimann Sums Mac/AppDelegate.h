//
//  AppDelegate.h
//  Reimann Sums Mac
//
//  Created by Mick on 11/19/13.
//  Copyright (c) 2013 HappTech Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak , nonatomic) IBOutlet NSTextField *functionField;
@property (weak , nonatomic) IBOutlet NSTextField *startingField;
@property (weak , nonatomic) IBOutlet NSTextField *endingField;
@property (weak , nonatomic) IBOutlet NSTextField *numberOfRectanglesField;


@end
