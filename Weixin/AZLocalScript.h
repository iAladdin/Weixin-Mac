//
//  AZLocalScript.h
//  Weixin
//
//  Created by Aladdin on 9/7/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZLocalScript : NSObject{
    NSString * _url;
}
@property (nonatomic,strong) NSString * url;


+(id)scriptWithLocalFileName:(NSString * )fileName;


#pragma mark --
#pragma mark for JS
- (void)testFoo:(NSString *) string;
- (void)getImageUrl:(NSString *) urlString withCookie:(NSString *) cookieString;
#pragma mark --
@end
