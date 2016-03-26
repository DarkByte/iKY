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

static NSString *const kAutoStart = @"autoStart";

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

    self.autoStartCheckbox.state = [self->defaults integerForKey:kAutoStart];

    MASShortcut *globalShortcut = [MASShortcut shortcutWithData:[self->defaults objectForKey:kGlobalShortcut]];
    self->_masShortcutView.shortcutValue = globalShortcut;

    self.masShortcutView.shortcutValueChange = ^(MASShortcutView *sender) {
        [self->defaults setObject:sender.shortcutValue.data forKey:kGlobalShortcut];
        [SharedAppDelegate registerHotKey:sender.shortcutValue];
    };
}

- (IBAction)autoStartAction:(id)sender
{
    [iKYUtils setLaunchOnLogin:self.autoStartCheckbox.state == NSOnState];

    [self->defaults setInteger:self.autoStartCheckbox.state forKey:kAutoStart];
    [self->defaults synchronize];
}

@end
