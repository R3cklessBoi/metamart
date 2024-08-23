// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ecommerce {

    // Product structure
    struct Product {
        uint256 id;
        string name;
        string description;
        uint256 price; // Price in wei
        address seller;
        bool available;
        uint256 discount; // Discount in percentage (0-100)
    }

    // Product mapping
    mapping(uint256 => Product) public products;

    // Product ID counter
    uint256 private productIdCounter;

    // Event declarations
    event ProductAdded(uint256 productId, string name, uint256 price, address seller);
    event ProductUpdated(uint256 productId, uint256 price, uint256 discount, bool available);

    // Constructor
    constructor() {
        productIdCounter = 1;
    }

    // Add a new product
    function addProduct(string memory name, string memory description, uint256 price) public {
        require(price > 0, "Price must be greater than zero");

        products[productIdCounter] = Product({
            id: productIdCounter,
            name: name,
            description: description,
            price: price,
            seller: msg.sender,
            available: true,
            discount: 0
        });

        emit ProductAdded(productIdCounter, name, price, msg.sender);
        productIdCounter++;
    }

    // Update product details
    function updateProduct(uint256 productId, uint256 price, uint256 discount, bool available) public {
        require(products[productId].seller == msg.sender, "Only the seller can update the product");
        require(price >= 0, "Price must be non-negative");
        require(discount <= 100, "Discount must be between 0 and 100");

        Product storage product = products[productId];
        product.price = price;
        product.discount = discount;
        product.available = available;

        emit ProductUpdated(productId, price, discount, available);
    }
}
