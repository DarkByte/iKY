//
//  iKYUtils.m
//  iKY
//
//  Created by DarkByte on 26/03/16.
//  Copyright © 2016 DarkByte. All rights reserved.
//

#import "iKYUtils.h"

@interface iKYUtils ()

@end

@implementation iKYUtils

- (iKYUtils *)init
{
    if (self = [super init]) {
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
        
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        _appBuild = [info objectForKey:@"CFBundleShortVersionString"];
    }
    
    return self;
}

- (void)displaySuicideAlert
{
    NSAlert *suicideAlert = [NSAlert alertWithMessageText:[NSString stringWithFormat:NSLocalizedString(@"ditto", nil), _appName]
                                            defaultButton:nil alternateButton:nil otherButton:nil
                                informativeTextWithFormat:NSLocalizedString(@"auto_quit", nil)];
    
    NSTimer *suicideTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(terminate:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:suicideTimer forMode:NSModalPanelRunLoopMode];
    
    [suicideAlert runModal];
    [NSApp terminate:nil];
}

#pragma mark - Notifications

+ (void)playSound:(BOOL)micEnabled
{
    BOOL allowSound = [[NSUserDefaults standardUserDefaults] boolForKey:kPlaySound];
    if (!allowSound) {
        return;
    }

    NSSound *sound = [NSSound soundNamed:micEnabled ? MIKE_ON : MIKE_OFF];
    sound.volume = 0.1;
    [sound play];
}

+ (void)showNotification:(BOOL)micEnabled
{
    BOOL allowNotification = [[NSUserDefaults standardUserDefaults] boolForKey:kShowNotifications];
    if (!allowNotification) {
        return;
    }

    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];

    NSUserNotification *mikeNotification = [[NSUserNotification alloc] init];

    mikeNotification.title = [NSString stringWithFormat:@"Microphone: %@", micEnabled ? @"ENABLED" : @"disabled"];
    mikeNotification.informativeText = [NSString stringWithFormat:@"Toggle with %@", [iKYUtils sharedUtils].shortcutString];

    mikeNotification.soundName = nil;
    mikeNotification.contentImage = [NSImage imageNamed:micEnabled ? MIKE_ON : MIKE_OFF];

    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:mikeNotification];
}

#pragma mark - Class methods

+ (iKYUtils *)sharedUtils {
    static iKYUtils *sharedUtils = nil;
    @synchronized(self) {
        if (sharedUtils == nil)
            sharedUtils = [[self alloc] init];
    }
    return sharedUtils;
}

+ (void)suicideIfDuplicate
{
    if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]] count] > 1) {
        [[iKYUtils sharedUtils] displaySuicideAlert];
    }
}

+ (void)setLaunchOnLogin:(BOOL)launchOnLogin
{
    NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    LSSharedFileListRef loginItemsListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (launchOnLogin) {
        NSDictionary *properties;
        properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"com.apple.loginitem.HideOnLaunch"];
        LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsListRef, kLSSharedFileListItemLast, NULL, NULL, (__bridge CFURLRef)bundleURL, (__bridge CFDictionaryRef)properties,NULL);
        if (itemRef) {
            CFRelease(itemRef);
        }
    }
    else {
        LSSharedFileListRef loginItemsListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
        CFArrayRef snapshotRef = LSSharedFileListCopySnapshot(loginItemsListRef, NULL);
        NSArray *loginItems = (__bridge NSArray *)(snapshotRef);
        
        for (id item in loginItems) {
            LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
            CFURLRef itemURLRef;
            if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
                NSURL *itemURL = (__bridge NSURL *)(itemURLRef);
                if ([itemURL isEqual:bundleURL]) {
                    LSSharedFileListItemRemove(loginItemsListRef, itemRef);
                }
            }
        }
    }
}

+ (void)bringWindowOnTop:(NSWindow *)window
{
    [window setLevel:CGWindowLevelForKey(kCGMaximumWindowLevelKey)];
}

@end
