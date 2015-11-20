//
//  VMReaderWriterLock.m
//  VMUtils
//
//  Created by Victor Bryksin on 03.11.15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMReaderWriterLock.h"

@interface VMReaderWriterLock () {
    @private
    volatile UInt32 _lock;
}

@end

@implementation VMReaderWriterLock

- (nonnull instancetype)init {
    if (self = [super init]) {
        _lock = 0;
    }
    return self;
}

@end
