pragma solidity ^0.8.0;

import "./Highlight.sol";

contract Factory {
    Highlight[] public highlights;
    


    function create(
        string memory _name,
        uint _maxSupply,
        uint  _royaltyPercentage,
        address _initialRoyaltiesReceiver,
        string memory _baseURI
    ) public {
        Highlight highlight = new Highlight(_name, _maxSupply, _royaltyPercentage, _initialRoyaltiesReceiver, _baseURI);
        highlights.push(highlight);
    }
}
