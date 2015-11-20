//
//  VMDistinctStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMEnumerableStream.h"
#import "VMStream+Protected.h"


@interface VMDistinctStream : VMEnumerableStream

- (nonnull instancetype)initWithEnumerable:(nonnull id<NSFastEnumeration>)enumerable comparator:(nullable VMStreamEqualsBlock)compareBlock NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, nonnull, readonly) VMStreamEqualsBlock compareBlock;

@end
