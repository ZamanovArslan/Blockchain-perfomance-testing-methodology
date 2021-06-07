pragma solidity >=0.4.16 <0.9.0;

contract Hello {
   string message;

   constructor() public {

   message = "Hello, World";

   }
   function getGreetings() public view returns (string memory)
   {
     return message;
   }
   function setGreetings(string memory _message) public{
     message = _message;
   }

}
