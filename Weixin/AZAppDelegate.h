//
//  AZAppDelegate.h
//  Weixin
//
//  Created by Aladdin on 7/29/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@class  HTTPServer;
@interface AZAppDelegate : NSObject <NSApplicationDelegate,NSUserNotificationCenterDelegate>{
    HTTPServer * httpServer;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSView *toolBar;
@property (assign) BOOL hasNew;

- (void)changeBackground:(WebView *)sender;
- (IBAction)shareCurrentMusic:(id)sender;
- (IBAction)donateToAladdin:(id)sender;
- (IBAction)nextBackground:(id)sender;
- (IBAction)lastBackground:(id)sender;

@end
