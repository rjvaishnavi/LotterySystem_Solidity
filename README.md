# Lottery System Using Solidity
This .sol code creates a smart contract.\
The lottery owner initiate the contract and set up a lottery system.

#### States of the Lottery System
The lottery system has 3 states:
- OPEN: Which denotes that the lottery system is active, and takes in buying tickets
- CLOSED: Which denotes that the lottery system is closed for ticket sales
- CALCULATING_WINNER: Which denotes that the lottery system is calculating the winner of the lottery

#### No of Tickets
The owner also initiates the no of maximum tickets for the system. \
The maximum number of tickets must be more than 1.\
So there needs to be a minimum of 2 tickets at a time.\
The owner also sets the price of the ticket as multiples of 0.01 ethers\
So if the owner submits 2 as a value for the ticketPrice, the ticketPrice would actually be 0.02 ether.

#### Buying a ticket
Any one with a valid address can buy a ticket for the system, as long as they give a value equal to the ticketPrice.\
If the maximum no of tickets have been reached, then you cannot buy any ticket. \
If the system is CLOSED state or CALCULATING_WINNER state, then you cannot buy any tickets\.
Once the max no of tickets have been reached, then the state is changed from OPEN to CLOSED.

#### Closing Lottery system
Without reaching the default max limit of tickets, the lottery owner can close the system.\
But the minimum no of tickets bought must be 2 for this to be invoked.

#### Calculating winner
Only the lottery owner can invoke this message.\
Only if the lottery state is closed, can we invoke this message.\
The lottery state is set to CALCULATING_WINNER and using a randomiser function.\
The winner is sent the winning amount of the lottery, which is equal to (no. of tickets * ticket price) - ( 1 * ticket price).\
The lottery system is reset.\
The lottery state is set to OPEN again.
