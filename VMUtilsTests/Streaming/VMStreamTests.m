//
//  VMStreamTests.m
//  VMUtils
//
//  Created by Victor Bryksin on 18/11/15.
//  Copyright © 2015 Victor Bryksin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VMStream.h"
#import "NSArray+Streaming.h"

@interface VMStreamTests : XCTestCase

@end

@implementation VMStreamTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{

    }];
}

- (void)testSimpleEnumeration {
    VMStream *s = [VMStream range:NSMakeRange(0, 20)];
    s = [s distinct:^BOOL(id  _Nonnull first, id  _Nonnull second) {
        int i[2] = { [first intValue], [second intValue] };
        return abs(i[1] - i[0]) < 2;
    }];
    s = [s skip:5];
    s = [s take:5];
    s = [s reverse];
    NSArray *r = [s materialize];
    NSLog(@"%@", r);
}

- (void)testSort {
    NSLog(@"%@", [[@[ @5, @3, @1, @1, @8 ].stream sort] materialize]);
}

- (void)testJoin {
    VMStream *s = [@[ @"Beta", @"Master", @"Lol", @"Whatever" ].stream innerJoin:@[ @1, @2, @3, @4, @5 ] byCondition:^BOOL(NSString * _Nonnull first, NSNumber * _Nonnull second) {
        return first.length == second.intValue;
    } resultObject:^id _Nonnull(NSString * _Nullable left, NSNumber * _Nullable right) {
        return @{ @"s" : left, @"l" : right };
    }];
    s = [s map:^id _Nonnull(NSDictionary * _Nonnull obj) {
        return [NSString stringWithFormat:@"%@ -> %@", obj[@"s"], obj[@"l"]];
    }];
    s = [s sort:^NSComparisonResult(id  _Nonnull first, id  _Nonnull second) {
        return [@([first length]) compare:@([second length])];
    } ascending:NO];
    NSLog(@"%@", [s materialize]);
}

@end
