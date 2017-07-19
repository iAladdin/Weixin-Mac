//
//  AZLocalScript.m
//  Weixin
//
//  Created by Aladdin on 9/7/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "AZLocalScript.h"
#import "AZThemeManager.h"
#import "NSImage+File.h"
@implementation AZLocalScript
@synthesize url = _url;
+(id)scriptWithLocalFileName:(NSString * )fileName{
    AZLocalScript * local = [[AZLocalScript alloc] init];
    local.url = [NSString stringWithFormat:@"http://%@%@",[AZThemeManager sharedManager].localhostPath,fileName];
    return local;
}
- (void) testFoo:(NSString *) string{
    ALog(@"%@",string);
}
- (void)getImageUrl:(NSString *) urlString withCookie:(NSString *) cookieString{
    ALog(@"%@ %@",urlString,cookieString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://web.wechat.com%@",urlString]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
    [request setValue:@"https://web.wechat.com/?lang=zh_CN" forHTTPHeaderField:@"Referer"];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                         queue:[[NSOperationQueue alloc] init]
                                         completionHandler:^(NSURLResponse *response,
                                                             NSData *data,
                                                             NSError *error)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             if ([data length] >0 && error == nil && [httpResponse statusCode] == 200)
                                             {
                                                 
                                                 NSImage *image = [[NSImage alloc] initWithData:data];
                                                 [image saveAsJpegWithPath:[NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),[[request URL] lastPathComponent]]];
                                                 
                                             }
                                         }];
}


+ (NSString *) webScriptNameForSelector:(SEL)sel
{
    NSString * name;
    if (sel == @selector(testFoo:))
        name = @"testFoo";
    if (sel == @selector(getImageUrl:withCookie:)) {
        name = @"getImageUrlWithCookie";
    }
    
    return name;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
    if (aSelector == @selector(testFoo:)) return NO;
    if (aSelector == @selector(getImageUrl:withCookie:)) return NO;
    return YES;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)name{
    return NO;
}
@end
