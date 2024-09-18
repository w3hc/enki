// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Enki Contract
/// @author Julien Béranger
/// @notice This contract manages text and CID storage with owner-only write access
/// @dev Inherits from OpenZeppelin's Ownable contract for access control
contract Enki is Ownable {
    /// @notice Emitted when the text and CID are updated
    /// @param newText New text that was stored
    /// @param newCID New CID that was stored
    event Updated(string indexed newText, string indexed newCID);

    /// @notice Stores the main text contents
    string public text;

    /// @notice Stores the Content Identifier (CID)
    string public cid;

    /// @notice Initializes the contract with an owner, initial text, and CID
    /// @dev The initial owner should be a Governor contract address
    /// @param initialOwner Address of the initial owner (Governor contract)
    /// @param _text Initial text to be stored
    /// @param _cid Initial CID to be stored
    constructor(
        address initialOwner,
        string memory _text,
        string memory _cid
    ) Ownable(initialOwner) {
        text = _text;
        cid = _cid;
    }

    /// @notice Retrieves the current stored text
    /// @return The current value of the text variable
    function read() public view returns (string memory) {
        return text;
    }

    /// @notice Updates the stored text and CID
    /// @dev Only the contract owner can call this function
    /// @param _newText New text to be stored
    /// @param _newCID New CID to be stored
    function write(string calldata _newText, string calldata _newCID) public onlyOwner {
        text = _newText;
        cid = _newCID;
        emit Updated(_newText, _newCID);
    }

    /// @notice Verifies if the provided text matches the stored text
    /// @param _text Text to compare against the stored text
    /// @return Boolean indicating whether the provided text matches the stored text
    function verify(string calldata _text) public view returns (bool) {
        return keccak256(abi.encodePacked(text)) == keccak256(abi.encodePacked(_text));
    }
}
