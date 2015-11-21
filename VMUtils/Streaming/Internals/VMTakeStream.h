//
//  VMTakeStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMEnumerableStream.h"

@interface VMTakeStream : VMEnumerableStream

- (nonnull instancetype)initWithEnumerable:(nonnull id<NSFastEnumeration>)enumerable takeCount:(NSUInteger)count NS_DESIGNATED_INITIALIZER;

@end
