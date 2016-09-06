//
//  iKYPreferencesController.m
//  iKY
//
//  Created by DarkByte on 24/03/16.
//  Copyright © 2016 DarkByte. All rights reserved.
//

#import "iKYPreferencesController.h"
#import "AppDelegate.h"
#import "MASShortcut.h"
#import "MASShortcutView.h"

#define SharedAppDelegate ((AppDelegate *)[[NSApplication sharedApplication] delegate])

@interface iKYPreferencesController () {
    NSUserDefaults *defaults;
}

@property (weak) IBOutlet MASShortcutView *masShortcutView;
@property (weak) IBOutlet NSTextField *appVersionLabel;

@end

@implementation iKYPreferencesController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self loadPreferences];
}

- (void)loadPreferences
{

    self.appVersionLabel.stringValue = [NSString stringWithFormat:@"%@ v%@", [iKYUtils sharedUtils].appName, [iKYUtils sharedUtils].appBuild];

    self->defaults = [NSUserDefaults standardUserDefaults];

    self.playSoundCheckbox.state = [self->defaults integerForKey:kPlaySound];
    self.showNotificationsCheckbox.state = [self->defaults integerForKey:kShowNotifications];
    self.autoStartCheckbox.state = [self->defaults integerForKey:kAutoStart];

    MASShortcut *globalShortcut = [MASShortcut shortcutWithData:[self->defaults objectForKey:kGlobalShortcut]];
    self->_masShortcutView.shortcutValue = globalShortcut;

    self.masShortcutView.shortcutValueChange = ^(MASShortcutView *sender) {
        [self->defaults setObject:sender.shortcutValue.data forKey:kGlobalShortcut];
        [SharedAppDelegate registerHotKey:sender.shortcutValue];
    };
}

- (IBAction)playSoundAction:(id)sender {
    [self->defaults setInteger:self.playSoundCheckbox.state forKey:kPlaySound];
}

- (IBAction)showNotificationAction:(id)sender {
    [self->defaults setInteger:self.showNotificationsCheckbox.state forKey:kShowNotifications];
}

- (IBAction)autoStartAction:(id)sender
{
    [iKYUtils setLaunchOnLogin:self.autoStartCheckbox.state == NSOnState];
    [self->defaults setInteger:self.autoStartCheckbox.state forKey:kAutoStart];

    [self->defaults synchronize];
}

@end
