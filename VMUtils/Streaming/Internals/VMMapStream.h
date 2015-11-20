//
//  VMMapStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMEnumerableStream.h"

@interface VMMapStream : VMEnumerableStream

- (nonnull instancetype) initWithEnumerable:(nonnull id<NSFastEnumeration>)enumerable mapBlock:(nullable VMStreamMapBlock)mapBlock NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, nonnull, readonly) VMStreamMapBlock mapBlock;

@end
