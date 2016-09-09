//
//  NSButton+DoubleClick.m
//  iKY
//
//  Created by Victor Pop on 09/09/16.
//  Copyright © 2016 Victor Pop. All rights reserved.
//

#import "NSButton+CustomClick.h"
#import "iKYConstants.h"

    @implementation NSButton (CustomClick)

    - (void)mouseDown:(NSEvent *)event {
        if (self.tag != kActivateCustomClick) {
            [super mouseDown:event];
            return;
        }

        switch (event.clickCount) {
            case 1: {
                [self performSelector:@selector(callMouseDownSuper:) withObject:event afterDelay:[NSEvent doubleClickInterval]];
                break;
            }
            case 2: {
                [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"double_click_event" object:nil];
                break;
            }
        }
    }

    - (void)callMouseDownSuper:(NSEvent *)event {
        [super mouseDown:event];
    }

    @end
