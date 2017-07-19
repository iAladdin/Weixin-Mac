//
//  AZWebView.m
//  Weixin
//
//  Created by Aladdin on 19/07/2017.
//  Copyright © 2017 iAladdin. All rights reserved.
//

#import "AZWebView.h"

@implementation AZWebView

- (NSScrollView *)mainScrollView {
    return [[[[self mainFrame] frameView] documentView] enclosingScrollView]; // can be nil
}
@end
