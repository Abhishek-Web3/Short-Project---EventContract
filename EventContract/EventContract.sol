// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
 

 contract EventContract {
    struct Event {
        address orgnizer;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint tickteremain;
    }

    mapping(uint => Event) public events;

    mapping(address => mapping(uint => uint)) public tickets;

    uint public nextId;


    function createEvent(string memory name, uint date, uint price, uint ticketcount) external{
        require(date>block.timestamp, "you can orgnise for future date"); // unix time stamp - https://www.unixtimestamp.com/
        require(ticketcount>0, "ticket count should be greater than 0 ");

        events[nextId] = Event(msg.sender, name,date, price, ticketcount, ticketcount);
        nextId++;

    }

    function buyTicket(uint id, uint quantity) external payable {
        require(events[id].date!=0, "this event does't exists");
        require(events[id].date > block.timestamp, "Event Nit Existing");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity), "Ether is not enough for purchase the ticket");
        require(_event.tickteremain >= quantity,"Not Enough Ticket");
        _event.tickteremain = quantity;

        tickets[msg.sender][id]+=quantity;
    }

    function transeferTicket(uint eventId, uint quantity, address to) external  {
        require(events[eventId].date!=0, "this event does't exists");
        require(events[eventId].date > block.timestamp, "Event Nit Existing");
        require(tickets[msg.sender][eventId] >= quantity, "You do not have enough tickets");

        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId] += quantity;
    }   

 }