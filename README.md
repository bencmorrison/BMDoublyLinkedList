BMDoublyLinkedList
==================

BMDoublyLinkedList is a Doubly Linked List that is also Looped.

###About
BMDoublyLinkedList is different from other Objective-C linked lists due to the most common setup not being used for the nodes of a list. In most implementations you will find that the nodes of a linked list comprise primarily of c structs. While c structs work beautifully they can have a few side affects. One issue is that ARC can and often will have a hard time managing the objects held within the struct as they grow complex and the objects contained within grow in complexity. A second issue is that a c struct cannot protect it's node's head and tail pointers. This could cause issues of accedental overwriting of a pointer to the next node. Moving to Objective-C constructs allowed BMDoublyLinkedList to not have to hold ARC's hand in certain cituations and protect vital components of the list from being messed up on accendent.

###Project
Currently the project commited is an Xcode framework project. Primarily to allow unit tests to be setup to test the project. If you do build the project under iOS Device it will create a dot a file for you to use as well.


###Using in your project
1. Under the BMLinkedList folder you will find the header and dot m file you will need
2. Import these files into your project.
3. Add #import "BMDoublyLinkedList.h" to your files where you need to use the list.
3.5. (Optional) You could add the import to your .pch for access accross the whole project.


###List Highlights
1. List is Doubly Linked
2. Head points to the first node in the list. The first node is defined as index 0 and node's previous is the tail node.
3. Tail points to the last node in the list. The last node is defined as index count - 1 and node's next is the head node.
4. List supports Fast Enumeration


