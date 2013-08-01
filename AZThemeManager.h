//
//  AZThemeManager.h
//  Weixin
//
//  Created by Aladdin on 8/1/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZThemeManager : NSObject{
    NSArray * _backgrounds;
}
@property  NSInteger currentIndex;

+ (AZThemeManager *)sharedManager;
- (void) actionToNext;
- (void) actionToLast;
- (NSString * ) currentBackground;
- (NSInteger) countOfBackgrounds;
@end
