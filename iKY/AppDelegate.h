//
//  AppDelegate.h
//  iKY
//
//  Created by DarkByte on 17/03/15.
//  Copyright (c) 2016 DarkByte. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASShortcut.h"
#import "iKYUtils.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSButton *micButton;

- (IBAction)toggleMicAction:(id)sender;
- (IBAction)openPreferencesPanel:(id)sender;

- (void)registerHotKey:(MASShortcut *)customKey;

@end

