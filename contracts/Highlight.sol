pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Highlight is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {

    // Maximum amounts of mintable tokens
    uint256 public maxSupply;

    //royalty percentage
    uint256 public royaltiesPercentage;

    // Address of the royalties recipient
    address private _royaltiesReceiver;

    // Keep a mapping of token ids and corresponding IPFS hashes
    mapping(string => uint8) hashes;

    //Events
    event Mint(uint256 tokenId, address recipient);

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    constructor(
        string memory _name,
        uint _maxSupply,
        uint _royaltiesPercentage,
        address _initialRoyaltiesReceiver,
        string memory _baseURI
    ) public payable ERC721(_name, "MOLLY") {
        maxSupply = _maxSupply;
        _royaltiesReceiver = _initialRoyaltiesReceiver;
        royaltiesPercentage = _royaltiesPercentage;

        
    }

    /// @notice Mints tokens
    /// @param recipient - the address to which the token will be transfered
    /// @param hash - the IPFS hash of the token's resource
    /// @return tokenId - the id of the token
    function mint(address recipient, string memory hash)
    external onlyOwner
    returns (uint256 tokenId)
    {
        require(totalSupply() <= maxSupply, "All tokens minted");
        require(bytes(hash).length > 0); // dev: Hash can not be empty!
        require(hashes[hash] != 1); // dev: Can't use the same hash twice
        hashes[hash] = 1;
        uint256 newItemId = totalSupply() + 1;
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, hash);
        emit Mint(newItemId, recipient);
        return newItemId;
    }

    /// @notice Getter function for _royaltiesReceiver
    /// @return the address of the royalties recipient
    function royaltiesReceiver() external returns(address) {
        return _royaltiesReceiver;
    }

    /// @notice Changes the royalties' recipient address (in case rights are
    ///         transferred for instance)
    /// @param newRoyaltiesReceiver - address of the new royalties recipient
    function setRoyaltiesReceiver(address newRoyaltiesReceiver)
    external onlyOwner {
        require(newRoyaltiesReceiver != _royaltiesReceiver); // dev: Same address
        _royaltiesReceiver = newRoyaltiesReceiver;
    }

    /// @notice Returns a token's URI
    /// @dev See {IERC721Metadata-tokenURI}.
    /// @param tokenId - the id of the token whose URI to return
    /// @return a string containing an URI pointing to the token's ressource
    function tokenURI(uint256 tokenId)
    public view override(ERC721, ERC721URIStorage)
    returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /// @notice Informs callers that this contract supports ERC2981
    function supportsInterface(bytes4 interfaceId)
    public view override(ERC721, ERC721Enumerable)
    returns (bool) {
        return interfaceId == type(IERC2981).interfaceId ||
        super.supportsInterface(interfaceId);
    }


    /// @notice Returns all the tokens owned by an address
    /// @param _owner - the address to query
    /// @return ownerTokens - an array containing the ids of all tokens
    ///         owned by the address
    function tokensOfOwner(address _owner) external view
    returns(uint256[] memory ownerTokens ) {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory result = new uint256[](tokenCount);

        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            for (uint256 i=0; i<tokenCount; i++) {
                result[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return result;
        }
    }

    /// @notice Called with the sale price to determine how much royalty
    //          is owed and to whom.
    /// @param _tokenId - the NFT asset queried for royalty information
    /// @param _salePrice - sale price of the NFT asset specified by _tokenId
    /// @return receiver - address of who should be sent the royalty payment
    /// @return royaltyAmount - the royalty payment amount for _value sale price
    function _royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view
    returns (address receiver, uint256 royaltyAmount) {
        uint256 royalties = (_salePrice * royaltiesPercentage) / 100;
        return (_royaltiesReceiver, royalties);
    }

    function _burn(uint256 tokenId)
    internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, amount);
    }



}