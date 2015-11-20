//
//  VMFullProcessingStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMEnumerableStream.h"

@interface VMFullProcessingStream : VMEnumerableStream

- (void)processObjects:(nonnull NSMutableArray *)objects;

@end
