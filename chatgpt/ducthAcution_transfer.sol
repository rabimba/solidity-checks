pragma solidity ^0.8.0;

contract DutchAuction {
    uint256 public startPrice;
    uint256 public endPrice;
    uint256 public decrementInterval;
    uint256 public auctionEnd;
    address public highestBidder;
    uint256 public highestBid;

    constructor(uint256 _startPrice, uint256 _endPrice, uint256 _decrementInterval, uint256 _auctionDuration) public {
        startPrice = _startPrice;
        endPrice = _endPrice;
        decrementInterval = _decrementInterval;
        auctionEnd = now + _auctionDuration;
    }

    function bid() public payable {
        require(msg.value >= currentPrice(), "Bid is below the current price");
        require(now <= auctionEnd, "Auction has already ended");
        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function currentPrice() public view returns (uint256) {
        if (now >= auctionEnd) {
            return endPrice;
        }
        uint256 elapsed = (now - auctionEnd + decrementInterval - 1) / decrementInterval;
        return startPrice - elapsed * (startPrice - endPrice) / ((startPrice - endPrice + decrementInterval - 1) / decrementInterval);
    }

    function endAuction() public {
        require(now >= auctionEnd, "Auction has not ended yet");
        require(highestBidder != address(0), "No bids were received");
        highestBidder.transfer(address(this).balance);
    }
}
