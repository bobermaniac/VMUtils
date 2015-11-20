//
//  VMFullProcessingStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMFullProcessingStream.h"
#import "VMStream+Protected.h"

@interface VMFullProcessingStream ()

@property (nonatomic, strong, readonly) NSMutableArray *objects;

@end

@implementation VMFullProcessingStream

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    if (!self.objects) {
        _objects = [self _enumerateAllObjects];
        [self processObjects:_objects];
    }
    return [self.objects countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSMutableArray *)_enumerateAllObjects {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:32];
    id next = nil;
    while ((next = [self next]) != nil) {
        [result addObject:next];
    }
    return result;
}

- (void)processObjects:(NSMutableArray *)objects {
    
}

@end
