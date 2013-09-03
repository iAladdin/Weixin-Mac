//
//  AZThemeManager.h
//  Weixin
//
//  Created by Aladdin on 8/1/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTTPServer.h"

@interface AZThemeManager : NSObject{
    NSArray * _backgrounds;
    NSArray * _themes;
    HTTPServer * _http;
    NSString * _localhostPath;
}
@property NSInteger currentIndex;
@property NSInteger currentThemeIndex;
@property (nonatomic,strong)    HTTPServer * http;
@property (nonatomic,strong)    NSString * localhostPath;
+ (AZThemeManager *)sharedManager;
- (void) actionToNext;
- (void) actionToLast;
- (void) actionToTheme:(NSInteger)themeID;
- (NSString * ) currentBackground;
- (NSInteger) countOfBackgrounds;
@end
