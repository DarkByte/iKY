//
//  iKYPreferencesController.h
//  iKY
//
//  Created by Victor Pop on 24/03/16.
//  Copyright © 2016 Victor Pop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iKYUtils.h"

@interface iKYPreferencesController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSButton *autoStartCheckbox;
@property (weak) IBOutlet NSButton *globalShortcutCheckbox;

- (IBAction)autoStartAction:(id)sender;
- (IBAction)globalShortcutAction:(id)sender;

@end
