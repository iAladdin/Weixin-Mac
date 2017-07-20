//
//  NSString+NSString_decode.m
//  Weixin
//
//  Created by Aladdin on 19/07/2017.
//  Copyright © 2017 iAladdin. All rights reserved.
//

#import "NSString+NSString_decode.h"

@implementation NSString (NSString_decode)
- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}
@end
