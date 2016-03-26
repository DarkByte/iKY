//
//  AppDelegate.h
//  iKY
//
//  Created by Victor Pop on 17/03/15.
//  Copyright (c) 2016 Victor Pop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASShortcut.h"
#import "iKYUtils.h"

static NSString *const kGlobalShortcut = @"iKY_globalShortcut";

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSButton *micButton;

- (IBAction)toggleMicAction:(id)sender;
- (IBAction)openPreferencesPanel:(id)sender;

- (void)registerHotKey:(MASShortcut *)customKey;

@end

