//
//  VMRangeStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMRangeStream.h"
#import "VMStream+Protected.h"

@interface VMRangeStream ()

@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, assign) NSUInteger cursor;

@end

@implementation VMRangeStream

- (instancetype)init {
    return [self initWithRange:NSMakeRange(0, 0)];
}

- (instancetype)initWithRange:(NSRange)range {
    if (self = [super init]) {
        _range = range;
        _cursor = range.location;
    }
    return self;
}

- (id)yield {
    if (_cursor < _range.location + _range.length) {
        return @(_cursor++);
    }
    return nil;
}

- (NSString *)description {
    if (!self.range.length) {
        return [NSString stringWithFormat:@"Empty range stream"];
    }
    return [NSString stringWithFormat:@"Range stream from %lu to %lu", self.range.location, self.range.location + self.range.length];
}

@end
