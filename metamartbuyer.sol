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

    // Comment structure
    struct Comment {
        address user;
        string text;
    }

    // Product mapping
    mapping(uint256 => Product) public products;
    mapping(uint256 => Comment[]) public productComments;

    // Product ID counter
    uint256 private productIdCounter;

    // Event declarations
    event ProductPurchased(uint256 productId, address buyer);
    event CommentAdded(uint256 productId, address user, string text);

    // Constructor
    constructor() {
        productIdCounter = 1;
    }

    // Get product details
    function getProduct(uint256 productId) public view returns (Product memory) {
        return products[productId];
    }

    // Purchase a product
    function purchaseProduct(uint256 productId) public payable {
        Product storage product = products[productId];
        require(product.available, "Product not available");
        uint256 finalPrice = product.price * (100 - product.discount) / 100;
        require(msg.value >= finalPrice, "Insufficient funds");
        
        // Transfer funds to the seller
        payable(product.seller).transfer(finalPrice);
        
        // If the buyer sent more than the final price, refund the excess
        if (msg.value > finalPrice) {
            payable(msg.sender).transfer(msg.value - finalPrice);
        }
        
        emit ProductPurchased(productId, msg.sender);
    }

    // Add a comment to a product
    function addComment(uint256 productId, string memory text) public {
        require(bytes(text).length > 0, "Comment text cannot be empty");
        productComments[productId].push(Comment({
            user: msg.sender,
            text: text
        }));
        emit CommentAdded(productId, msg.sender, text);
    }

    // Get comments for a product
    function getComments(uint256 productId) public view returns (Comment[] memory) {
        return productComments[productId];
    }
}