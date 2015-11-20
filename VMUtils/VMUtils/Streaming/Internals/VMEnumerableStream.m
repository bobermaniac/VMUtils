//
//  VMEnumerableStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMEnumerableStream.h"
#import "VMStream+Protected.h"

typedef struct {
    NSFastEnumerationState state;
    __unsafe_unretained id buffer[16];
    id __unsafe_unretained * items;
    size_t cursor;
    size_t count;
} VMStreamInternalEnumerationState;

@interface VMEnumerableStream () {
@private
    VMStreamInternalEnumerationState _enumerator;
    NSNumber *_mutation;
}

@end

@implementation VMEnumerableStream

- (instancetype)init {
    return [self initWithEnumerable:[VMStream empty]];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    NSParameterAssert(enumerable);
    if (self = [super init]) {
        _enumerable = enumerable;
    }
    return self;
}

- (id)yield {
    return [self next];
}

- (__unsafe_unretained id)next {
    if (_enumerator.cursor >= _enumerator.count) {
        _enumerator.cursor = 0;
        _enumerator.count = [self.enumerable countByEnumeratingWithState:&_enumerator.state objects:_enumerator.buffer count:sizeof(_enumerator.buffer) / sizeof(_enumerator.buffer[0])];
    }
    if (!_enumerator.count) {
        return nil;
    }
    if (!_mutation) {
        _mutation = @(*_enumerator.state.mutationsPtr);
    } else {
        if (_mutation.unsignedLongValue != *_enumerator.state.mutationsPtr) {
            [NSException raise:@"Internal inconsistency exception" format:@"Subsequent collection was mutated"];
        }
    }
    _enumerator.items = _enumerator.state.itemsPtr;
    return _enumerator.items[_enumerator.cursor++];
}

- (unsigned long *)mutationPtr {
    return _enumerator.state.mutationsPtr;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Enumerable stream on %@", self.enumerable];
}

@end
