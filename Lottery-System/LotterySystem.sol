// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Lottery{
     address payable []public players;
     address public manager;

     event PlayerEntered(address indexed player,uint amount);
     event WinnerPicked(address indexed winner,uint prize);

     constructor(){
        manager=msg.sender;
     }
     modifier onlyManager() {
    require(msg.sender == manager, "Only manager can call this");
    _;
    }

     function enterLottery()public  payable {
        require(msg.value ==1 ether, "Entry fee is exactly 1 ETH");
        players.push(payable(msg.sender));
        emit PlayerEntered(msg.sender,msg.value);
     }

     function getBalance()public view returns (uint){
        return address(this).balance;
     }
     function getPlayers()public view returns (address payable[] memory){
        return  players;
     }


     // Generates a pseudo-random number (Not secure for production)
      function random() private view returns (uint) {
    return uint(
        keccak256(
            abi.encodePacked(
                block.timestamp,
                block.prevrandao,
                players.length
            )
        )
    );
}

        function pickWinner() public onlyManager {
        require(players.length >= 2, "At least 2 players are required");
        uint index=random()%players.length;
        uint prize = address(this).balance;

        (bool success, ) = players[index].call{value: prize}("");
        require(success, "Transfer failed");

        emit WinnerPicked(players[index], prize);
        players = new address payable[](0);
     }
 }

