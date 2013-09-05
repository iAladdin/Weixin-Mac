//
//  NSUserDefaults+IntValue.m
//  Weixin
//
//  Created by Aladdin on 9/3/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "NSUserDefaults+IntValue.h"

@implementation NSUserDefaults (IntValue)
- (NSInteger)intValueForKey:(NSString *)keyString{
    NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
    if (!value) {
        value = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li",[value integerValue]] forKey:keyString];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [value intValue];

    }
    return [value integerValue];
}
@end
