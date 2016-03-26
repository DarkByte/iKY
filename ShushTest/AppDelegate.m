//
//  AppDelegate.m
//  iKY
//
//  Created by Victor Pop on 17/03/15.
//  Copyright (c) 2016 Victor Pop. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>
#import "ISSoundAdditions.h"
#import "DDHotKeyCenter.h"
#import "iKYPreferencesController.h"

@interface AppDelegate () {
    NSUserDefaults *defaults;

    DDHotKey *lastShortcut;
    DDHotKeyCenter *hotKeyCenter;
    
    unsigned short keyCode;
    NSUInteger modifiers;

    iKYPreferencesController *preferencesPanel;
}

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

#define MIKE_ON @"mike_on"
#define MIKE_OFF @"mike_off"

- (void)iKYinit {
    [iKYUtils suicideIfDuplicate];
    [self showMicEnabled:![NSSound isInputMuted]];
    
    NSWindow *mainWindow = [NSApplication sharedApplication].mainWindow;
    [mainWindow setLevel:CGWindowLevelForKey(kCGMaximumWindowLevelKey)];

    [self iKYsetup];
}

- (void)iKYsetup {
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    self->defaults = [NSUserDefaults standardUserDefaults];
    MASShortcut *globalShortcut = [MASShortcut shortcutWithData:[self->defaults objectForKey:kGlobalShortcut]];
    [self registerHotKey:globalShortcut];
}

- (void)registerHotKey:(MASShortcut *)customKey {
    hotKeyCenter = [DDHotKeyCenter sharedHotKeyCenter];

    if (self->lastShortcut) {
        [hotKeyCenter unregisterHotKey:self->lastShortcut];
    }
    self->lastShortcut = [hotKeyCenter registerHotKeyWithKeyCode:customKey.keyCode modifierFlags:customKey.modifierFlags
                                                          target:self action:@selector(toggleMicAction:) object:nil];
}

#pragma mark - User notifications

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)notifyUser:(BOOL)micEnabled {
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    
    NSUserNotification *mikeNotification = [[NSUserNotification alloc] init];
    
    mikeNotification.title = [NSString stringWithFormat:@"%@.", micEnabled ? @"MIKE: ON" : @"Mike: off"];
    mikeNotification.informativeText = [NSString stringWithFormat:@"Microphone status: %@ (toggle with ⌘⌃M)" , micEnabled ? @"enabled" : @"disabled"];
    
    mikeNotification.soundName = micEnabled ? MIKE_ON : MIKE_OFF;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:mikeNotification];
}

#pragma mark - Microphone related stuff

- (void)showMicEnabled:(BOOL)micEnabled
{
    [self.micButton setImage:[NSImage imageNamed:micEnabled ? MIKE_ON : MIKE_OFF]];
}

- (IBAction)toggleMicAction:(id)sender {
    BOOL isMute = [NSSound isInputMuted];

    [NSSound muteInput:!isMute];

    [self showMicEnabled:isMute];
    [self notifyUser:isMute];
}

- (IBAction)openPreferencesPanel:(id)sender {
    if (!preferencesPanel) {
        preferencesPanel = [[iKYPreferencesController alloc] initWithWindowNibName:@"iKYPreferencesController"];
    }

    [preferencesPanel showWindow:self];
}

#pragma mark - Application delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self iKYinit];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [hotKeyCenter unregisterHotKeyWithKeyCode:keyCode modifierFlags:modifiers];
}

@end
