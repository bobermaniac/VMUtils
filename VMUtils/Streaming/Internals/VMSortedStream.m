//
//  VMSortedStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMSortedStream.h"

@interface VMSortedStream ()

@property (nonatomic, strong) NSArray *sortingResult;

@end

@implementation VMSortedStream

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    return [self initWithEnumerable:enumerable comparator:^NSComparisonResult(id  _Nonnull first, id  _Nonnull second) {
        if ([first respondsToSelector:@selector(compare:)]) {
            return [first compare:second];
        }
        if ([second respondsToSelector:@selector(compare:)]) {
            return -[second compare:first];
        }
        return first > second ? NSOrderedAscending : first == second ? NSOrderedSame : NSOrderedDescending;
    }];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable comparator:(VMStreamCompareBlock)compareBlock {
    if (self = [super initWithEnumerable:enumerable]) {
        _compareBlock = [compareBlock copy];
    }
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    if (!self.sortingResult) {
        NSMutableArray *sortingResult = [NSMutableArray array];
        while (true) {
            __unsafe_unretained id obj = [self next];
            if (!obj) {
                break;
            }
            NSInteger index = [self _positionForInsertingElement:obj inArray:sortingResult comparator:self.compareBlock];
            [sortingResult insertObject:obj atIndex:index >= 0 ? index : ~index];
        }
        self.sortingResult = sortingResult;
    }
    return [self.sortingResult countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSInteger)_positionForInsertingElement:(__unsafe_unretained id)element inArray:(__unsafe_unretained NSArray *)array comparator:(__unsafe_unretained VMStreamCompareBlock)comparator {
    return [self _positionForInsertingElement:element inArray:array range:NSMakeRange(0, array.count) comparator:comparator];
}

- (NSInteger)_positionForInsertingElement:(__unsafe_unretained id)element inArray:(__unsafe_unretained NSArray *)array range:(NSRange)range comparator:(__unsafe_unretained VMStreamCompareBlock)comparator {
    NSInteger low = range.location;
    NSInteger high = range.location + range.length;
    while (low < high) {
        NSInteger mid = (low + high) >> 1;
        __unsafe_unretained id midVal = array[mid];
        NSComparisonResult cr = comparator(midVal, element);
        if (cr == NSOrderedAscending) {
            low = mid + 1;
        } else if (cr == NSOrderedDescending) {
            high = mid - 1;
        } else {
            return mid;
        }
    }
    return -(low + 1);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Sorting stream on %@", self.enumerable];
}

@end
