//
//  VMEnumerableStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMStream.h"

@interface VMEnumerableStream : VMStream

- (nonnull instancetype)initWithEnumerable:(nonnull id<NSFastEnumeration>)enumerable NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly, nonnull) id<NSFastEnumeration> enumerable;

/**
 *  Call this method to get next element of subsequent enumerable
 *
 *  @return Next element of subsequent enumerable
 */
- (nullable __unsafe_unretained id)next;

@end
