//
//  Base64.h
//  lemang
//
//  Created by LiZheng on 9/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+ (unsigned char *)encode:(NSData *) plainText;
@end
