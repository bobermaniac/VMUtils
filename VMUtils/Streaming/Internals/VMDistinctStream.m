//
//  VMDistinctStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMDistinctStream.h"

@interface VMDistinctStream ()

@property (nonatomic, strong, readonly) NSMutableArray *yieldedObjects;

@end

@implementation VMDistinctStream

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    return [self initWithEnumerable:enumerable comparator:^BOOL(id  _Nonnull first, id  _Nonnull second) { return [first isEqualToString:second]; }];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable comparator:(VMStreamEqualsBlock)compareBlock {
    if (self = [super initWithEnumerable:enumerable]) {
        _compareBlock = [compareBlock copy];
        _yieldedObjects = [NSMutableArray array];
    }
    return self;
}

- (id)yield {
start:
    while (YES) {
        id obj = [self next];
        if (!obj) {
            [self.yieldedObjects removeAllObjects];
            return nil;
        }
        for (id yieldedObject in self.yieldedObjects) {
            if (self.compareBlock(yieldedObject, obj)) {
                goto start;
            }
        }
        [self.yieldedObjects addObject:obj];
        return obj;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -> distinct", self.enumerable];
}

@end
