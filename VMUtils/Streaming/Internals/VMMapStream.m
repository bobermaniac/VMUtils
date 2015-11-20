//
//  VMMapStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMMapStream.h"
#import "VMStream+Protected.h"

@implementation VMMapStream

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    return [self initWithEnumerable:enumerable mapBlock:^id _Nonnull(id  _Nonnull obj) { return obj; }];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable mapBlock:(VMStreamMapBlock)mapBlock {
    if (self = [super initWithEnumerable:enumerable]) {
        _mapBlock = [mapBlock copy];
    }
    return self;
}

- (id)yield {
    id obj = [self next];
    if (obj) {
        obj = _mapBlock(obj);
    }
    return obj;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Mapping stream on %@", self.enumerable];
}

@end
