//
//  AppDelegate.m
//  iKY
//
//  Created by DarkByte on 17/03/15.
//  Copyright (c) 2016 DarkByte. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>
#import "ISSoundAdditions.h"
#import "DDHotKeyCenter.h"
#import "iKYPreferencesController.h"

@interface AppDelegate () {
    NSUserDefaults *defaults;

    NSString *lastShortcutString;
    DDHotKey *lastShortcut;
    DDHotKeyCenter *hotKeyCenter;
    
    unsigned short keyCode;
    NSUInteger modifiers;

    iKYPreferencesController *preferencesPanel;

    NSStatusItem *menuIcon;
    NSMenu *barMenu;
}

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)iKYinit {
    [self loadDefaults];
    [iKYUtils suicideIfDuplicate];

    [self initAppIcon];
    [self iKYRestore];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMicAction:) name:@"double_click_event" object:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    MASShortcut *globalShortcut = [MASShortcut shortcutWithData:[self->defaults objectForKey:kGlobalShortcut]];
    [self registerHotKey:globalShortcut];

    [self showMainWindow];
    [self openPreferencesFirstTime];
}

- (void)iKYRestore {
    [self showMicEnabled:![NSSound isInputMuted]];
}

#pragma mark - Menu bar icon

- (void)initAppIcon {
    self->menuIcon = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self initTopMenu];
}

- (void)initTopMenu {
    self->barMenu = [NSMenu new];
    [self->barMenu addItemWithTitle:@"Toggle microphone" action:@selector(toggleMicAction:) keyEquivalent:@""];
    [self->barMenu addItem:NSMenuItem.separatorItem];
    [self->barMenu addItemWithTitle:@"Preferences" action:@selector(openPreferencesPanel:) keyEquivalent:@","];
    [self->barMenu addItem:NSMenuItem.separatorItem];
    [self->barMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];

    self->menuIcon.menu = self->barMenu;
    self->menuIcon.button.tag = kActivateCustomClick;
}

- (void)updateAppIconImage:(NSString *)mikeImageName {
    NSString *imageName = [NSString stringWithFormat:@"menu_%@", mikeImageName];
    self->menuIcon.image = [NSImage imageNamed:imageName];
}

#pragma mark - Microphone related stuff

- (void)showMicEnabled:(BOOL)micEnabled {
    NSString *mikeImageName = micEnabled ? MIKE_ON : MIKE_OFF;

    [self.micButton setImage:[NSImage imageNamed:mikeImageName]];
    [self updateAppIconImage:mikeImageName];
}

- (IBAction)toggleMicAction:(id)sender {
    BOOL isMute = [NSSound isInputMuted];

    [NSSound muteInput:!isMute];

    [self showMicEnabled:isMute];
    [self notifyUser:isMute];
}

#pragma mark - Preferences

- (void)loadDefaults {
    self->defaults = [NSUserDefaults standardUserDefaults];

    // default hotkey: // Cmd + Ctrl + Z
    MASShortcut *defaultHotKey = [MASShortcut shortcutWithKeyCode:6 modifierFlags:NSCommandKeyMask | NSControlKeyMask];
    NSDictionary *defaultPrefs = @{kFirstTime : @1,
                                   kGlobalShortcut: defaultHotKey.data,
                                   kShowMain : @1,
                                   kShowNotifications : @1,
                                   kPlaySound : @1};
    [self->defaults registerDefaults:defaultPrefs];
}

- (void)openPreferencesFirstTime {
    if ([self->defaults boolForKey:kFirstTime]) {
        [self openPreferencesPanel:self];
        [self->defaults setBool:NO forKey:kFirstTime];
    }
}

- (void)showMainWindow {
    if ([self->defaults boolForKey:kShowMain]) {
        [_mainWindow makeKeyAndOrderFront:self];
    }
}

- (IBAction)openPreferencesPanel:(id)sender {
    if (!preferencesPanel) {
        preferencesPanel = [[iKYPreferencesController alloc] initWithWindowNibName:@"iKYPreferencesController"];
    }

    [preferencesPanel showWindow:self];
    [iKYUtils bringWindowOnTop:preferencesPanel.window];
}

#pragma mark - User notifications

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)notifyUser:(BOOL)micEnabled {
    [iKYUtils playSound:micEnabled];
    [iKYUtils showNotification:micEnabled];
}

#pragma mark - Application delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self iKYinit];
}

- (void)applicationWillUnhide:(NSNotification *)notification {
    [self iKYRestore];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    [self iKYRestore];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return NO;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [hotKeyCenter unregisterHotKeyWithKeyCode:keyCode modifierFlags:modifiers];
}

#pragma mark - System-wide keyboard shortcut binder

- (void)registerHotKey:(MASShortcut *)customKey {
    [iKYUtils sharedUtils].shortcutString = customKey.description;

    hotKeyCenter = [DDHotKeyCenter sharedHotKeyCenter];
    
    if (self->lastShortcut) {
        [hotKeyCenter unregisterHotKey:self->lastShortcut];
    }
    self->lastShortcut = [hotKeyCenter registerHotKeyWithKeyCode:customKey.keyCode modifierFlags:customKey.modifierFlags
                                                          target:self action:@selector(toggleMicAction:) object:nil];
}

@end
