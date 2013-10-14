//
//  NSImage+File.m
//  Weixin
//
//  Created by Aladdin on 9/9/13.
//  Copyright (c) 2013 iAladdin. All rights reserved.
//

#import "NSImage+File.h"

@implementation NSImage (File)

- (void) saveAsJpegWithPath:(NSString *)filePath {
    NSData *imageData = [self TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    
    CGFloat compressionFactor = 1.0;
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:compressionFactor]
                                                           forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    [imageData writeToFile:filePath atomically:NO];
}

@end