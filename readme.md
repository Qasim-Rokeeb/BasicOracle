
# 📄 Basic Oracle Smart Contract

A Solidity-based **on-chain price oracle** that lets **trusted oracle addresses** push price updates for asset symbols, while allowing anyone to fetch the latest price and verify if the data is stale.

---

## 📌 Overview

* **Purpose:** Provide a secure, owner-controlled mechanism for storing and updating asset prices.
* **Access Control:**

  * Only the **owner** can add or remove oracle addresses.
  * Only **approved oracles** can push price updates.
* **Price Staleness:** Anyone can check if a price is older than a specified threshold.

**Deployed & Verified on Base Sepolia:**
`0x195B17E6fDf9C735d544CC4C837fB57688B2A430`
🔍 [View Verified Contract on BaseScan](https://sepolia.basescan.org/address/0x195B17E6fDf9C735d544CC4C837fB57688B2A430#code) ✅

---

## ⚙️ Features

* **Owner Controls**

  * Add or remove authorized oracle addresses.
* **Oracle Functions**

  * Push latest price updates for a given symbol.
* **Public Functions**

  * Retrieve latest price with timestamp.
  * Check if a price feed is stale (older than a given age).
* **Event Logging**

  * Emits events for all key actions: oracle management and price updates.

---

## 🛠 Deployment

### Requirements

* Solidity `^0.8.19`
* Base Sepolia network
* ETH for deployment gas

### Example

```solidity
BasicOracle oracle = new BasicOracle();
```

**On Deployment:**

* The deployer is set as the **owner**.
* The deployer is automatically approved as the first oracle.

---

## 📜 Functions

### **addOracle(address \_oracle)**

Adds a new oracle to the approved list.

* **Access:** `onlyOwner`
* **Emits:** `OracleAdded`

---

### **removeOracle(address \_oracle)**

Removes an oracle from the approved list.

* **Access:** `onlyOwner`
* **Emits:** `OracleRemoved`

---

### **updatePrice(string \_symbol, uint256 \_price)**

Updates the latest price for a given symbol.

* **Access:** `onlyOracle`
* **Emits:** `PriceUpdated`

---

### **getPrice(string \_symbol)**

Fetches the latest price and timestamp for a symbol.

* **Returns:** `(price, timestamp)`

---

### **isPriceStale(string \_symbol, uint256 \_maxAge)**

Checks if the price feed for a symbol is older than `_maxAge` seconds.

* **Returns:** `true` if stale, `false` if fresh.

---

## 🧪 Testing

Run local tests with Hardhat:

```bash
npm install
npx hardhat test
```

Suggested tests:

* Adding/removing oracles.
* Updating and fetching prices.
* Staleness detection.

---

## 📄 License

MIT License – Free to use and modify.

---
