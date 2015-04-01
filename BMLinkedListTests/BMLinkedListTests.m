//
//  BMLinkedListTests.m
//  BMLinkedListTests
//
//  Created by Benjamin Morrison on 6/11/14.
//  Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BMDoublyLinkedList.h"

@interface BMLinkedListTests : XCTestCase

@end

@implementation BMLinkedListTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



#pragma mark - Testing Inits
- (void)testEmptyInit {
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] init];
    
    if (sut == nil) {
        XCTFail(@"Initalization Failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}



-(void)testInit {
    BMDoublyLinkedList *sut = [BMDoublyLinkedList new];
    
    if (sut == nil) {
         XCTFail(@"Initalization Failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testInitFromArray {
    NSArray *array = @[@1, @2, @3, @4, @5];
    
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];
    
    if (array.count != sut.count) {
         XCTFail(@"Count Test Failed in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.head.object != array[0]) {
        XCTFail(@"Head Item Test Failed in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.tail.object != [array lastObject]) {
        XCTFail(@"Tail Item Test Failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}




#pragma mark - Test Queries
- (void)testContainsObject {
    NSNumber *numberToRemove = @7683;

    NSArray *array = @[@1, @2, @3, numberToRemove, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    XCTAssertTrue([sut containsObject:numberToRemove], @"Unable to find object in list in \"%s\"", __PRETTY_FUNCTION__);
}



- (void)testFastEnumeration {
    NSArray *array = @[@1, @2, @3, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    NSUInteger currentIndex = 0;
    for (BMDoublyLinkedListNode *node in sut) {
        XCTAssertEqual(node.object, array[currentIndex], @"Fast Enumeration issue at inded:%lu in \"%s\"", currentIndex, __PRETTY_FUNCTION__);
        ++currentIndex;
    }
}



- (void)testContainsNode {
    NSNumber *numberToRemove = @7683;
    
    NSArray *array = @[@1, @2, @3, numberToRemove, @4, @5];
    
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];
    
    BMDoublyLinkedListNode *node = [sut nodeForObject:numberToRemove];
    
    if (![sut containsNode:node]) {
        XCTFail(@"Unable to find node in list in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testIndexForObject {
    NSNumber *thirdNumber = @3;
    NSArray *array = @[@1, @2, thirdNumber, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];
    
    NSUInteger foundIndex = [sut indexForObject:thirdNumber];

    if (foundIndex != 2) {
        XCTFail(@"indexForObject failed to return the correct index in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testIndexForNode {
    NSNumber *thirdNumber = @3;
    NSArray *array = @[@1, @2, thirdNumber, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    BMDoublyLinkedListNode *nodeToFind = sut.head.next.next;

    NSUInteger foundIndex = [sut indexForNode:nodeToFind];

    if (foundIndex != 2) {
        XCTFail(@"indexForObject failed to return the correct index in \"%s\"", __PRETTY_FUNCTION__);
    }
}




#pragma mark - Testing Getters
- (void)testObjectAtIndex {
    NSArray *array = @[@1, @2, @3, @4, @5];
    
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];
    
    for (NSUInteger i = 0; i < sut.count; ++i) {
        if ([sut objectAtIndex:i] != array[i]) {
            XCTFail(@"Object at Index Test Failed in \"%s\"", __PRETTY_FUNCTION__);
        }
    }
}



- (void)testNodeAtIndex {
    NSArray *array = @[@1, @2, @3, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    for (NSUInteger i = 0; i < sut.count; ++i) {
        BMDoublyLinkedListNode *currentNode = [sut nodeAtIndex:i];
        if (currentNode.object != array[i]) {
            XCTFail(@"Node At Index Test Failed! in \"%s\"", __PRETTY_FUNCTION__);
        }
    }
}



- (void)testNodeForObject {
    NSArray *array = @[@1, @2, @3, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    for (NSUInteger i = 0; i < array.count; ++i) {
        NSNumber *currentNumber = array[i];

        BMDoublyLinkedListNode *nodeForNumber = [sut nodeForObject:currentNumber];

        if (nodeForNumber.object != currentNumber) {
            XCTFail(@"Node For Object Test Failed! in \"%s\"", __PRETTY_FUNCTION__);
        }
    }

}



- (void)testArrayFromList {
    NSArray *array = @[@1, @2, @3, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    NSArray *arrayFromList = [sut arrayFromList];

    for (NSInteger i = 0; i < array.count; ++i) {
        XCTAssertEqual(array[i], arrayFromList[i], @"arrayFromList failed to work correctly in \"%s\"", __PRETTY_FUNCTION__);
    }
}




#pragma mark - Testing Setters
- (void)testPushFront {
    NSNumber *firstNumber = @1;
    NSNumber *secondNumber = @2;
    NSNumber *thirdNumber = @3;
    
    BMDoublyLinkedList *sut = [BMDoublyLinkedList new];
    
    [sut pushFront:firstNumber];
    
    if (sut.head.object != firstNumber) {
        XCTFail(@"PushFront Item %@ failed in \"%s\"",firstNumber ,__PRETTY_FUNCTION__);
    }
    
    [sut pushFront:secondNumber];
    
    if (sut.head.object != secondNumber) {
        XCTFail(@"PushFront Item %@ failed in \"%s\"",secondNumber ,__PRETTY_FUNCTION__);
    }
    
    [sut pushFront:thirdNumber];
    
    if (sut.head.object != thirdNumber) {
        XCTFail(@"PushFront Item %@ failed in \"%s\"",thirdNumber ,__PRETTY_FUNCTION__);
    }
    
}



- (void)testPushBack {
    NSNumber *firstNumber = @1;
    NSNumber *secondNumber = @2;
    NSNumber *thirdNumber = @3;
    
    BMDoublyLinkedList *sut = [BMDoublyLinkedList new];
    
    [sut pushBack:firstNumber];
    
    if (sut.tail.object != firstNumber) {
        XCTFail(@"pushBack Item %@ failed in \"%s\"",firstNumber ,__PRETTY_FUNCTION__);
    }
    
    [sut pushBack:secondNumber];
    
    if (sut.tail.object != secondNumber) {
        XCTFail(@"pushBack Item %@ failed in \"%s\"",secondNumber ,__PRETTY_FUNCTION__);
    }
    
    [sut pushBack:thirdNumber];
    
    if (sut.tail.object != thirdNumber) {
        XCTFail(@"pushBack Item %@ failed in \"%s\"",thirdNumber ,__PRETTY_FUNCTION__);
    }
    
}



- (void)testAddObject {
    NSNumber *firstNumber = @1;
    NSNumber *secondNumber = @2;
    NSNumber *thirdNumber = @3;

    BMDoublyLinkedList *sut = [BMDoublyLinkedList new];

    [sut addObject:firstNumber];

    if (sut.tail.object != firstNumber) {
        XCTFail(@"addObject Item %@ failed in \"%s\"",firstNumber ,__PRETTY_FUNCTION__);
    }

    [sut addObject:secondNumber];

    if (sut.tail.object != secondNumber) {
        XCTFail(@"addObject Item %@ failed in \"%s\"",secondNumber ,__PRETTY_FUNCTION__);
    }

    [sut addObject:thirdNumber];

    if (sut.tail.object != thirdNumber) {
        XCTFail(@"addObject Item %@ failed in \"%s\"",thirdNumber ,__PRETTY_FUNCTION__);
    }

}



- (void)testInsertObjectAtIndex {
    NSMutableArray *array = @[@1, @2, @3, @4, @5].mutableCopy;
    
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];
    
    NSNumber *middleNumber = @42;
    
    [array insertObject:middleNumber atIndex:3];
    [sut insertObject:middleNumber atIndex:3];
    
    if (array[3] != [sut objectAtIndex:3]) {
        XCTFail(@"insertObjectAtIndex Test Failed in \"%s\"", __PRETTY_FUNCTION__);
    }
    
    NSNumber *firstNumber = @102;
    
    [sut insertObject:firstNumber atIndex:0];
    
    XCTAssertTrue((sut[0] == firstNumber), @"Inserting object at index 0 failed! Object at index 0 is: %@", sut[0]);
    XCTAssertFalse((sut[1] == firstNumber), @"Inserting object at index 0 caused dup at index 1!");
}



- (void)testInsertObjectBeforeNode {
    NSMutableArray *array = @[@1, @2, @3, @4, @5].mutableCopy;

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    NSNumber *middleNumber = @42;

    BMDoublyLinkedListNode *beforeNode = [sut nodeAtIndex:3];

    [sut insertObject:middleNumber before:beforeNode];

    if (beforeNode.previous.object != middleNumber) {
        XCTFail(@"insertObject:before: test failed in \"%s\"", __PRETTY_FUNCTION__);
    } else if ([sut nodeAtIndex:3] != beforeNode.previous) {
        XCTFail(@"insertObject:before: test failed in \"%s\"", __PRETTY_FUNCTION__);
    } else if ([sut nodeAtIndex:4] != beforeNode) {
        XCTFail(@"insertObject:before: test failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testInsertObjectAfterNode {
    NSMutableArray *array = @[@1, @2, @3, @4, @5].mutableCopy;

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    NSNumber *middleNumber = @42;

    BMDoublyLinkedListNode *afterNode = [sut nodeAtIndex:3];

    [sut insertObject:middleNumber after:afterNode];

    if (afterNode.next.object != middleNumber) {
        XCTFail(@"insertObject:after: test failed in \"%s\"", __PRETTY_FUNCTION__);
    } else if ([sut nodeAtIndex:4] != afterNode.next) {
        XCTFail(@"insertObject:after: test failed in \"%s\"", __PRETTY_FUNCTION__);
    } else if ([sut nodeAtIndex:3] != afterNode) {
        XCTFail(@"insertObject:after: test failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}



#pragma mark - Removals
- (void)testPopFront {
    NSArray *array = @[@1, @2, @3, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    id poppedObject = [sut popFront];

    if (poppedObject != array[0]) {
        XCTFail(@"popFront failed to return head object in \"%s\"", __PRETTY_FUNCTION__);
    } else if (array.count - 1 != sut.count) {
        XCTFail(@"popFront failed to decrament count of list in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.head.object != array[1]) {
        XCTFail(@"popFront failed to set head object correctly in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.tail != sut.head.previous) {
        XCTFail(@"popFront failed to set preavious of head object correctly in \"%s\"", __PRETTY_FUNCTION__);
    } else if (![sut isOfSoundStructure]) {
        XCTFail(@"isOfSoundStructure failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testPopBack {
    NSArray *array = @[@1, @2, @3, @4, @5];

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    id poppedObject = [sut popBack];

    if (poppedObject != array[array.count - 1]) {
        XCTFail(@"popBack failed to return tail object in \"%s\"", __PRETTY_FUNCTION__);
    } else if (array.count - 1 != sut.count) {
        XCTFail(@"popBack failed to decrament count of list in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.tail.next != sut.head) {
        XCTFail(@"popBack failed to set head correctly in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.tail.object != array[array.count - 2]) {
        XCTFail(@"popBack failed to set tail object correctly in \"%s\"", __PRETTY_FUNCTION__);
    } else if (![sut isOfSoundStructure]) {
        XCTFail(@"isOfSoundStructure failed in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testRemoveObjectAtIndex {
    NSMutableArray *array = @[@1, @2, @3, @4, @5].mutableCopy;

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    [sut removeObjectAtIndex:2];
    [array removeObjectAtIndex:2];

    if (sut.count != array.count) {
        XCTFail(@"removeObjectAtIndex failed due to difference in count in \"%s\"", __PRETTY_FUNCTION__);
    } else if ([sut objectAtIndex:1] != [array objectAtIndex:1]) {
        XCTFail(@"removeObjectAtIndex failed due to difference in object at index:%i in \"%s\"",1,  __PRETTY_FUNCTION__);
    } else if ([sut objectAtIndex:2] != [array objectAtIndex:2]) {
        XCTFail(@"removeObjectAtIndex failed due to difference in object at index:%i in \"%s\"", 2, __PRETTY_FUNCTION__);
    }

    BMDoublyLinkedListNode *currentNode = sut.head;
    for (NSUInteger i = 0; i < sut.count; ++i) {
        if (currentNode.object != [array objectAtIndex:i]) {
            XCTFail(@"removeObjectAtIndex failed forward traversal at index:%i in \"%s\"",1,  __PRETTY_FUNCTION__);
        }

        currentNode = currentNode.next;
    }

    currentNode = sut.tail;
    for (NSUInteger i = array.count - 1; i < -1; --i) {
        if (currentNode.object != [array objectAtIndex:i]) {
            XCTFail(@"removeObjectAtIndex failed backwards traversal at index:%i in \"%s\"",1,  __PRETTY_FUNCTION__);
        }

        currentNode = currentNode.previous;
    }

}



- (void)testRemoveObject {
    NSNumber *numberToRemove = @7683;

    NSMutableArray *array = @[@1, @2, @3, numberToRemove, @4, @5].mutableCopy;

    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    [sut removeObject:numberToRemove];

    XCTAssertFalse([sut containsObject:numberToRemove], @"removeObject failed to remove object in \"%s\"", __PRETTY_FUNCTION__);

}




- (void)testEmptyList {
    NSArray *array = @[@1, @2, @3, @4, @5];
    
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];

    [sut emptyList];

    if (sut.head != nil) {
        XCTFail(@"emptyList failed to set the head to nil in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.tail != nil) {
        XCTFail(@"emptyList failed to set the tail to nil in \"%s\"", __PRETTY_FUNCTION__);
    } else if (sut.count != 0) {
        XCTFail(@"emptyList failed to set the count to 0 in \"%s\"", __PRETTY_FUNCTION__);
    }
}



- (void)testSortListUsingComparator {
    NSMutableArray *array = @[@1, @3, @9, @2, @8, @10, @11, @13, @4, @39, @6].mutableCopy;
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:array];
    
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    
    
    [sut sortListUsingComparator:^NSComparisonResult(id firstObject, id secondObject) {
        NSComparisonResult result = [firstObject compare:secondObject];
        return result;
    }];

    NSArray *sortedListAsArray = [sut arrayFromList];
    
    for (NSUInteger i = 0; i < sortedListAsArray.count; ++i) {
        NSNumber *arrayNumber = array[i];
        NSNumber *listNumber = sortedListAsArray[i];
        
        if ([arrayNumber compare:listNumber] != NSOrderedSame) {
            XCTFail(@"List Sorting did not work correctly. Index: %lu", (unsigned long)i);
        }
    }
}



- (void)testSubscripting {
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:@[
                                                                          @1, @2, @3, @4, @5
                                                                          ]];
    
    XCTAssertTrue(([(NSNumber *)sut[0] compare:@1] == NSOrderedSame), @"Index 0 should equal 1, insread sut[0] = %@", sut[0]);
    XCTAssertTrue(([(NSNumber *)sut[1] compare:@2] == NSOrderedSame), @"Index 1 should equal 2, insread sut[1] = %@", sut[1]);
    XCTAssertTrue(([(NSNumber *)sut[2] compare:@3] == NSOrderedSame), @"Index 2 should equal 3, insread sut[2] = %@", sut[2]);
    XCTAssertTrue(([(NSNumber *)sut[3] compare:@4] == NSOrderedSame), @"Index 3 should equal 4, insread sut[3] = %@", sut[3]);
    XCTAssertTrue(([(NSNumber *)sut[4] compare:@5] == NSOrderedSame), @"Index 4 should equal 5, insread sut[4] = %@", sut[4]);
    
    XCTAssertTrue(([(NSNumber *)sut[2] compare:@3] == NSOrderedSame), @"Index 2 should equal 3, insread sut[2] = %@", sut[2]);
    XCTAssertTrue(([(NSNumber *)sut[0] compare:@1] == NSOrderedSame), @"Index 0 should equal 1, insread sut[0] = %@", sut[0]);
    XCTAssertTrue(([(NSNumber *)sut[4] compare:@5] == NSOrderedSame), @"Index 4 should equal 5, insread sut[4] = %@", sut[4]);
    XCTAssertTrue(([(NSNumber *)sut[1] compare:@2] == NSOrderedSame), @"Index 1 should equal 2, insread sut[1] = %@", sut[1]);
    XCTAssertTrue(([(NSNumber *)sut[1] compare:@2] == NSOrderedSame), @"Index 1 should equal 2, insread sut[1] = %@", sut[1]);
}



- (void)testSubListFromRange {
    BMDoublyLinkedList *sut = [[BMDoublyLinkedList alloc] initFromArray:@[
                                                                          @1, @2, @3, @4, @5, @6, @7, @8, @9
                                                                          ]];
    NSUInteger location = 2;
    NSUInteger length = 4;
    
    BMDoublyLinkedList *subSut = [sut subListFromRange:NSMakeRange(location, length)];
    
    XCTAssertTrue((subSut.count == length), @"SubSut is not the correct length, should be: %lu, but is %lu", (unsigned long)length, (unsigned long)length);
    
    for (NSUInteger i = 0; i < length; ++i) {
        NSNumber *lN = sut[i + location];
        NSNumber *sN = subSut[i];
        
        XCTAssertTrue(([lN compare:sN] == NSOrderedSame), @"The subSut is not a sub List of sut. sut[%lu] = %@ subSut[%lu] = %@", (unsigned long) (i + location), lN, (unsigned long) i, sN);
    }
    
}

@end
