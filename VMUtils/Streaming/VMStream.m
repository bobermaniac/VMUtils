//
//  VMStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 18/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMStream.h"
#import "VMStream+Protected.h"
#import "VMMapStream.h"
#import "VMDistinctStream.h"
#import "VMRangeStream.h"
#import "VMSortedStream.h"
#import "VMEnumerableStream.h"

@interface VMStream () {
    @private
    unsigned long _mutation;
}

@end

@implementation VMStream

+ (VMStream *)empty {
    static VMStream *empty = nil;
    if (!empty) {
        empty = [[VMStream alloc] init];
    }
    return empty;
}

+ (VMStream *)range:(NSRange)range {
    return [[VMRangeStream alloc] initWithRange:range];
}

+ (VMStream *)fromEnumerable:(id<NSFastEnumeration>)enumerable {
    return [[VMEnumerableStream alloc] initWithEnumerable:enumerable];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    if (len == 0 || state->state == VMStreamEnumerationStateFinished) {
        return 0;
    }
    
    __unsafe_unretained id next = nil;
    size_t index = 0;
    state->itemsPtr = buffer;
    
    if (state->state == VMStreamEnumerationStateNotStarted) {
        // Populate mutation ptr from subsequent enumerable
        next = [self yield];
        if (!next) {
            state->state = VMStreamEnumerationStateFinished;
            return 0;
        }
        state->state = VMStreamEnumerationStateStarted;
        state->mutationsPtr = [self mutationPtr];
        state->itemsPtr[index++] = next;
    }
    while (true) {
        if (index >= len) {
            return index;
        }
        next = [self yield];
        if (!next) {
            state->state = VMStreamEnumerationStateFinished;
            return index;
        }
        state->itemsPtr[index++] = next;
    }
}

- (VMStream *)map:(VMStreamMapBlock)block {
    return [[VMMapStream alloc] initWithEnumerable:self mapBlock:block];
}

- (id)fold:(VMStreamFoldBlock)block {
    id accumulator = [self yield];
    if (!accumulator) {
        return nil;
    }
    return [self fold:block accumulator:accumulator];
}

- (id)fold:(VMStreamFoldBlock)block accumulator:(id)acc {
    while(true) {
        id next = [self yield];
        if (!next) {
            return acc;
        }
        acc = block(acc, next);
    }
}

- (VMStream *)distinct {
    return [[VMDistinctStream alloc] initWithEnumerable:self];
}

- (VMStream *)distinct:(VMStreamEqualsBlock)equalsBlock {
    return [[VMDistinctStream alloc] initWithEnumerable:self comparator:equalsBlock];
}

- (VMStream *)sort {
    return [[VMSortedStream alloc] initWithEnumerable:self];
}

- (VMStream *)sort:(VMStreamCompareBlock)compareBlock {
    return [[VMSortedStream alloc] initWithEnumerable:self comparator:compareBlock];
}

- (VMStream *)sort:(VMStreamCompareBlock)compareBlock ascending:(BOOL)ascending {
    if (ascending) {
        return [self sort:compareBlock];
    }
    return [self sort:^NSComparisonResult(id  _Nonnull first, id  _Nonnull second) {
        return -compareBlock(first, second);
    }];
}

- (NSArray *)materialize {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:64];
    for (__unsafe_unretained id obj in self) {
        [result addObject:obj];
    }
    return result;
}

@end

@implementation VMStream (Protected)

- (id)yield {
    return nil;
}

- (unsigned long *)mutationPtr {
    return &_mutation;
}

- (NSString *)description {
    return @"Empty stream";
}

@end