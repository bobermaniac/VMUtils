//
//  NSArray+Streaming.m
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "NSArray+Streaming.h"
#import "VMStream.h"

@implementation NSArray (Streaming)

- (VMStream *)stream {
    return [VMStream fromEnumerable:self];
}

@end
