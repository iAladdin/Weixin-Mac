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
#import "NSButton+Style.h"

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
                      @"虽然这个App很简单，但还是考虑赞助给Aladdin和他的12只猫猫吧!如有建议和bug请联系微信号:Aladdin");
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
        [self.window orderFront:nil];
        [NSApp activateIgnoringOtherApps:YES];
        if([self.window isMiniaturized])
        {
            [self.window deminiaturize:self];
        }

    }];
    DLog(@"%@",_constantShortcutMonitor);
}

- (void)addWeixinToolBar{
    self.toolBar.alphaValue = 0.3;
    [self.toolBar addTrackingRect:self.toolBar.bounds owner:self userData:NULL assumeInside:YES];
    [self.sponsor setTitleColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.8]];
    [self.donate setTitleColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.8]];
}

- (void)mouseEntered:(NSEvent *)theEvent{
    [[self.toolBar animator] setAlphaValue:0.7];
    [[self.sponsor animator] setFrameSize:NSMakeSize(270,90)];
}
- (void)mouseExited:(NSEvent *)theEvent{
    [[self.toolBar animator] setAlphaValue:0.3];
    [[self.sponsor animator] setFrameSize:NSMakeSize(90, 90)];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setFrameAutosaveName:[self.window representedFilename]];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [self registerShortCuts];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://wx.qq.com/?lang=zh_CN"]];
    [self.webView.mainFrame loadRequest:request];
    [self addWeixinToolBar];
    
    
}

- (void)applicationWillBecomeActive:(NSNotification *)notification{
    self.hasNew = NO;
    [NSApp dockTile].badgeLabel = nil;
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    [self.window orderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    return YES;
}
#pragma mark WebFrameLoadDelegate START
- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame{
    DLog(@"%s %@",__PRETTY_FUNCTION__,title);
    if ([title hasSuffix:@")"]) {
        NSString * badgeString = [[[[title componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] firstObject];
        if ([badgeString isEqualToString:[NSApp dockTile].badgeLabel]) {
            return;
        }else{
            DLog(@"%@",badgeString);
            [NSApp dockTile].badgeLabel = badgeString;
        }
    }
    if (![title hasSuffix:@")"]|| self.hasNew) {
        return;
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"小伙伴发来新的微信";
    notification.informativeText = title;
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    self.hasNew = YES;
    
}
- (NSString * )cssStringWithFileName:(NSString *)filename{
    NSStringEncoding * encoding = NULL;
    //$('head').append('<style type="text/css">body {margin:0;}</style>');
    NSString * cssFileContent = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:filename withExtension:@"css"]
                                                usedEncoding:encoding
                                                       error:nil];
    NSString * cssString = [NSString stringWithFormat:@"'<style type=\"text/css\">%@</style>'",cssFileContent];
    
    return cssString;
}
- (void)loadLocalJavaScript:(WebView * )sender{
    NSString * js = [NSString stringWithFormat:@"$.getScript('http://%@local.js',function(){newFun('\"Checking new script\"');})",[AZThemeManager sharedManager].localhostPath];
    
    [sender stringByEvaluatingJavaScriptFromString:js];
}
- (void)changeBackground:(WebView *)sender {

    NSString* css = [NSString stringWithFormat:@"\"@media screen and (-webkit-min-device-pixel-ratio: 2), screen and (max--moz-device-pixel-ratio: 2){ body { background-image:url(%@)  no-repeat;background-size:auto auto;}} body { background-image:url(%@) no-repeat;background-size:auto auto;}\"",[AZThemeManager sharedManager].currentBackground,[AZThemeManager sharedManager].currentBackground];
    DLog(@"css:\n %@",css);
    NSString* js = [NSString stringWithFormat:
                    @"var styleNode = document.createElement('style');\n"
                    "styleNode.type = \"text/css\";\n"
                    "var styleText = document.createTextNode(%@);\n"
                    "styleNode.appendChild(styleText);\n"
                    "document.getElementsByTagName('body')[0].appendChild(styleNode);\n",css];
    DLog(@"js:\n%@",js);
    
    NSString * js2 = [NSString stringWithFormat:@"$('body').css(\"background-image\",\"url(%@)\")",[AZThemeManager sharedManager].currentBackground];
    [self.webView stringByEvaluatingJavaScriptFromString:js2];
    
//    NSString * js3 = [NSString stringWithFormat:@"$('body').css(\"background-size\",\"auto 100%%\")"];
//    [self.webView stringByEvaluatingJavaScriptFromString:js3];
    
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    DLog(@"%@",[sender stringByEvaluatingJavaScriptFromString:@"$(\".footer\").hide()"]);
    
    [self changeBackground:sender];
    [self loadLocalJavaScript:sender];
}

#pragma mark WebFrameLoadDelegate END

#pragma mark WebFrameLoadDelegate START
- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource{
    DLog(@"%@ %@ %@",sender,request,[[dataSource response] MIMEType]);
    return dataSource;
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

#pragma mark WebPolicyDelegate START
- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
   newFrameName:(NSString *)frameName
decisionListener:(id<WebPolicyDecisionListener>)listener{
    DLog(@"%s %@ \n %@ \n %@",__PRETTY_FUNCTION__,actionInformation,request,frameName);
    [[NSWorkspace sharedWorkspace] openURL:[request URL]];
}
#pragma mark WebPolicyDelegate END
@end
