//
//  iKYUtils.h
//  iKY
//
//  Created by DarkByte on 26/03/16.
//  Copyright © 2016 DarkByte. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iKYConstants.h"

@interface iKYUtils : NSObject

@property NSString *appName;
@property NSString *appBuild;
@property NSString *shortcutString;

- (void)displaySuicideAlert;

+ (void)playSound:(BOOL)micEnabled;
+ (void)showNotification:(BOOL)micEnabled;

+ (iKYUtils *)sharedUtils;
+ (void)suicideIfDuplicate;
+ (void)setLaunchOnLogin:(BOOL)launchOnLogin;
+ (void)bringWindowOnTop:(NSWindow *)window;

@end
