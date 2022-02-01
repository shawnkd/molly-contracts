pragma solidity ^0.8.0;

contract Factory {
    Token[] public tokens;

    event TokenMinted(address tokenOwner, string name, string symbol)

    function mintToken(string name, string symbol, string videoURL) external {
        Token token = new Token(name, symbol, tokenURL)
        tokens.push(token)
        emit TokenMinted(msg.sender, name, symbol)
    }
}