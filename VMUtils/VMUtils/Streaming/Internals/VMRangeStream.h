//
//  VMRangeStream.h
//  VMUtils
//
//  Created by Victor Bryksin on 19/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import "VMStream.h"

@interface VMRangeStream : VMStream

- (nonnull instancetype)initWithRange:(NSRange)range NS_DESIGNATED_INITIALIZER;

@end
