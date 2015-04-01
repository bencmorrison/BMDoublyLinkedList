//
//  BMDoublyLinkedList.m
//  BMDoublyLinkedList
//
//  Created by Benjamin Morrison on 6/11/14.
//  Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import "BMDoublyLinkedList.h"

NSString *const BMDoublyLinkedListOutOfBoundsException = @"BMLinkedListOutOfBoundsException";
NSString *const BMDoublyLinkedListConsistencyException = @"BMLinkedListConsistencyException";
NSString *const BMDoublyLinkedListObjectNotFoundException = @"BMLinkedListObjectNotFoundException";
NSString *const BMDoublyLinkedListNodeNotFoundException = @"BMLinkedListNodeNotFoundException";

NSString *const BMDoublyLinkedListExceptionDictionaryKeyCount = @"BMLinkedListExceptionDictionaryKeyCount";
NSString *const BMDoublyLinkedListExceptionDictionaryKeyTailObject = @"BMLinkedListExceptionDictionaryKeyTailObject";
NSString *const BMDoublyLinkedListExceptionDictionaryKeyHeadObject = @"BMLinkedListExceptionDictionaryKeyHeadObject";
NSString *const BMDoublyLinkedListExceptionDictionaryFailedSearchedForObject = @"BMLinkedListExceptionDictionaryFailedSearchedForObject";
NSString *const BMDoublyLinkedListExceptionDictionaryFailedSearchedForNode = @"BMLinkedListExceptionDictionaryFailedSearchedForNode";

static NSString *const BMDoublyLinkedListOutOfBoundsExceptionFormatString = @"Index (%lu) out of bounds of list count.";
static NSString *const BMDoublyLinkedListConsistencyExceptionMessage = @"List Consistency Issue. Head, Tail, and Count are not as expected";
static NSString *const BMDoublyLinkedListExceptionDictionaryFailedSearchedForObjectMessage = @"Object Not Found.";
static NSString *const BMDoublyLinkedListExceptionDictionaryFailedSearchedForNodeMessage = @"Node Not Found.";



@interface BMDoublyLinkedListNode ()

@property (nonatomic, strong, readwrite) BMDoublyLinkedListNode *next;
@property (nonatomic, strong, readwrite) BMDoublyLinkedListNode *previous;

@end


@implementation BMDoublyLinkedListNode

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        self.next = nil;
        self.previous = nil;
        
        self.object = nil;
    }
    
    return self;
}


- (instancetype)initWithObject:(id)anObject {
    self = [self init];
    
    if (self != nil) {
        self.object = anObject;
    }
    
    return self;
}


+ (instancetype)nodeFromObject:(id)anObject {
    return [[BMDoublyLinkedListNode alloc] initWithObject:anObject];
}

@end




@interface BMDoublyLinkedList ()

@property (atomic, assign, readwrite) NSUInteger count;
@property (atomic, strong, readwrite) BMDoublyLinkedListNode *head;
@property (atomic, strong, readwrite) BMDoublyLinkedListNode *tail;

- (BMDoublyLinkedListNode *)nodeByTraversingBackwards:(NSUInteger)timesBackwards timesFromNode:(BMDoublyLinkedListNode *)aNode;
- (BMDoublyLinkedListNode *)nodeByTraversingForward:(NSUInteger)timesForwards timesFromNode:(BMDoublyLinkedListNode *)aNode;

- (BOOL)shouldThrowConsistencyException;
- (void)swapNode:(BMDoublyLinkedListNode *)firstNode withNode:(BMDoublyLinkedListNode *)secondNode;

- (BMDoublyLinkedList *)mergeSortList:(BMDoublyLinkedList *)list withSorthComparator:(BMDoublyLinkedListSortComparatorBlock)sortBlock;
- (BMDoublyLinkedList *)mergeLeft:(BMDoublyLinkedList *)leftList andRightList:(BMDoublyLinkedList *)rightList withSortComparator:(BMDoublyLinkedListSortComparatorBlock)sortBlock;
- (NSString *)listAsString;

@end


@implementation BMDoublyLinkedList {
    NSUInteger speedIndex;
    BMDoublyLinkedListNode *speedNode;
}

#pragma mark - Initializers
- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        _count = 0;
        _head = nil;
        _tail = nil;
        
        speedIndex = 0;
        speedNode = nil;
        
    }
    
    return self;
}



- (instancetype)initFromArray:(NSArray *)array {
    self = [self init];
    
    if (self != nil) {
        for (id item in array) {
            [self pushBack:item];
        }
    }
    
    return self;
}



+ (instancetype)linkedList {
    return [[BMDoublyLinkedList alloc] init];
}



+ (instancetype)listFromArray:(NSArray *)array {
    return [[BMDoublyLinkedList alloc] initFromArray:array];
}



#pragma mark - Derived Data
- (BMDoublyLinkedList *)subListFromRange:(NSRange)range {
    NSUInteger location = range.location;

    BMDoublyLinkedListNode *node = [self nodeAtIndex:location];

    BMDoublyLinkedList *subList = [BMDoublyLinkedList new];

    NSUInteger rangeInserts = 0;
    while (rangeInserts < range.length) {
        [subList addObject:node.object];
        node = node.next;

        ++rangeInserts;
    }

    return subList;
}



#pragma mark - Inserting
- (void)pushFront:(id)anObject {
 
    if ([self shouldThrowConsistencyException]) {
        @throw [NSException exceptionWithName:BMDoublyLinkedListConsistencyException
                                       reason:BMDoublyLinkedListConsistencyExceptionMessage
                                     userInfo:@{
                                                BMDoublyLinkedListExceptionDictionaryKeyCount : @(self.count),
                                                BMDoublyLinkedListExceptionDictionaryKeyHeadObject : self.head,
                                                BMDoublyLinkedListExceptionDictionaryKeyTailObject : self.tail
                                                }];
    }
    
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    if (self.head == nil) {
        self.head = nodeToInsert;
        self.tail = nodeToInsert;
        
        nodeToInsert.next = nodeToInsert;
        nodeToInsert.previous = nodeToInsert;
        
        ++self.count;
        speedIndex = 0;
        speedNode = nil;
        
        return;
    }
    
    nodeToInsert.previous = self.tail;
    nodeToInsert.next = self.head;
    
    self.tail.next = nodeToInsert;
    self.head.previous = nodeToInsert;
    
    self.head = nodeToInsert;
    
    ++self.count;
    speedIndex = 0;
    speedNode = nil;
}



- (void)pushBack:(id)anObject {
    
    if ([self shouldThrowConsistencyException]) {
        @throw [NSException exceptionWithName:BMDoublyLinkedListConsistencyException
                                       reason:BMDoublyLinkedListConsistencyExceptionMessage
                                     userInfo:@{
                                                BMDoublyLinkedListExceptionDictionaryKeyCount : @(self.count),
                                                BMDoublyLinkedListExceptionDictionaryKeyHeadObject : self.head,
                                                BMDoublyLinkedListExceptionDictionaryKeyTailObject : self.tail
                                                }];
    }
    
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    if (self.tail == nil) {
        self.head = nodeToInsert;
        self.tail = nodeToInsert;
        
        nodeToInsert.next = nodeToInsert;
        nodeToInsert.previous = nodeToInsert;
        
        ++self.count;
        speedIndex = 0;
        speedNode = nil;
        
        return;
    }
    
    nodeToInsert.previous = self.tail;
    nodeToInsert.next = self.head;
    
    self.tail.next = nodeToInsert;
    self.head.previous = nodeToInsert;
    
    self.tail = nodeToInsert;
    
    ++self.count;
    speedIndex = 0;
    speedNode = nil;
}



- (void)addObject:(id)anObject {
    [self pushBack:anObject];
}



- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index == self.count) {
        [self pushBack:anObject];

    } else if (index == 0) {
        [self pushFront:anObject];
    
    } else {
        [self insertObject:anObject before:[self nodeAtIndex:index]];
    }
}



- (void)insertObject:(id)anObject before:(BMDoublyLinkedListNode *)beforeNode {
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    nodeToInsert.next = beforeNode;
    nodeToInsert.previous = beforeNode.previous;
    
    beforeNode.previous.next = nodeToInsert;
    beforeNode.previous = nodeToInsert;
    
    ++self.count;
    speedIndex = 0;
    speedNode = nil;
    
}



- (void)insertObject:(id)anObject after:(BMDoublyLinkedListNode *)afterNode {
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    nodeToInsert.previous = afterNode;
    nodeToInsert.next = afterNode.next;
    
    afterNode.next.previous = nodeToInsert;
    afterNode.next = nodeToInsert;
    
    ++self.count;
    speedIndex = 0;
    speedNode = nil;
}



- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    [self insertObject:anObject atIndex:index];
}



- (void)addObjectsFromList:(BMDoublyLinkedList *)list {
    if (list == nil) {
        return;
        
    } else if (list.count < 1) {
        return;
    }

    BMDoublyLinkedListNode *node = list.head;

    do {
        [self addObject:node.object];
        node = node.next;

    } while (node != list.head);
}



#pragma mark - Removers
- (id)popFront {
    if (self.count == 1) {
        self.count = 0;
        self.tail = nil;
        
        id objectToReturn = self.head.object;
        
        self.head.previous = nil;
        self.head.next = nil;
        self.head.object = nil;

        if (speedNode == self.head) {
            speedNode = nil;
            speedIndex = 0;
        }
        
        self.head = nil;
        
        return objectToReturn;
    }
    
    id objectToReturn = self.head.object;
    
    self.tail.next = self.head.next;
    self.head.next.previous = self.tail;
    
    self.head.next = nil;
    self.head.previous = nil;
    self.head.object = nil;
    
    self.head = self.tail.next;
    
    --self.count;
    speedIndex = 0;
    speedNode = nil;
    
    return objectToReturn;
}



-(id)popBack {
    if (self.count == 1) {
        return [self popFront];
    }
    
    id objectToReturn = self.tail.object;
    
    self.head.previous = self.tail.previous;
    self.tail.previous.next = self.head;
    
    self.tail.next = nil;
    self.tail.previous = nil;
    self.tail.object = nil;
    
    self.tail = self.head.previous;

    --self.count;
    speedIndex = 0;
    speedNode = nil;
    
    return objectToReturn;
}



- (id)removeObjectAtIndex:(NSUInteger)index {
    return [self removeNode:[self nodeAtIndex:index]];
}



- (id)removeObject:(id)anObject {
    BMDoublyLinkedListNode *nodeToDelete = [self nodeForObject:anObject];
    
    if (nodeToDelete == nil) {
        @throw [NSException exceptionWithName:BMDoublyLinkedListObjectNotFoundException
                                       reason:BMDoublyLinkedListExceptionDictionaryFailedSearchedForObjectMessage
                                     userInfo:@{
                                                BMDoublyLinkedListExceptionDictionaryFailedSearchedForObject : anObject
                                                }];
    }
    
    return [self removeNode:nodeToDelete];
}



- (id)removeNode:(BMDoublyLinkedListNode *)nodeToRemove {
    if (nodeToRemove == self.head) {
        return [self popFront];
    } else if (nodeToRemove == self.tail) {
        return [self popBack];
    }
    
    if (nodeToRemove.next.previous != nodeToRemove || nodeToRemove.previous.next != nodeToRemove) {
        @throw [NSException exceptionWithName:BMDoublyLinkedListObjectNotFoundException
                                       reason:BMDoublyLinkedListExceptionDictionaryFailedSearchedForObjectMessage
                                     userInfo:@{
                                                BMDoublyLinkedListExceptionDictionaryFailedSearchedForObject : nodeToRemove
                                                }];
    }
    
    id objectToReturn = nodeToRemove.object;
    
    nodeToRemove.previous.next = nodeToRemove.next;
    nodeToRemove.next.previous = nodeToRemove.previous;
    
    nodeToRemove.next = nil;
    nodeToRemove.previous = nil;
    nodeToRemove.object = nil;

    --self.count;
    speedIndex = 0;
    speedNode = nil;
    
    return objectToReturn;
}



- (void)emptyList {
    BMDoublyLinkedListNode *currentNode = self.head;
    BMDoublyLinkedListNode *next = self.head.next;
    
    do {
        currentNode.previous = nil;
        currentNode.next = nil;
        currentNode.object = nil;
        
        currentNode = next;
        next = next.next;
    } while (currentNode != nil);
    
    self.head = nil;
    self.tail = nil;
    self.count = 0;
    speedNode = nil;
    speedIndex = 0;
}




#pragma mark - Getter Methods
- (id)objectAtIndex:(NSUInteger)index {
    return [self nodeAtIndex:index].object;
}



- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}



- (BMDoublyLinkedListNode *)nodeAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        @throw [NSException exceptionWithName:BMDoublyLinkedListOutOfBoundsException
                                       reason:[NSString stringWithFormat:BMDoublyLinkedListOutOfBoundsExceptionFormatString, (unsigned long)index]
                                     userInfo:@{
                                                BMDoublyLinkedListExceptionDictionaryKeyCount : @(self.count)
                                                }];
        
    } else if (index == speedIndex && speedNode != nil) {
        return speedNode;
        
    } else if (index == (speedIndex - 1)  && speedNode != nil) {
        --speedIndex;
        speedNode = speedNode.previous;
        
        return speedNode;
    
    } else if (index == (speedIndex + 1) && speedNode != nil) {
        ++speedIndex;
        speedNode = speedNode.next;
        
        return speedNode;
    }

    
    // Is it better to start from Head and go forward?
    NSUInteger distanceFromHead = index;
    
    // Is it better to Start at Speed Index and go backwards?
    NSUInteger distanceFromSpeedNodeBackwards = speedIndex - index;
    
    // Is it better to Start at Speed Index and go forwards?
    NSUInteger distanceFromSpeedNodeForwards = index - speedIndex;
    
    // Is it better to Start at Tail and go backwards?
    NSUInteger distanceFromTail = self.count - index;
    
    
    if (distanceFromHead <= distanceFromSpeedNodeBackwards ||
        distanceFromHead <= distanceFromSpeedNodeForwards ||
        distanceFromHead <= distanceFromTail) {
        
        speedNode = [self nodeByTraversingForward:distanceFromHead timesFromNode:self.head];
        
    
    } else if (distanceFromSpeedNodeBackwards <= distanceFromSpeedNodeForwards ||
               distanceFromSpeedNodeBackwards <= distanceFromTail) {
        
        speedNode = [self nodeByTraversingBackwards:distanceFromSpeedNodeBackwards timesFromNode:speedNode];
        
    
    } else if (distanceFromSpeedNodeForwards <= distanceFromTail) {
        
        speedNode = [self nodeByTraversingForward:distanceFromSpeedNodeForwards timesFromNode:speedNode];
        
        
    } else {
        speedNode = [self nodeByTraversingBackwards:distanceFromTail timesFromNode:self.tail];
    }
    
    speedIndex = index;
    return speedNode;
}



- (BMDoublyLinkedListNode *)nodeForObject:(id)anObject {
    BMDoublyLinkedListNode *currentNode = self.head;
    
    do {
        if (currentNode.object == anObject) {
            return currentNode;
        }

        currentNode = currentNode.next;
        
    } while (currentNode != self.head);
    
    return nil;
}



- (NSArray *)arrayFromList {
    NSMutableArray *array = @[].mutableCopy;
    
    BMDoublyLinkedListNode *currentNode = self.head;
    
    do {
        [array addObject:currentNode.object];
        
        currentNode = currentNode.next;
        
    } while (currentNode != self.head);
    
    return array;
}



- (BOOL)containsObject:(id)anObject {
    BMDoublyLinkedListNode *retrievedObject = [self nodeForObject:anObject];

    return (retrievedObject.object == anObject);
}



- (BOOL)containsNode:(BMDoublyLinkedListNode *)aNode {
    for (BMDoublyLinkedListNode *node in self) {
        if (node == aNode) {
            return YES;
        }
    }
    
    return NO;
}



- (NSUInteger)indexForObject:(id)anObject {
    BMDoublyLinkedListNode *currentNode = self.head;
    NSUInteger currentIndex = 0;

    do {
        if (currentNode.object == anObject) {
            return currentIndex;
        }

        currentNode = currentNode.next;
        ++currentIndex;

    } while (currentNode != self.head && currentIndex < self.count);


    @throw [NSException exceptionWithName:BMDoublyLinkedListObjectNotFoundException
                                   reason:BMDoublyLinkedListExceptionDictionaryFailedSearchedForObjectMessage
                                 userInfo:@{
                                         BMDoublyLinkedListExceptionDictionaryFailedSearchedForObject : anObject
                                 }];
}



- (NSUInteger)indexForNode:(BMDoublyLinkedListNode *)aNode {
    BMDoublyLinkedListNode *currentNode = self.head;
    NSUInteger currentIndex = 0;

    do {
        if (currentNode == aNode) {
            return currentIndex;
        }

        currentNode = currentNode.next;
        ++currentIndex;

    } while (currentNode != self.head && currentIndex < self.count);


    @throw [NSException exceptionWithName:BMDoublyLinkedListNodeNotFoundException
                                   reason:BMDoublyLinkedListExceptionDictionaryFailedSearchedForNodeMessage
                                 userInfo:@{
                                         BMDoublyLinkedListExceptionDictionaryFailedSearchedForNode : aNode
                                 }];
}



- (BOOL)isOfSoundStructure {
    NSUInteger actualCountOfItemsForward = 0;
    NSUInteger actualCountOfItemsBackwards = 0;

    if (self.head == nil) {
        return NO;
    } else if (self.tail == nil) {
        return NO;
    } else if (self.head != nil && self.tail != nil && self.count == 0) {
        return NO;
    }

    BMDoublyLinkedListNode *currentNode = self.head;

    do {
        ++actualCountOfItemsForward;
        currentNode = currentNode.next;
    } while (actualCountOfItemsForward <= self.count && currentNode != self.head);

    if (actualCountOfItemsForward != self.count) {
        return NO;
    }

    currentNode = self.tail;

    do {
        ++actualCountOfItemsBackwards;
        currentNode = currentNode.previous;
    } while(actualCountOfItemsBackwards <= self.count && currentNode != self.tail);

    return actualCountOfItemsBackwards == self.count;

}




#pragma mark - Private Methods
- (BMDoublyLinkedListNode *)nodeByTraversingBackwards:(NSUInteger)timesBackward timesFromNode:(BMDoublyLinkedListNode *)aNode {
    
    BMDoublyLinkedListNode *currentNode = aNode;
    
    for (NSUInteger i = 0; i < timesBackward; ++i) {
        currentNode = currentNode.previous;
    }
    
    return currentNode;
}



- (BMDoublyLinkedListNode *)nodeByTraversingForward:(NSUInteger)timesForwards timesFromNode:(BMDoublyLinkedListNode *)aNode {
    
    BMDoublyLinkedListNode *currentNode = aNode;
    
    for (NSUInteger i = 0; i < timesForwards; ++i) {
        currentNode = currentNode.next;
    }
    
    return currentNode;
    
}


- (BOOL)shouldThrowConsistencyException {
    BOOL throwError = NO;
    
    throwError = throwError || (self.count == 0 && (self.head != nil || self.tail != nil));
    throwError = throwError || (self.count != 0 && (self.head == nil || self.tail == nil));
    
    return throwError;
}



- (void)swapNode:(BMDoublyLinkedListNode *)firstNode withNode:(BMDoublyLinkedListNode *)secondNode {
    firstNode.previous.next = secondNode;
    secondNode.previous.next = firstNode;

    BMDoublyLinkedListNode *tempNode = nil;
    tempNode = secondNode.previous;

    secondNode.previous = firstNode.previous;
    firstNode.previous = tempNode;

    firstNode.next.previous = secondNode;
    secondNode.next.previous = firstNode;

    tempNode = secondNode.next;

    secondNode.next = firstNode.next;
    firstNode.next = tempNode;

    if (self.head == firstNode) {
        self.head = secondNode;

    } else if (self.head == secondNode) {
        self.head = firstNode;
    }

    if (self.tail == firstNode) {
        self.tail = secondNode;

    } else if (self.tail == secondNode) {
        self.tail = firstNode;
    }
}



#pragma mark - Fast Enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    
    if (state->state == 0) {
        state->extra[0] = (unsigned long) self;
        state->extra[1] = (unsigned long) self.head;
        state->extra[2] = 0;
        state->mutationsPtr = &state->extra[0];
        
        state->state = 1;
    }
    
    
    NSUInteger totalIterated =state->extra[2];
    
    if (totalIterated >= self.count) {
        return 0;
    }
    
    
    void *uncastedNode = (void *)state->extra[1];
    BMDoublyLinkedListNode *currentNode = (__bridge BMDoublyLinkedListNode *)uncastedNode;
    
    
    NSUInteger totalAddedToBuffer = 0;
    state->itemsPtr = buffer;
    
    
    while ((totalIterated < self.count) && (totalAddedToBuffer < len)) {
        *buffer++ = currentNode;
        
        currentNode = currentNode.next;
        
        ++totalAddedToBuffer;
        ++totalIterated;
    }
    
    
    state->extra[1] = (unsigned long)currentNode.next;
    state->extra[2] = totalIterated;
    
    return totalAddedToBuffer;
    
}



#pragma mark - Sorting
- (void)sortListUsingComparator:(BMDoublyLinkedListSortComparatorBlock)sortComparatorBlock {
    BMDoublyLinkedList *sortedList = [self mergeSortList:self withSorthComparator:sortComparatorBlock];

    [self emptyList];

    self.head = sortedList.head;
    self.tail = sortedList.tail;
    self.count = sortedList.count;
}



#pragma mark - Sorting Support
- (BMDoublyLinkedList *)mergeSortList:(BMDoublyLinkedList *)list withSorthComparator:(BMDoublyLinkedListSortComparatorBlock)sortBlock {
    if (list.count < 2) {
        return list;
    }

    NSUInteger middle = list.count / 2;

    NSRange leftRange = NSMakeRange(0, middle);
    NSRange rightRange = NSMakeRange(middle, (list.count - middle));

    BMDoublyLinkedList *leftList = [list subListFromRange:leftRange];
    BMDoublyLinkedList *rightList = [list subListFromRange:rightRange];

    BMDoublyLinkedList *sortedList = [self mergeLeft:[self mergeSortList:leftList withSorthComparator:sortBlock]
                                        andRightList:[self mergeSortList:rightList withSorthComparator:sortBlock]
                                  withSortComparator:sortBlock];

    return sortedList;
}



- (BMDoublyLinkedList *)mergeLeft:(BMDoublyLinkedList *)leftList andRightList:(BMDoublyLinkedList *)rightList withSortComparator:(BMDoublyLinkedListSortComparatorBlock)sortBlock {
    BMDoublyLinkedList *resultList = [BMDoublyLinkedList new];
    NSUInteger leftIndex = 0;
    NSUInteger rightIndex = 0;

    while (leftIndex < leftList.count && rightIndex < rightList.count) {
        id object1 = [leftList objectAtIndex:leftIndex];
        id object2 = [rightList objectAtIndex:rightIndex];

        NSComparisonResult blockResult = sortBlock(object1, object2);

        if (blockResult == NSOrderedAscending) {
            [resultList pushBack:object1];
            ++leftIndex;

        } else if (blockResult == NSOrderedDescending) {
            [resultList pushBack:object2];
            ++rightIndex;

        } else /* blockResult == NSOrderedSame */ {
            [resultList pushBack:object2];
            ++rightIndex;
        }
    }

    NSRange leftRange = NSMakeRange(leftIndex, leftList.count - leftIndex);
    NSRange rightRange = NSMakeRange(rightIndex, rightList.count - rightIndex);

    BMDoublyLinkedList *subLeftList = nil;
    BMDoublyLinkedList *subRightList = nil;
    
    if (leftRange.location < leftList.count) {
        subLeftList = [leftList subListFromRange:leftRange];
    }
    
    if (rightRange.location < rightList.count) {
        subRightList = [rightList subListFromRange:rightRange];
    }

    [resultList addObjectsFromList:subLeftList];
    [resultList addObjectsFromList:subRightList];

    [leftList emptyList];
    [rightList emptyList];
    
    [subLeftList emptyList];
    [subRightList emptyList];
    
    return resultList;
}



#pragma mark - Stuffs
- (NSString *)listAsString {
    NSMutableString *string = @"".mutableCopy;
    
    for (BMDoublyLinkedListNode *n in self) {
        [string appendFormat:@"%@", n.object];
        if (n != self.tail) {
            [string appendString:@" <-> "];
        }
    }
    
    return string;
}


@end
