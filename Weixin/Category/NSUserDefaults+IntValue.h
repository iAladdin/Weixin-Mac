//
//  NSUserDefaults+IntValue.h
//  Weixin
//
//  Created by Aladdin on 9/3/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (IntValue)
- (NSInteger)intValueForKey:(NSString *)keyString;
@end
