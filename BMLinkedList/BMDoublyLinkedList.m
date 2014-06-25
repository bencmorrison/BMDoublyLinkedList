//
//  BMDoublyLinkedList.m
//  BMDoublyLinkedList
//
//  Created by Benjamin Morrison on 6/11/14.
//  Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDoublyLinkedList.h"

NSString *const BMLinkedListOutOfBoundsException = @"BMLinkedListOutOfBoundsException";
NSString *const BMLinkedListConsistencyException = @"BMLinkedListConsistencyException";
NSString *const BMLinkedListObjectNotFoundException = @"BMLinkedListObjectNotFoundException";
NSString *const BMLinkedListNodeNotFoundException = @"BMLinkedListNodeNotFoundException";

NSString *const BMLinkedListExceptionDictionaryKeyCount = @"BMLinkedListExceptionDictionaryKeyCount";
NSString *const BMLinkedListExceptionDictionaryKeyTailObject = @"BMLinkedListExceptionDictionaryKeyTailObject";
NSString *const BMLinkedListExceptionDictionaryKeyHeadObject = @"BMLinkedListExceptionDictionaryKeyHeadObject";
NSString *const BMLinkedListExceptionDictionaryFailedSearchedForObject = @"BMLinkedListExceptionDictionaryFailedSearchedForObject";
NSString *const BMLinkedListExceptionDictionaryFailedSearchedForNode = @"BMLinkedListExceptionDictionaryFailedSearchedForNode";

static NSString *const BMLinkedListOutOfBoundsExceptionFormatString = @"Index (%s) out of bounds of list count.";
static NSString *const BMLinkedListConsistencyExceptionMessage = @"List Consistency Issue. Head, Tail, and Count are not as expected";
static NSString *const BMLinkedListExceptionDictionaryFailedSearchedForObjectMessage = @"Object Not Found.";
static NSString *const BMLinkedListExceptionDictionaryFailedSearchedForNodeMessage = @"Node Not Found.";



@interface BMDoublyLinkedListNode ()

@property (nonatomic, strong) BMDoublyLinkedListNode *nextNode;
@property (nonatomic, strong) BMDoublyLinkedListNode *previousNode;

@end


@implementation BMDoublyLinkedListNode

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        self.nextNode = nil;
        self.previousNode = nil;
        
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


- (BMDoublyLinkedListNode *)getNext {
    return self.nextNode;
}


- (BMDoublyLinkedListNode *)getPrevious {
    return self.previousNode;
}

@end






@interface BMDoublyLinkedList ()

- (BMDoublyLinkedListNode *)nodeByTraversingBackwards:(NSUInteger)timesBackwards timesFromNode:(BMDoublyLinkedListNode *)aNode;
- (BMDoublyLinkedListNode *)nodeByTraversingForward:(NSUInteger)timesFowards timesFromNode:(BMDoublyLinkedListNode *)aNode;

- (BOOL)shouldThrowConsistencyException;

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



+ (instancetype)listFronArray:(NSArray *)array {
    return [[BMDoublyLinkedList alloc] initFromArray:array];
}


#pragma mark - Inserting
- (void)pushFront:(id)anObject {
 
    if ([self shouldThrowConsistencyException]) {
        @throw [NSException exceptionWithName:BMLinkedListConsistencyException
                                       reason:BMLinkedListConsistencyExceptionMessage
                                     userInfo:@{
                                                BMLinkedListExceptionDictionaryKeyCount : [NSNumber numberWithUnsignedLongLong:self.count],
                                                BMLinkedListExceptionDictionaryKeyHeadObject : _head,
                                                BMLinkedListExceptionDictionaryKeyTailObject : _tail
                                                }];
    }
    
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    if (_head == nil) {
        _head = nodeToInsert;
        _tail = nodeToInsert;
        
        nodeToInsert.nextNode = nodeToInsert;
        nodeToInsert.previousNode = nodeToInsert;
        
        ++_count;
        speedIndex = 0;
        speedNode = nil;
        
        return;
    }
    
    nodeToInsert.previousNode = _tail;
    nodeToInsert.nextNode = _head;
    
    _tail.nextNode = nodeToInsert;
    _head.previousNode = nodeToInsert;
    
    _head = nodeToInsert;
    
    ++_count;
    speedIndex = 0;
    speedNode = nil;
}



- (void)pushBack:(id)anObject {
    
    if ([self shouldThrowConsistencyException]) {
        @throw [NSException exceptionWithName:BMLinkedListConsistencyException
                                       reason:BMLinkedListConsistencyExceptionMessage
                                     userInfo:@{
                                                BMLinkedListExceptionDictionaryKeyCount : [NSNumber numberWithUnsignedLongLong:self.count],
                                                BMLinkedListExceptionDictionaryKeyHeadObject : _head,
                                                BMLinkedListExceptionDictionaryKeyTailObject : _tail
                                                }];
    }
    
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    if (_tail == nil) {
        _head = nodeToInsert;
        _tail = nodeToInsert;
        
        nodeToInsert.nextNode = nodeToInsert;
        nodeToInsert.previousNode = nodeToInsert;
        
        ++_count;
        speedIndex = 0;
        speedNode = nil;
        
        return;
    }
    
    nodeToInsert.previousNode = _tail;
    nodeToInsert.nextNode = _head;
    
    _tail.nextNode = nodeToInsert;
    _head.previousNode = nodeToInsert;
    
    _tail = nodeToInsert;
    
    ++_count;
    speedIndex = 0;
    speedNode = nil;
}



- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index == _count) {
        [self pushBack:anObject];
    } else if (index == 0) {
        [self pushFront:anObject];
    }
    
    [self insertObject:anObject before:[self nodeAtIndex:index]];
}



- (void)insertObject:(id)anObject before:(BMDoublyLinkedListNode *)beforeNode {
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    nodeToInsert.nextNode = beforeNode;
    nodeToInsert.previousNode = beforeNode.previous;
    
    beforeNode.previous.nextNode = nodeToInsert;
    beforeNode.previousNode = nodeToInsert;
    
    ++_count;
    speedIndex = 0;
    speedNode = nil;
    
}



- (void)insertObject:(id)anObject after:(BMDoublyLinkedListNode *)afterNode {
    BMDoublyLinkedListNode *nodeToInsert = [BMDoublyLinkedListNode nodeFromObject:anObject];
    
    nodeToInsert.previousNode = afterNode;
    nodeToInsert.nextNode = afterNode.nextNode;
    
    afterNode.next.previousNode = nodeToInsert;
    afterNode.nextNode = nodeToInsert;
    
    ++_count;
    speedIndex = 0;
    speedNode = nil;
}



#pragma mark - Removers
- (id)popFront {
    if (_count == 1) {
        _count = 0;
        _tail = nil;
        
        id objectToReturn = _head.object;
        
        _head.previousNode = nil;
        _head.nextNode = nil;
        _head.object = nil;
        
        _head = nil;
        
        return objectToReturn;
    }
    
    id objectToReturn = _head.object;
    
    _tail.nextNode = _head.next;
    _head.next.previousNode = _tail;
    
    _head.nextNode = nil;
    _head.previousNode = nil;
    _head.object = nil;
    
    _head = _tail.next;
    
    --_count;
    speedIndex = 0;
    speedNode = nil;
    
    return objectToReturn;
}



-(id)popBack {
    if (_count == 1) {
        return [self popFront];
    }
    
    id objectToReturn = _tail.object;
    
    _head.previousNode = _tail.previous;
    _tail.previous.nextNode = _head;
    
    _tail.nextNode = nil;
    _tail.previousNode = nil;
    _tail.object = nil;
    
    _tail = _head.previous;

    --_count;
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
        @throw [NSException exceptionWithName:BMLinkedListObjectNotFoundException
                                       reason:BMLinkedListExceptionDictionaryFailedSearchedForObjectMessage
                                     userInfo:@{
                                                BMLinkedListExceptionDictionaryFailedSearchedForObject : anObject
                                                }];
    }
    
    return [self removeNode:nodeToDelete];
}



- (id)removeNode:(BMDoublyLinkedListNode *)nodeToRemove {
    if (nodeToRemove == _head) {
        return [self popFront];
    } else if (nodeToRemove == _tail) {
        return [self popBack];
    }
    
    if (nodeToRemove.next.previous != nodeToRemove || nodeToRemove.previous.next != nodeToRemove) {
        @throw [NSException exceptionWithName:BMLinkedListObjectNotFoundException
                                       reason:BMLinkedListExceptionDictionaryFailedSearchedForObjectMessage
                                     userInfo:@{
                                                BMLinkedListExceptionDictionaryFailedSearchedForObject : nodeToRemove
                                                }];
    }
    
    id objectToReturn = nodeToRemove.object;
    
    nodeToRemove.previous.nextNode = nodeToRemove.next;
    nodeToRemove.next.previousNode = nodeToRemove.previous;
    
    nodeToRemove.nextNode = nil;
    nodeToRemove.previousNode = nil;
    nodeToRemove.object = nil;

    --_count;
    speedIndex = 0;
    speedNode = nil;
    
    return objectToReturn;
}



- (void)emptyList {
    BMDoublyLinkedListNode *currentNode = _head;
    BMDoublyLinkedListNode *nextNode = _head.next;
    
    do {
        currentNode.previousNode = nil;
        currentNode.nextNode = nil;
        currentNode.object = nil;
        
        currentNode = nextNode;
        nextNode = nextNode.nextNode;
    } while (currentNode != nil);
    
    _head = nil;
    _tail = nil;
    _count = 0;
    speedNode = nil;
    speedIndex = 0;
}




#pragma mark - Getter Methods
- (id)objectAtIndex:(NSUInteger)index {
    return [self nodeAtIndex:index].object;
}



- (BMDoublyLinkedListNode *)nodeAtIndex:(NSUInteger)index {
    
    if (index >= _count) {
        @throw [NSException exceptionWithName:BMLinkedListOutOfBoundsException
                                       reason:[NSString stringWithFormat:BMLinkedListOutOfBoundsExceptionFormatString, index]
                                     userInfo:@{
                                                BMLinkedListExceptionDictionaryKeyCount : [NSNumber numberWithUnsignedLongLong:self.count]
                                                }];
        
    } else if (index == speedIndex && speedNode != nil) {
        return speedNode;
        
    } else if (index == (speedIndex - 1)  && speedNode != nil) {
        --speedIndex;
        speedNode = speedNode.previousNode;
        
        return speedNode;
    
    } else if (index == (speedIndex + 1) && speedNode != nil) {
        ++speedIndex;
        speedNode = speedNode.nextNode;
        
        return speedNode;
    }

    
    // Is it better to start from Head and go forward?
    NSUInteger distanceFromHead = index;
    
    // Is it better to Start at Speed Index and go backwards?
    NSUInteger distanceFromSpeedNodeBackwards = speedIndex - index;
    
    // Is it better to Start at Speed Index and go forwards?
    NSUInteger distanceFromSpeedNodeForwards = index - speedIndex;
    
    // Is it better to Start at Tail and go backwards?
    NSUInteger distanceFromTail = _count - index;
    
    
    if (distanceFromHead <= distanceFromSpeedNodeBackwards ||
        distanceFromHead <= distanceFromSpeedNodeForwards ||
        distanceFromHead <= distanceFromTail) {
        
        speedNode = [self nodeByTraversingForward:distanceFromHead timesFromNode:_head];
        
    
    } else if (distanceFromSpeedNodeBackwards <= distanceFromSpeedNodeForwards ||
               distanceFromSpeedNodeBackwards <= distanceFromTail) {
        
        speedNode = [self nodeByTraversingBackwards:distanceFromSpeedNodeBackwards timesFromNode:speedNode];
        
    
    } else if (distanceFromSpeedNodeForwards <= distanceFromTail) {
        
        speedNode = [self nodeByTraversingForward:distanceFromSpeedNodeForwards timesFromNode:speedNode];
        
        
    } else {
        speedNode = [self nodeByTraversingBackwards:distanceFromTail timesFromNode:_tail];
    }
    
    speedIndex = index;
    return speedNode;
}



- (BMDoublyLinkedListNode *)nodeForObject:(id)anObject {
    BMDoublyLinkedListNode *currentNode = _head;
    
    do {
        if (currentNode.object == anObject) {
            return currentNode;
        }

        currentNode = currentNode.next;
        
    } while (currentNode != _head);
    
    return nil;
}



- (NSArray *)arrayFromList {
    NSMutableArray *array = @[].mutableCopy;
    
    BMDoublyLinkedListNode *currentNode = _head;
    
    do {
        [array addObject:currentNode.object];
        
        currentNode = currentNode.next;
        
    } while (currentNode != _head);
    
    return array;
}



- (BOOL)containsObject:(id)anObject {
    BMDoublyLinkedListNode *retrevedObject = [self nodeForObject:anObject];
    
    if (retrevedObject != nil) {
        return (retrevedObject.object == anObject);
    }
    
    return NO;
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
    BMDoublyLinkedListNode *currentNode = _head;
    NSUInteger currentIndex = 0;

    do {
        if (currentNode.object == anObject) {
            return currentIndex;
        }

        currentNode = currentNode.next;
        ++currentIndex;

    } while (currentNode != _head && currentIndex < _count);


    @throw [NSException exceptionWithName:BMLinkedListObjectNotFoundException
                                   reason:BMLinkedListExceptionDictionaryFailedSearchedForObjectMessage
                                 userInfo:@{
                                         BMLinkedListExceptionDictionaryFailedSearchedForObject : anObject
                                 }];
}



- (NSUInteger)indexForNode:(BMDoublyLinkedListNode *)aNode {
    BMDoublyLinkedListNode *currentNode = _head;
    NSUInteger currentIndex = 0;

    do {
        if (currentNode == aNode) {
            return currentIndex;
        }

        currentNode = currentNode.next;
        ++currentIndex;

    } while (currentNode != _head && currentIndex < _count);


    @throw [NSException exceptionWithName:BMLinkedListNodeNotFoundException
                                   reason:BMLinkedListExceptionDictionaryFailedSearchedForNodeMessage
                                 userInfo:@{
                                         BMLinkedListExceptionDictionaryFailedSearchedForNode : aNode
                                 }];
}



- (BOOL)isOfSoundStructure {
    NSUInteger actualCountOfItemsForward = 0;
    NSUInteger actualCountOfItemsBackwards = 0;

    if (self.head == nil) {
        return NO;
    } else if (self.tail == nil) {
        return NO;
    } else if (self.head != nil && self.tail != nil && _count == 0) {
        return NO;
    }

    BMDoublyLinkedListNode *currentNode = self.head;

    do {
        ++actualCountOfItemsForward;
        currentNode = currentNode.next;
    } while (actualCountOfItemsForward <= _count && currentNode != self.head);

    if (actualCountOfItemsForward != _count) {
        return NO;
    }

    currentNode = self.tail;

    do {
        ++actualCountOfItemsBackwards;
        currentNode = currentNode.previous;
    } while(actualCountOfItemsBackwards <= _count && currentNode != self.tail);

    if (actualCountOfItemsBackwards != _count) {
        return NO;
    }

    return YES;
}




#pragma mark - Private Methods
- (BMDoublyLinkedListNode *)nodeByTraversingBackwards:(NSUInteger)timesBackward timesFromNode:(BMDoublyLinkedListNode *)aNode {
    
    BMDoublyLinkedListNode *currentNode = aNode;
    
    for (NSUInteger i = 0; i < timesBackward; ++i) {
        currentNode = currentNode.previousNode;
    }
    
    return currentNode;
}



- (BMDoublyLinkedListNode *)nodeByTraversingForward:(NSUInteger)timesFoward timesFromNode:(BMDoublyLinkedListNode *)aNode {
    
    BMDoublyLinkedListNode *currentNode = aNode;
    
    for (NSUInteger i = 0; i < timesFoward; ++i) {
        currentNode = currentNode.nextNode;
    }
    
    return currentNode;
    
}


- (BOOL)shouldThrowConsistencyException {
    BOOL throwError = NO;
    
    throwError = throwError || (_count == 0 && (_head != nil || _tail != nil));
    throwError = throwError || (_count != 0 && (_head == nil || _tail == nil));
    
    return throwError;
}



#pragma mark - Fast Enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    
    if (state->state == 0) {
        state->extra[0] = (unsigned long) self;
        state->extra[1] = (unsigned long) _head;
        state->extra[2] = 0;
        state->mutationsPtr = &state->extra[0];
        
        state->state = 1;
    }
    
    
    NSUInteger totalIterated =state->extra[2];
    
    if (totalIterated >= _count) {
        return 0;
    }
    
    
    void *uncastedNode = (void *)state->extra[1];
    BMDoublyLinkedListNode *currentNode = (__bridge BMDoublyLinkedListNode *)uncastedNode;
    
    
    NSUInteger totalAddedToBuffer = 0;
    state->itemsPtr = buffer;
    
    
    while ((totalIterated < _count) && (totalAddedToBuffer < len)) {
        *buffer++ = currentNode;
        
        currentNode = currentNode.next;
        
        ++totalAddedToBuffer;
        ++totalIterated;
    }
    
    
    state->extra[1] = (unsigned long)currentNode.next;
    state->extra[2] = totalIterated;
    
    return totalAddedToBuffer;
    
}


@end
