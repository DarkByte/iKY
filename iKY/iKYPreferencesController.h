//
//  iKYPreferencesController.h
//  iKY
//
//  Created by DarkByte on 24/03/16.
//  Copyright © 2016 DarkByte. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iKYUtils.h"

@interface iKYPreferencesController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSButton *playSoundCheckbox;
@property (weak) IBOutlet NSButton *showNotificationsCheckbox;

@property (weak) IBOutlet NSButton *autoStartCheckbox;

- (IBAction)playSoundAction:(id)sender;
- (IBAction)showNotificationAction:(id)sender;

- (IBAction)autoStartAction:(id)sender;

@end
