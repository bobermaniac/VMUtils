//
//  VMJoinStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 20/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMJoinStream.h"
#import "VMStream+Protected.h"
#import "NSArray+Streaming.h"
#import "VMEnumerableStream.h"

@interface VMJoinStreamPair : NSObject

@property (nonatomic, strong, readonly, nullable) id key;
@property (nonatomic, strong, readonly, nonnull) id object;

+ (nonnull VMJoinStreamPair *)pairWithKey:(nullable id)key forObject:(nonnull id)object;

@end

@implementation VMJoinStreamPair

+ (VMJoinStreamPair *)pairWithKey:(id)key forObject:(id)object {
    VMJoinStreamPair *pair = [[VMJoinStreamPair alloc] init];
    pair->_key = key;
    pair->_object = object;
    return pair;
}

@end

@interface VMJoinStream ()

@property (nonatomic, strong, nonnull, readonly) VMStream *right;
@property (nonatomic, copy, nonnull) VMStreamKeySelectorBlock leftKeySelectorBlock;
@property (nonatomic, copy, nonnull) VMStreamKeySelectorBlock rightKeySelectorBlock;
@property (nonatomic, copy, nonnull) VMStreamEqualsBlock keyEqualsBlock;
@property (nonatomic, copy, nonnull) VMStreamJoinBlock joinBlock;
@property (nonatomic, assign) VMStreamJoinOptions options;

@property (nonatomic, strong, readonly) NSMutableArray *rightEnumeratedObjects;

@end

@implementation VMJoinStream

- (id<NSFastEnumeration>)left {
    return self.enumerable;
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable {
    return [self initWithEnumerable:enumerable secondEnumerable:@[].stream keySelector:^id _Nullable(id  _Nonnull obj) {
        return nil;
    } secondKeySelector:^id _Nullable(id  _Nonnull obj) {
        return nil;
    } keyEqualsBlock:^BOOL(id  _Nonnull first, id  _Nonnull second) {
        return NO;
    } joinBlock:^id _Nonnull(id  _Nullable left, id  _Nullable right) {
        return left;
    } options:VMStreamLeftOuterJoin];
}

- (instancetype)initWithEnumerable:(id<NSFastEnumeration>)enumerable secondEnumerable:(id<NSFastEnumeration>)secondEnumerable keySelector:(VMStreamKeySelectorBlock)keySelector secondKeySelector:(VMStreamKeySelectorBlock)secondKeySelector keyEqualsBlock:(VMStreamEqualsBlock)keyEqualsBlock joinBlock:(VMStreamJoinBlock)joinBlock options:(VMStreamJoinOptions)options {
    if (self = [super initWithEnumerable:enumerable]) {
        if ([(id)secondEnumerable conformsToProtocol:@protocol(NSObject)]) {
            id<NSObject, NSFastEnumeration> right = (id)secondEnumerable;
            if ([right isKindOfClass:[VMStream class]]) {
                _right = (VMStream *)right;
            }
        }
        if (!_right) {
            _right = [[VMEnumerableStream alloc] initWithEnumerable:secondEnumerable];
        }
        self.leftKeySelectorBlock = keySelector;
        self.rightKeySelectorBlock = secondKeySelector;
        self.keyEqualsBlock = keyEqualsBlock;
        self.joinBlock = joinBlock;
        self.options = options;
    }
    return self;
}

@synthesize rightEnumeratedObjects = _rightEnumeratedObjects;

- (NSMutableArray *)rightEnumeratedObjects {
    if (!_rightEnumeratedObjects) {
        _rightEnumeratedObjects = [NSMutableArray array];
    }
    return _rightEnumeratedObjects;
}

- (id)yield {
    while(YES) {
        id left = [self next];
        if (!left) {
            return nil;
        }
        id leftKey = self.leftKeySelectorBlock(left);
        for (VMJoinStreamPair *rightPair in self.rightEnumeratedObjects) {
            if (self.keyEqualsBlock(leftKey, rightPair.key)) {
                return self.joinBlock(left, rightPair.object);
            }
        }
        while (YES) {
            id right = [self.right yield];
            if (!right) {
                break;
            }
            VMJoinStreamPair *rightPair = [VMJoinStreamPair pairWithKey:self.rightKeySelectorBlock(right) forObject:right];
            [self.rightEnumeratedObjects addObject:rightPair];
            if (self.keyEqualsBlock(leftKey, rightPair.key)) {
                return self.joinBlock(left, rightPair.object);
            }
        }
        if (self.options == VMStreamLeftOuterJoin) {
            return self.joinBlock(left, nil);
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -> join (%@)", self.enumerable, self.right];
}

@end
