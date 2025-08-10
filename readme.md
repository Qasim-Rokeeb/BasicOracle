
# 📄 Basic Oracle Smart Contract

A Solidity-based **price oracle** that allows trusted addresses (oracles) to update asset prices for different symbols, while enabling others to retrieve price data and check if it's stale.

---

## 📌 Overview

* **Purpose:** Store and update price feeds for different symbols.
* **Access Control:**

  * Only the **contract owner** can add or remove oracles.
  * Only **approved oracles** can update prices.
* **Price Staleness Check:** Determine if a price is older than a given threshold.

**Deployed & Verified on Base Sepolia:**
`0x195B17E6fDf9C735d544CC4C837fB57688B2A430`
🔍 [View Verified Contract on BaseScan](https://sepolia.basescan.org/address/0x195B17E6fDf9C735d544CC4C837fB57688B2A430#code) ✅

---

## ⚙️ Features

* **Add or Remove Oracles** → Owner-controlled.
* **Update Prices** → Only authorized oracles.
* **Retrieve Prices** → Public access with timestamp.
* **Check Price Age** → Detect stale prices.

---

## 🛠 Deployment

### Requirements

* Solidity `^0.8.19`
* Base Sepolia network
* ETH balance for deployment gas fees

### Example Deployment

```solidity
BasicOracle oracle = new BasicOracle();
```

On deployment:

* The deployer becomes the **owner**.
* The deployer is automatically added as the first oracle.

---

## 📜 Functions

### **addOracle(address \_oracle)**

Adds a new oracle.

* **Access:** Only owner
* **Emits:** `OracleAdded`

---

### **removeOracle(address \_oracle)**

Removes an oracle.

* **Access:** Only owner
* **Emits:** `OracleRemoved`

---

### **updatePrice(string \_symbol, uint256 \_price)**

Updates the price for a symbol.

* **Access:** Only oracle
* **Emits:** `PriceUpdated`

---

### **getPrice(string \_symbol)**

Retrieves the current price and timestamp for a symbol.
Returns: `(price, timestamp)`

---

### **isPriceStale(string \_symbol, uint256 \_maxAge)**

Checks if a price is older than `_maxAge` seconds.
Returns: `true` if stale.

---

## 🧪 Testing

To test locally using Hardhat:

```bash
npm install
npx hardhat test
```

---

## 📄 License

MIT License – Free to use and modify.

---
