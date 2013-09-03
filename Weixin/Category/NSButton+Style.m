//
//  NSButton+Style.m
//  Weixin
//
//  Created by Aladdin on 9/2/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "NSButton+Style.h"

@implementation NSButton (Style)
- (void)setTitle:(NSString*)title withColor:(NSColor*)color {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    [style setAlignment:NSCenterTextAlignment];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:title attributes:attrsDictionary];
    
    [self setAttributedTitle:attrString];
    
}

- (void)setTitleColor:(NSColor*)color {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    [style setAlignment:NSCenterTextAlignment];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:self.title attributes:attrsDictionary];
    
    [self setAttributedTitle:attrString];
    
    
}
@end
