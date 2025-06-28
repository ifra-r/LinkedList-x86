## linkedlist-x86
A linked list implementation in x86 assembly (real mode, DOS). Demonstrates core linked list operations like insertion, deletion, traversal, and reversal using low-level memory and pointer management.

## Node Structure (Assembly View)

Each node in the linked list is structured as a block of memory with pointers to the previous and next nodes, followed by stored values of key CPU registers.  
This gives a low-level, register-aware view of data per node.

# Linked List Functions (in x86 Assembly)

This file contains implementations of core linked list operations in x86 assembly, including:

- `insertAtFirst` – Insert node at beginning
- `insertAtEnd` – Insert node at end
- `delAtFirst` – Delete node at beginning
- `delAtEnd` – Delete node at end
- `size` – Get size of the list
- `isEmpty` – Check if list is empty
- `sasta_print` – Basic list print function (prints only the values of ax, made just to make testing easy)
- `createNode` – Allocate and initialize a new node
- `isValidPosToInsert` – Check if position is valid for insertion
- `getPrev_n_NextNode` – Get previous and next node at a given position
- `PrintNode` – Print a single node
- `insertAtPos` – Insert node at a specific position
- `getNodeAtPos` – Retrieve node at a position
- `delAtPos` – Delete node at a position
- `reverseList` – Reverse the linked list
- `isValidPosToDel` – Check if position is valid for deletion (commented out)
- `print_null` – Print a null/empty node indicator
- `print_arrow` – Print an arrow (used in traversal display)
- `print_hex` – Print data in hex format
- `clrscr` – Clear the screen

> All functions interact with a dynamically allocated linked list in memory and demonstrate low-level pointer manipulation in assembly. 

