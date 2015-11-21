//
//  VMSkipStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMSkipStream.h"

@interface VMSkipStream () {
@private
    NSUInteger _skipCount;
}

@end

@implementation VMSkipStream

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    return [self initWithEnumerable:enumerable skipCount:0];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable skipCount:(NSUInteger)count {
    if (self = [super initWithEnumerable:enumerable]) {
        _skipCount = count;
    }
    return self;
}

- (id)yield {
    while(_skipCount != 0) {
        if (![self next]) {
            return nil;
        }
        _skipCount -= 1;
    }
    return [self next];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -> skip %@", self.enumerable, @(_skipCount)];
}

@end
