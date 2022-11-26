// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Lottery {
    uint public maxNoOfTickets; // maximum number of tickets in the lottery
    uint256 private ticketPrice = 0.01 ether; // base ticket price, which will be used later
    uint public noOfTickets; // no of present tickets in the system
    address public LotteryOwner; // the lottery owner address
    address[] public buyers; // list of lottery buyers 

    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    LOTTERY_STATE public lottery_state; // a structure to store state of the lottery rounds

    // constructor to set the lottery 
    constructor(uint _maxNoOfTickets, uint256 _ticketPriceinHundredthPowerEth){ 
        // you need at least 2 participants for a lottery system
        require(_maxNoOfTickets > 1, "Maximum number of tickets need to be 2 or more!"); 
        maxNoOfTickets = _maxNoOfTickets;
        ticketPrice = ticketPrice * _ticketPriceinHundredthPowerEth;
       // ticketPrice = _ticketPriceinHundredthPowerEth;
        LotteryOwner = msg.sender; // this is the lottery owner
        noOfTickets = 0;
        lottery_state = LOTTERY_STATE.OPEN; // setting the lottery to start state
    }

    
   // a function to get the ticket price in GWEI
    function getTicketPriceinGWEI() public view returns (uint){
        uint  test = ticketPrice / (10 ** 9);
        return (test);
    }

    // function to buy the tickets
    function buyTicket() public payable returns(string memory info) {
        require(lottery_state == LOTTERY_STATE.OPEN, "Lottery buyer intake is closed!"); // the state of the lottery must be open
        if(msg.value == ticketPrice && noOfTickets < maxNoOfTickets){
            require(msg.value == ticketPrice);
            buyers.push(payable(msg.sender));
            noOfTickets ++;
            if(noOfTickets == maxNoOfTickets){
                lottery_state = LOTTERY_STATE.CLOSED; // if limit is reached, lotter state is closed
            }
            return "You have bought a ticket!";
        }
        else if(msg.value != ticketPrice){ // if ticket price is not valid
            revert("Not meeting the ticket price criteria!");
        }
        else{
            revert("No more Tickets available!"); // if tickets are finished
        }
        
    }

    // function of the lottery owner to forcefully end the lottery round
    function endLottery() public payable returns (string memory info){
        require(msg.sender == LotteryOwner, "You are not Lottery owner, you cannot invoke this!"); // you have to be owner
        require(lottery_state == LOTTERY_STATE.OPEN, "Cannot end an already ended lottery round!");
        if(noOfTickets < 2){
            revert("Cannot end lottery with less than two tickets!");
        }
        else{
            lottery_state = LOTTERY_STATE.CLOSED;
            return "Sucessfully closing this lottery state!";
        }
    }


    // random function to get a random hashcode using block timestamp, difficulty, account balance
    function select_rand() private view returns(uint){
        return  uint (keccak256(abi.encode(block.timestamp, block.difficulty, address(this).balance, buyers)));
    }

    // function that gets the winner
    function getWinner() public payable returns (address){
        // lottery has to finish getting tickets first
        require(lottery_state == LOTTERY_STATE.CLOSED, "Lottery has not finished getting maximum tickets");
        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
        // have to be lotter owner to invoke this
        require(msg.sender == LotteryOwner, "You are not Lottery owner, you cannot invoke this!");
        // selecting a random address
        uint winner_address = select_rand() % buyers.length;

        address temp = buyers[winner_address]; // address of the winner

        uint amount = (noOfTickets * ticketPrice) -  (1*ticketPrice); // amount that the winner will get

        payable (buyers[winner_address]).transfer(amount); // sending the amount to the winner
        //resetting the lottery and starts new lottery round
        buyers = new address[](0);
        noOfTickets = 0;
        lottery_state = LOTTERY_STATE.OPEN;
        //string toPrint = "The winner of the lotter is : " + abi.encodePacked(temp);
        return (temp); // returning the winning address
        
    }


    
}
