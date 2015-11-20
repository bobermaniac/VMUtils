//
//  NSArray+Streaming.h
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VMStream<T>;

@interface NSArray<T> (Streaming)

@property (nonatomic, readonly, strong, nonnull) VMStream<T> *stream;

@end
