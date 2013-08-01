//
//  AZThemeManager.m
//  Weixin
//
//  Created by Aladdin on 8/1/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "AZThemeManager.h"

@implementation AZThemeManager
static AZThemeManager *_sharedInstance = nil;

- (void)syncUserDefault{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li",(long)self.currentIndex] forKey:@"currentIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) actionToNext{
    if (self.currentIndex == [self countOfBackgrounds]-1) {
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


- (id)init
{
    self = [super init];
    
    if (self) {
        _backgrounds = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Backgrounds" ofType:@"plist"]];
        NSString * currentIndexStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentIndex"];
        if (currentIndexStr) {
            currentIndexStr = @"0";
            self.currentIndex = [currentIndexStr intValue];
            [self syncUserDefault];
        }
        self.currentIndex = [currentIndexStr intValue];
        
    }
    
    return self;
}

@end
