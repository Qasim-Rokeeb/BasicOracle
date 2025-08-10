// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract BasicOracle {
    struct PriceFeed {
        uint256 price;
        uint256 timestamp;
        address updater;
    }
    
    mapping(string => PriceFeed) public priceFeeds;
    mapping(address => bool) public oracles;
    address public owner;
    
    event PriceUpdated(string indexed symbol, uint256 price, uint256 timestamp);
    event OracleAdded(address indexed oracle);
    event OracleRemoved(address indexed oracle);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    modifier onlyOracle() {
        require(oracles[msg.sender], "Only oracle can update");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        oracles[msg.sender] = true;
    }
    
    function addOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = true;
        emit OracleAdded(_oracle);
    }
    
    function removeOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = false;
        emit OracleRemoved(_oracle);
    }
    
    function updatePrice(string memory _symbol, uint256 _price) external onlyOracle {
        priceFeeds[_symbol] = PriceFeed({
            price: _price,
            timestamp: block.timestamp,
            updater: msg.sender
        });
        
        emit PriceUpdated(_symbol, _price, block.timestamp);
    }
    
    function getPrice(string memory _symbol) external view returns (uint256, uint256) {
        PriceFeed memory feed = priceFeeds[_symbol];
        return (feed.price, feed.timestamp);
    }
    
    function isPriceStale(string memory _symbol, uint256 _maxAge) external view returns (bool) {
        return (block.timestamp - priceFeeds[_symbol].timestamp) > _maxAge;
    }
}