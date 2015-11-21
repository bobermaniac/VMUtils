//
//  VMReversedStream.m
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMReversedStream.h"

@implementation VMReversedStream

- (void)processObjects:(NSMutableArray *)objects {
    for (int i = 0; i < objects.count / 2; i++) {
        id tmp = objects[i];
        objects[i] = objects[objects.count - i - 1];
        objects[objects.count - i - 1] = tmp;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -> reverse", self.enumerable];
}

@end
