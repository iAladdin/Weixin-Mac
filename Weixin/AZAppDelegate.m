//
//  AZAppDelegate.m
//  Weixin
//
//  Created by Aladdin on 7/29/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "AZAppDelegate.h"
#import <MASShortcut/Shortcut.h>
#import <AFNetworking/AFNetworking.h>
#import "AZWebView.h"
#import "iTunes.h"
#import "AZThemeManager.h"
#import "NSButton+Style.h"
#import "AZLocalScript.h"
#import "NSString+NSString_decode.h"
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
- (IBAction)reloadWX:(id)sender{
    [self.webView.mainFrame reloadFromOrigin];
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
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_X modifierFlags:NSEventModifierFlagCommand|NSEventModifierFlagControl];
        [[MASShortcutMonitor sharedMonitor] registerShortcut:shortcut withAction:^{
            [self.window orderFront:nil];
            [NSApp activateIgnoringOtherApps:YES];
            if([self.window isMiniaturized])
            {
                [self.window deminiaturize:self];
            }
        }];
}

- (void)addWeixinToolBar{
    self.toolBar.alphaValue = 0.3;
    [self.toolBar addTrackingRect:self.toolBar.bounds owner:self userData:NULL assumeInside:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent{
    [[self.toolBar animator] setAlphaValue:0.7];
    [[self.toolBar animator] setFrameOrigin:NSMakePoint(0,0)];
}
- (void)mouseExited:(NSEvent *)theEvent{
    [[self.toolBar animator] setAlphaValue:0.3];
    [[self.toolBar animator] setFrameOrigin:NSMakePoint(0, -70)];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setFrameAutosaveName:[self.window representedFilename]];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [self registerShortCuts];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"https://web.wechat.com/?lang=zh_CN"]];
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
        NSString * badgeString = [[[[title componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
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
    NSScrollView *mainScrollView = [(AZWebView*)sender mainScrollView];
    [mainScrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    [mainScrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
    
    DLog(@"%@",[sender stringByEvaluatingJavaScriptFromString:@"$(\".footer\").hide()"]);
    
    [self changeBackground:sender];
    [self loadLocalJavaScript:sender];
    AZLocalScript * localScript = [AZLocalScript scriptWithLocalFileName:@"local.js"];
    WebScriptObject * win =  sender.windowScriptObject;
    [win setValue:localScript forKey:@"localScript"];
    
}

#pragma mark WebFrameLoadDelegate END

#pragma mark WebFrameLoadDelegate START
- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource{
    NSString * urlString = [request.URL absoluteString];
    if ([urlString hasPrefix:@"https://file.wx.qq.com/cgi-bin/mmwebwx-bin/webwxgetmedia"]) {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
        NSString * downloadPath = [paths firstObject];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress)
        {
            NSLog(@"Progress: %f", downloadProgress.fractionCompleted);
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [NSURL URLWithString:downloadPath];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSData * data = [NSData dataWithContentsOfURL:[response URL]];
            NSString * filePathString = [filePath absoluteString];
            NSString * filePathDecodeString = [[filePathString stringByDecodingURLFormat] stringByDecodingURLFormat];
            [data writeToFile:filePathDecodeString options:NSDataWritingAtomic error:&error];
        }];
        [downloadTask resume];
        
    }
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
    WebFrame * frame = [actionInformation objectForKey:@"WebElementFrame"];
    NSString * html = [[frame webView] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    DLog(@"%s %@ \n %@ \n %@\n %@",__PRETTY_FUNCTION__,actionInformation,request,frameName,html);
    
    NSString * url = [[request URL] absoluteString];
    NSString * targetUrl = nil;
    if ([url hasPrefix:@"https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxcheckurl"]) {
        NSArray * coms = [url componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?&"]];
        
        for (NSString * item in coms) {
            NSArray * itemComs = [item componentsSeparatedByString:@"="];
            if ([itemComs count] == 2) {
                if ([[itemComs firstObject]   isEqualToString:@"requrl"]) {
                    targetUrl = [[itemComs lastObject] stringByDecodingURLFormat];
                    break;
                }
            }
        }
    }
    if (targetUrl&&targetUrl.length > 0 ) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:targetUrl]];
    }
}
#pragma mark WebPolicyDelegate END
@end
