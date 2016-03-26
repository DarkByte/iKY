//
//  iKYPreferencesController.m
//  iKY
//
//  Created by Victor Pop on 24/03/16.
//  Copyright © 2016 Victor Pop. All rights reserved.
//

#import "iKYPreferencesController.h"
#import "AppDelegate.h"
#import "MASShortcut.h"
#import "MASShortcutView.h"

#define SharedAppDelegate ((AppDelegate *)[[NSApplication sharedApplication] delegate])

static NSString *const kAutoStart = @"autoStart";
static NSString *const kUseGlobalShortcut = @"useGlobalShortcut";

@interface iKYPreferencesController () {
    NSUserDefaults *defaults;
}

@property (weak) IBOutlet MASShortcutView *masShortcutView;

@end

@implementation iKYPreferencesController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self loadPreferences];
}

- (void)loadPreferences
{
    self->defaults = [NSUserDefaults standardUserDefaults];
    MASShortcut *globalShortcut = [MASShortcut shortcutWithData:[self->defaults objectForKey:kGlobalShortcut]];
    self->_masShortcutView.shortcutValue = globalShortcut;

    self.masShortcutView.shortcutValueChange = ^(MASShortcutView *sender) {
        [self->defaults setObject:sender.shortcutValue.data forKey:kGlobalShortcut];
        [SharedAppDelegate registerHotKey:sender.shortcutValue];
    };

    self.autoStartCheckbox.state = [[NSUserDefaults standardUserDefaults] integerForKey:kAutoStart];
    self.globalShortcutCheckbox.state = [[NSUserDefaults standardUserDefaults] integerForKey:kUseGlobalShortcut];
}

- (IBAction)autoStartAction:(id)sender
{
    [iKYUtils setLaunchOnLogin:self.autoStartCheckbox.state == NSOnState];

    [self->defaults setInteger:self.autoStartCheckbox.state forKey:kAutoStart];
    [self->defaults synchronize];
}

- (IBAction)globalShortcutAction:(id)sender
{
    [self->defaults setInteger:self.globalShortcutCheckbox.state forKey:kUseGlobalShortcut];
    [self->defaults synchronize];
}

@end
