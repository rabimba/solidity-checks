pragma solidity ^0.8.0;

contract DutchAuction {
    address payable owner;
    uint256 startPrice;
    uint256 endPrice;
    uint256 decrementInterval;
    uint256 decrementAmount;
    uint256 auctionEnd;
    address payable highestBidder;
    uint256 highestBid;

    constructor(
        uint256 _startPrice,
        uint256 _endPrice,
        uint256 _decrementInterval,
        uint256 _decrementAmount,
        uint256 _auctionDuration
    ) public {
        owner = msg.sender;
        startPrice = _startPrice;
        endPrice = _endPrice;
        decrementInterval = _decrementInterval;
        decrementAmount = _decrementAmount;
        auctionEnd = now + _auctionDuration;
    }

    function bid() public payable {
        require(msg.value >= highestBid, "Bid must be higher than current highest bid");
        require(now <= auctionEnd, "Auction has already ended");
        require(msg.value <= startPrice, "Bid must be lower than or equal to current price");

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function decrementPrice() private {
        if (now >= auctionEnd || highestBid >= endPrice) {
            return;
        }

        if (startPrice > endPrice) {
            startPrice = startPrice - decrementAmount;
        }
    }

    function endAuction() public {
        require(msg.sender == owner, "Only the owner can end the auction");
        require(now >= auctionEnd || highestBid >= endPrice, "Auction has not ended yet");

        highestBidder.transfer(highestBid);
        owner.transfer(address(this).balance);
    }
}
