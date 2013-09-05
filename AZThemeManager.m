//
//  AZThemeManager.m
//  Weixin
//
//  Created by Aladdin on 8/1/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "AZThemeManager.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@implementation AZThemeManager
@synthesize http = _http;
@synthesize localhostPath = _localhostPath;


static AZThemeManager *_sharedInstance = nil;
static const int ddLogLevel = LOG_ASYNC_VERBOSE;

- (void)syncUserDefault{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li",(long)self.currentThemeIndex] forKey:@"currentThemeIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li",(long)self.currentIndex] forKey:@"currentIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) actionToNext{
    if (self.currentIndex >= [self countOfBackgrounds]-1) {
        self.currentIndex = 0;
        [self syncUserDefault];
        return;
    }
    self.currentIndex ++;
    [self syncUserDefault];
    return;
}
- (void) actionToLast{
    if (self.currentIndex == 0) {
        self.currentIndex = [self countOfBackgrounds]-1;
        [self syncUserDefault];
        return;
    }
    self.currentIndex --;
    [self syncUserDefault];
    return;
}

- (void) actionToTheme:(NSInteger)themeID{
    
}
- (NSString * ) currentBackground{
    return [_backgrounds objectAtIndex:self.currentIndex];
}
- (NSInteger) countOfBackgrounds{
    return [_backgrounds count];
}

+ (AZThemeManager *)sharedManager{
    
    if (nil != _sharedInstance) {
        return _sharedInstance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedInstance = [[AZThemeManager alloc] init];
    });
    
    return _sharedInstance;
}

- (void) initHttpServer{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    self.http = [[HTTPServer alloc] init];
    [self.http setType:@"_http._tcp."];
    
    NSInteger port = 51112;
    
    [self.http setPort:port];
    
    NSString *docRoot = [[[NSBundle mainBundle] bundlePath] stringByExpandingTildeInPath];
    DLog(@"Setting document root: %@", docRoot);
    [self.http setDocumentRoot:docRoot];
    
    NSError *error = nil;
    if(![self.http start:&error])
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
    self.localhostPath = [NSString stringWithFormat:@"127.0.0.1:%li/Contents/Resources/",(long)port];

}

- (void)localizedBackgrounds:(NSString *)themePath{
    NSString * plistPath = [NSString stringWithFormat:@"%@/Backgrounds.plist",themePath];
    NSArray * backgrounds = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"Backgrounds"];
    NSArray * tempA = [NSArray arrayWithArray:backgrounds];
    NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:backgrounds.count];
    for (NSString * name in tempA) {
        [resultArray addObject:[NSString stringWithFormat:@"http://%@%@/%@",self.localhostPath,[themePath lastPathComponent],name]];
    }
    _backgrounds = resultArray;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self initHttpServer];
        _themes = [[NSBundle mainBundle] pathsForResourcesOfType:@"bpack" inDirectory:nil];
        NSInteger currentThemeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentThemeIndex"];
        [self localizedBackgrounds:[_themes objectAtIndex:currentThemeIndex]];
        self.currentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentIndex"];
    }
    
    return self;
}

@end
