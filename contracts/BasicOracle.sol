// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title BasicOracle
 * @dev A simple on-chain oracle contract that stores and serves price data for assets.
 *      - Uses a list of approved oracle addresses to update prices.
 *      - Each price feed stores the latest price, the time it was updated, and the updater's address.
 */
contract BasicOracle {
    // Represents a single price feed for a given asset symbol.
    struct PriceFeed {
        uint256 price;      // Latest price of the asset (in smallest units, e.g., USD * 1e8)
        uint256 timestamp;  // Block timestamp when the price was last updated
        address updater;    // Address of the oracle that updated the price
    }
    
    // Mapping from asset symbol (e.g., "ETH", "BTC") to its latest PriceFeed data.
    mapping(string => PriceFeed) public priceFeeds;

    // Mapping to track which addresses are authorized to update prices.
    mapping(address => bool) public oracles;

    // Address of the contract owner (can manage oracles).
    address public owner;
    
    // Emitted whenever a price is updated.
    event PriceUpdated(string indexed symbol, uint256 price, uint256 timestamp);
    
    // Emitted when a new oracle address is added.
    event OracleAdded(address indexed oracle);
    
    // Emitted when an oracle address is removed.
    event OracleRemoved(address indexed oracle);
    
    /**
     * @dev Restricts access to only the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    /**
     * @dev Restricts access to only addresses approved as oracles.
     */
    modifier onlyOracle() {
        require(oracles[msg.sender], "Only oracle can update");
        _;
    }
    
    /**
     * @dev Contract constructor.
     *      - Sets the deployer as the owner.
     *      - Adds the deployer to the list of approved oracles by default.
     */
    constructor() {
        owner = msg.sender;
        oracles[msg.sender] = true;
    }
    
    /**
     * @notice Add a new oracle address.
     * @param _oracle The address to authorize as an oracle.
     * @dev Only callable by the owner.
     */
    function addOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = true;
        emit OracleAdded(_oracle);
    }
    
    /**
     * @notice Remove an oracle address.
     * @param _oracle The address to deauthorize.
     * @dev Only callable by the owner.
     */
    function removeOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = false;
        emit OracleRemoved(_oracle);
    }
    
    /**
     * @notice Updates the price feed for a given asset symbol.
     * @param _symbol The asset symbol (e.g., "ETH", "BTC").
     * @param _price The latest price of the asset in smallest units.
     * @dev Only callable by approved oracle addresses.
     *      Overwrites the previous price and timestamp for the given symbol.
     */
    function updatePrice(string memory _symbol, uint256 _price) external onlyOracle {
        priceFeeds[_symbol] = PriceFeed({
            price: _price,
            timestamp: block.timestamp,
            updater: msg.sender
        });
        
        emit PriceUpdated(_symbol, _price, block.timestamp);
    }
    
    /**
     * @notice Fetches the latest price and timestamp for a given asset symbol.
     * @param _symbol The asset symbol (e.g., "ETH", "BTC").
     * @return price The latest price of the asset.
     * @return timestamp The timestamp when the price was last updated.
     */
    function getPrice(string memory _symbol) external view returns (uint256 price, uint256 timestamp) {
        PriceFeed memory feed = priceFeeds[_symbol];
        return (feed.price, feed.timestamp);
    }
    
    /**
     * @notice Checks if a given asset's price feed is stale.
     * @param _symbol The asset symbol (e.g., "ETH", "BTC").
     * @param _maxAge The maximum allowed age of the price data in seconds.
     * @return bool True if the price is older than _maxAge, false otherwise.
     */
    function isPriceStale(string memory _symbol, uint256 _maxAge) external view returns (bool) {
        return (block.timestamp - priceFeeds[_symbol].timestamp) > _maxAge;
    }
}
