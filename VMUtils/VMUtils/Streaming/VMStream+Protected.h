//
//  VMStream+Protected.h
//  VMUtils
//
//  Created by Victor Bryksin on 18/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMStream.h"

typedef NS_ENUM(unsigned long, VMStreamEnumerationState) {
    VMStreamEnumerationStateNotStarted = 0,
    VMStreamEnumerationStateStarted = 1,
    VMStreamEnumerationStateFinished = 2,
};

@interface VMStream (Protected)

/**
 *  Override this method to return next element. It will be called when enumerator needs it
 *
 *  @return Next element
 */
- (nullable __unsafe_unretained id)yield;

/**
 *  Override this method to return mutation ptr for stream
 *
 *  @return Mutation ptr
 */
- (nullable unsigned long *)mutationPtr;

@end
