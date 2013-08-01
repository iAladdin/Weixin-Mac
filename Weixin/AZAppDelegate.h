//
//  AZAppDelegate.h
//  Weixin
//
//  Created by Aladdin on 7/29/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AZAppDelegate : NSObject <NSApplicationDelegate,NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSView *toolBar;
@property (assign) BOOL hasNew;

- (IBAction)shareCurrentMusic:(id)sender;
- (IBAction)donateToAladdin:(id)sender;
@end
