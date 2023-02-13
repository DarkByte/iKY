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

        [[NSNotificationCenter defaultCenter] postNotificationName:@"double_click_event" object:nil];
    }

    @end
