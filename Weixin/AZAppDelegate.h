//
//  AZAppDelegate.h
//  Weixin
//
//  Created by Aladdin on 7/29/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "AZWebView.h"
@interface AZAppDelegate : NSObject <NSApplicationDelegate,NSUserNotificationCenterDelegate>{
    NSPanel * _imagePanel;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet AZWebView *webView;
@property (weak) IBOutlet NSView *toolBar;
//@property (weak) IBOutlet NSButton *sponsor;
//@property (weak) IBOutlet NSButton *donate;
@property (assign) BOOL hasNew;

- (void)changeBackground:(WebView *)sender;
- (IBAction)shareCurrentMusic:(id)sender;
- (IBAction)donateToAladdin:(id)sender;
- (IBAction)nextBackground:(id)sender;
- (IBAction)lastBackground:(id)sender;
- (IBAction)reloadWX:(id)sender;

@end
