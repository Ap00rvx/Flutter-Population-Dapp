// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13; 
contract Population {
    uint public population ;
    string public countryName ;

    constructor() {
        population = 0 ; 
        countryName = "" ;
    }

    function setName(string memory _name, uint _population )public {
        countryName = _name ;
        population = _population ;
    }
    function decrement(uint amount)public {
        require(amount <= population, "Population cannot be decremented below 0");
        population -= amount ;
    }
    function increment(uint amount)public {
        population += amount ;
    }

}