//
//  VMJoinStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMEnumerableStream.h"

@interface VMJoinStream : VMEnumerableStream

- (nonnull instancetype)initWithEnumerable:(nonnull id<NSFastEnumeration>)enumerable secondEnumerable:(nonnull id<NSFastEnumeration>)secondEnumerable keySelector:(nonnull VMStreamKeySelectorBlock)keySelector secondKeySelector:(nonnull VMStreamKeySelectorBlock)secondKeySelector keyEqualsBlock:(nonnull VMStreamEqualsBlock)keyEqualsBlock joinBlock:(nonnull VMStreamJoinBlock)joinBlock options:(VMStreamJoinOptions)options;

@end
