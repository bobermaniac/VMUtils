//
//  VMSortedStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMFullProcessingStream.h"

@interface VMSortedStream : VMEnumerableStream

- (nonnull instancetype)initWithEnumerable:(nonnull id<NSFastEnumeration>)enumerable comparator:(nonnull VMStreamCompareBlock)compareBlock;

@property (nonatomic, copy, nonnull, readonly) VMStreamCompareBlock compareBlock;

@end
