//
//  iKYUtils.h
//  iKY
//
//  Created by Victor Pop on 26/03/16.
//  Copyright © 2016 Victor Pop. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iKYUtils : NSObject

+ (void)suicideIfDuplicate;
+ (void)setLaunchOnLogin:(BOOL)launchOnLogin;

@end
