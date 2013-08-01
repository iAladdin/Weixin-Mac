//
//  AZAppDelegate.m
//  Weixin
//
//  Created by Aladdin on 7/29/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "AZAppDelegate.h"
#import "MASShortcut.h"
#import "MASShortcut+Monitoring.h"
#import "iTunes.h"
#import "AZThemeManager.h"

@implementation AZAppDelegate

- (IBAction)shareCurrentMusic:(id)sender{
    iTunesApplication *itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
//
    NSString * jsString = [NSString stringWithFormat:@"$(\"textarea#textInput\").val(\"%@\");$(\"a.chatSend\").click()",[[itunes currentTrack] name]];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}
- (IBAction)nextBackground:(id)sender{
    [[AZThemeManager sharedManager] actionToNext];
    [self changeBackground:self.webView];
}
- (IBAction)lastBackground:(id)sender{
    [[AZThemeManager sharedManager] actionToLast];
    [self changeBackground:self.webView];
}

- (IBAction)donateToAladdin:(id)sender{
    
    NSBeginAlertSheet(@"赞助作者一点猫粮吧？",
                      @"好，去捐赠！",
                      nil,
                      @"不够好，算了",
                      self.window,
                      self,
                      @selector(sheetDidEnd:returnCode:contextInfo:),
                      @selector(sheetDidDismiss:returnCode:contextInfo:),
                      (__bridge void *)(sender),
                      @"虽然这个App很简单，但还是考虑赞助给Aladdin和他的四只猫猫吧");
}

#pragma mark alertDelegate START
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
    if (returnCode == NSAlertDefaultReturn){
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://me.alipay.com/ialaddin"]];
    }
}
- (void)sheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
    
}
#pragma mark alertDelegate END

- (void)registerShortCuts{
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_O modifierFlags:NSCommandKeyMask|NSControlKeyMask];
    NSString *  _constantShortcutMonitor = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut handler:^{
        [NSApp activateIgnoringOtherApps:YES];  
    }];
    NSLog(@"%@",_constantShortcutMonitor);
}

- (void)addWeixinToolBar{
//    self.toolBar.layer.backgroundColor = [NSColor colorWithDeviceRed:0.0
//                                                               green:0
//                                                                blue:0
//                                                               alpha:1.0].CGColor;
//    self.toolBar.layer.cornerRadius = 3;
    self.toolBar.alphaValue = 0.3;
    [self.toolBar addTrackingRect:self.toolBar.bounds owner:self userData:NULL assumeInside:YES];
    
}

- (void)mouseEntered:(NSEvent *)theEvent{
    self.toolBar.alphaValue = 0.7;
}
- (void)mouseExited:(NSEvent *)theEvent{
    self.toolBar.alphaValue = 0.3;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [self registerShortCuts];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://wx.qq.com/"]];
    [self.webView.mainFrame loadRequest:request];
    [self addWeixinToolBar];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification{
    self.hasNew = NO;
}
#pragma mark WebFrameLoadDelegate START
- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame{
    NSLog(@"%s %@",__PRETTY_FUNCTION__,title);
    if ([title isEqualToString:@"Web WeChat"]|| self.hasNew) {
        return;
    }
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"小伙伴发来新的微信";
    notification.informativeText = title;
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    self.hasNew = YES;
}

- (void)changeBackground:(WebView *)sender {
    //    NSLog(@"%ld",(long)[AZThemeManager sharedManager].currentIndex);
    NSString * jsString = [NSString stringWithFormat:@"$(\"body\").css(\"background-image\",\"url(%@)\");$(\"body\").css(\"background-size\",\"100%% auto\");",[AZThemeManager sharedManager].currentBackground];
    //,[[NSBundle mainBundle] URLForImageResource:@"Background"]
    NSLog(@"%@",[sender stringByEvaluatingJavaScriptFromString:jsString]);
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    NSLog(@"%@",[sender stringByEvaluatingJavaScriptFromString:@"$(\".footer\").hide()"]);
    
    [self changeBackground:sender];
}

#pragma mark WebFrameLoadDelegate END

#pragma mark WebUIDelegate START

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:NO];
    
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [[openDlg URLs]valueForKey:@"relativePath"];
        [resultListener chooseFilenames:files];
    }
    
}
#pragma mark WebUIDelegate END
@end
