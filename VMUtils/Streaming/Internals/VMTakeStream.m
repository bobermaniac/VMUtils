//
//  VMTakeStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMTakeStream.h"
#import "VMStream+Protected.h"

@interface VMTakeStream () {
    @private
    NSUInteger _takeCount;
}

@end

@implementation VMTakeStream

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    return [self initWithEnumerable:enumerable takeCount:0];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable takeCount:(NSUInteger)count {
    if (self = [super initWithEnumerable:enumerable]) {
        _takeCount = count;
    }
    return self;
}

- (id)yield {
    if (_takeCount == 0) {
        return nil;
    }
    _takeCount -= 1;
    return [self next];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -> take %@", self.enumerable, @(_takeCount)];
}

@end
