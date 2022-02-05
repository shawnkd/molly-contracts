// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Highlight.sol";
import "./IERC2981.sol";

contract Marketplace is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    
     address public owner;

     Highlight highlight;
     
     constructor() {
         owner = msg.sender;
     }
     
     struct MarketItem {
         uint itemId;
         address nftContract;
         uint256 tokenId;
         address payable seller;
         address payable owner;
         uint256 price;
         bool sold;
     }
     
     mapping(uint256 => MarketItem) private idToMarketItem;
     
     event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
     );
     
     event MarketItemSold (
         uint indexed itemId,
         address owner
         );


    /// @notice Checks if NFT contract implements the ERC-2981 interface
    /// @param _contract - the address of the NFT contract to query
    /// @return true if ERC-2981 interface is supported, false otherwise
    function _checkRoyalties(address _contract) internal returns (bool) {
        (bool success) = IERC2981(_contract).
        supportsInterface(_INTERFACE_ID_ERC2981);
        return success;
    }

    /// @notice Transfers royalties to the rightsowner if applicable
    /// @param tokenId - the NFT assed queried for royalties
    /// @param grossSaleValue - the price at which the asset will be sold
    /// @return netSaleAmount - the value that will go to the seller after
    ///         deducting royalties
    function _deduceRoyalties(uint256 tokenId, uint256 grossSaleValue)
    internal returns (uint256 netSaleAmount) {
        // Get amount of royalties to pays and recipient
        (address royaltiesReceiver, uint256 royaltiesAmount) = highlight
        ._royaltyInfo(tokenId, grossSaleValue);
        // Deduce royalties from sale value
        uint256 netSaleValue = grossSaleValue - royaltiesAmount;
        // Transfer royalties to rightholder if not zero
        if (royaltiesAmount > 0) {
            royaltiesReceiver.call{value: royaltiesAmount}('');
        }
        // Broadcast royalties payment
        //emit RoyaltiesPaid(tokenId, royaltiesAmount);
        return netSaleValue;
    }
     
    /// @notice Creates marketlisting and emits event
    /// @param nftContract - the address of the nft for listing
    /// @param tokenId - the token id of the nft for listing
    /// @param price - the price of the listing
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
        ) public payable nonReentrant {
            require(price > 0, "Price must be greater than 0");
            
            _itemIds.increment();
            uint256 itemId = _itemIds.current();
  
            idToMarketItem[itemId] =  MarketItem(
                itemId,
                nftContract,
                tokenId,
                payable(msg.sender),
                payable(address(0)),
                price,
                false
            );
            
            IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
                
            emit MarketItemCreated(
                itemId,
                nftContract,
                tokenId,
                msg.sender,
                address(0),
                price,
                false
            );
        }
        
    
    function createMarketSale(
        address nftContract,
        uint256 itemId
        ) public payable nonReentrant {
            uint price = idToMarketItem[itemId].price;
            uint tokenId = idToMarketItem[itemId].tokenId;
            bool sold = idToMarketItem[itemId].sold;
            require(msg.value == price, "Please submit the asking price in order to complete the purchase");
            require(sold != true, "This Sale has alredy finnished");
            emit MarketItemSold(
                itemId,
                msg.sender
                );



            idToMarketItem[itemId].seller.transfer(msg.value);
            IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
            idToMarketItem[itemId].owner = payable(msg.sender);
            _itemsSold.increment();
            idToMarketItem[itemId].sold = true;
        }
        
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(0)) {
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    
      
}
