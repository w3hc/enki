// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Enki is Ownable {
    constructor(
        address initialOwner, // must be a Governor contract address
        string memory _text,
        string memory _cid
    ) Ownable(initialOwner) {
        text = _text;
        cid = _cid;
    }

    string public text;
    string public cid;

    mapping(string => string) public logs;

    function read() public {
        // returns the value of text
    }

    function write() public onlyOwner {
        /*

        - update the value of text
        - update the value of cid
        - update the logs mapping with the new values

        */
    }

    function verify(string calldata _text) public {
        // checks if the value of text is equal to _text
        // if yes, return true
    }
}
