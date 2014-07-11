//
//  BMDoublyLinkedList.h
//  BMDoublyLinkedList
//
//  Created by Benjamin Morrison on 6/11/14.
//  Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BMDoublyLinkedListOutOfBoundsException;
extern NSString *const BMDoublyLinkedListConsistencyException;
extern NSString *const BMDoublyLinkedListObjectNotFoundException;
extern NSString *const BMDoublyLinkedListNodeNotFoundException;

extern NSString *const BMDoublyLinkedListExceptionDictionaryKeyCount;
extern NSString *const BMDoublyLinkedListExceptionDictionaryKeyTailObject;
extern NSString *const BMDoublyLinkedListExceptionDictionaryKeyHeadObject;
extern NSString *const BMDoublyLinkedListExceptionDictionaryFailedSearchedForObject;
extern NSString *const BMDoublyLinkedListExceptionDictionaryFailedSearchedForNode;


@interface BMDoublyLinkedListNode : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, readonly, getter = getNext) BMDoublyLinkedListNode *next;
@property (nonatomic, readonly, getter = getPrevious) BMDoublyLinkedListNode *previous;

- (instancetype)init;
- (instancetype)initWithObject:(id) anObject;
+ (instancetype)nodeFromObject:(id) anObject;

@end



@interface BMDoublyLinkedList : NSObject <NSFastEnumeration>

@property (atomic, assign, readonly) NSUInteger count;
@property (atomic, strong, readonly) BMDoublyLinkedListNode *head;
@property (atomic, strong, readonly) BMDoublyLinkedListNode *tail;

// Initializers
- (instancetype)init;
- (instancetype)initFromArray:(NSArray *)array;
+ (instancetype)linkedList;
+ (instancetype)listFromArray:(NSArray *)array;

// Inserters
- (void)pushFront:(id)anObject;
- (void)pushBack:(id)anObject;
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)insertObject:(id)anObject before:(BMDoublyLinkedListNode *)beforeNode;
- (void)insertObject:(id)anObject after:(BMDoublyLinkedListNode *)afterNode;

// Removers
- (id)popFront;
- (id)popBack;
- (id)removeObjectAtIndex:(NSUInteger)index;
- (id)removeObject:(id) anObject;
- (id)removeNode:(BMDoublyLinkedListNode *)nodeToRemove;
- (void)emptyList;

// Getters
- (id)objectAtIndex:(NSUInteger)index;
- (BMDoublyLinkedListNode *)nodeAtIndex:(NSUInteger)index;
- (BMDoublyLinkedListNode *)nodeForObject:(id)anObject;
- (NSArray *)arrayFromList;

// Queries
- (BOOL)containsObject:(id)anObject;
- (BOOL)containsNode:(BMDoublyLinkedListNode *)aNode;
- (NSUInteger)indexForObject:(id)anObject;
- (NSUInteger)indexForNode:(BMDoublyLinkedListNode *)aNode;
- (BOOL)isOfSoundStructure;



@end
