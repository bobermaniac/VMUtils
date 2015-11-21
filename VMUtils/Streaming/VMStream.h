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
typedef id _Nullable (^VMStreamKeySelectorBlock)(id _Nonnull obj);
typedef id _Nonnull (^VMStreamJoinBlock)(id _Nullable left, id _Nullable right);

typedef NS_ENUM(NSUInteger, VMStreamJoinOptions) {
    VMStreamInnerJoin,
    VMStreamLeftOuterJoin,
};


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

- (nonnull VMStream<T> *)reverse;

- (nonnull VMStream<T> *)take:(NSUInteger)count;
- (nonnull VMStream<T> *)skip:(NSUInteger)count;

- (nonnull VMStream<T> *)distinct;
- (nonnull VMStream<T> *)distinct:(nonnull VMStreamEqualsBlock)equalsBlock;

/**
 *  Join stream with second stream by matching stream key with second stream key and processing matching result with joing block
 *
 *  @param second            Second stream
 *  @param keySelector       Key selector for original stream object (can be SEL, string or VMStreamKeySelectorBlock)
 *  @param secondKeySelector Key selector for second stream object (can be SEL, string or VMStreamKeySelectorBlock)
 *  @param equalsBlock       Equality comparer for keys
 *  @param joinBlock         Block to join found object
 *  @param options           Join options
 *
 *  @return Stream with processed joined objects
 */
- (nonnull VMStream *)join:(nonnull id<NSFastEnumeration>)second byKey:(nonnull id)keySelector matchesKey:(nonnull id)secondKeySelector byEquality:(nullable VMStreamEqualsBlock)equalsBlock resultObject:(nonnull VMStreamJoinBlock)joinBlock options:(VMStreamJoinOptions)options;

- (nonnull VMStream *)innerJoin:(nonnull id<NSFastEnumeration>)second byCondition:(nonnull VMStreamEqualsBlock)conditionBlock resultObject:(nonnull VMStreamJoinBlock)joinBlock;

- (nonnull VMStream *)innerJoin:(nonnull id<NSFastEnumeration>)second byKey:(nonnull id)keySelector matchesKey:(nonnull id)secondKeySelector resultObject:(nonnull VMStreamJoinBlock)joinBlock;

- (nonnull NSArray *)materialize;

@end
