//
//  iKYUtils.h
//  iKY
//
//  Created by DarkByte on 26/03/16.
//  Copyright © 2016 DarkByte. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iKYUtils : NSObject

+ (void)suicideIfDuplicate;
+ (void)setLaunchOnLogin:(BOOL)launchOnLogin;
+ (void)bringMainWindowOnTop;

@end
