//
//  VMStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 18/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^VMStreamPredicateBlock)(id _Nonnull obj);
typedef id _Nonnull (^VMStreamMapBlock)(id _Nonnull obj);
typedef id _Nonnull (^VMStreamFoldBlock)(id _Nonnull acc, id _Nonnull obj);
typedef BOOL (^VMStreamEqualsBlock)(id _Nonnull first, id _Nonnull second);
typedef NSComparisonResult (^VMStreamCompareBlock)(id _Nonnull first, id _Nonnull second);

@interface VMStream<T> : NSObject<NSFastEnumeration>

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

+ (nonnull VMStream<T> *)empty;
+ (nonnull VMStream<T> *)range:(NSRange)range;
+ (nonnull VMStream<T> *)fromEnumerable:(nonnull id<NSFastEnumeration>)enumerable;

- (nonnull VMStream<T> *)map:(nonnull VMStreamMapBlock)mapBlock;

- (nonnull VMStream<T> *)sort;
- (nonnull VMStream<T> *)sort:(nonnull VMStreamCompareBlock)compareBlock;
- (nonnull VMStream<T> *)sort:(nonnull VMStreamCompareBlock)compareBlock ascending:(BOOL)ascending;

- (nullable id)fold:(nonnull VMStreamFoldBlock)block;
- (nullable id)fold:(nonnull VMStreamFoldBlock)block accumulator:(nullable id)acc;

- (nonnull VMStream<T> *)distinct;
- (nonnull VMStream<T> *)distinct:(nonnull VMStreamEqualsBlock)equalsBlock;

- (nonnull NSArray *)materialize;

@end
