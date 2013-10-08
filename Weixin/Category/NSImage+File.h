//
//  NSImage+File.h
//  Weixin
//
//  Created by Aladdin on 9/9/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (File)
- (void) saveAsJpegWithPath:(NSString *)filePath;
@end
