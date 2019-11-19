pragma solidity ^0.5.0;

contract E_Marketplace {
	string public username;
	uint public NumberOfProducts = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string username;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string username,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string username,
        uint price,
        address payable owner,
        bool purchased
    );

	constructor() public {
		username="XYZ";
	}

	function createProduct(string memory _name, uint _price) public {
        require(bytes(_name).length > 0);
        require(_price > 0);
        NumberOfProducts ++;
        products[NumberOfProducts] = Product(NumberOfProducts, _name, _price, msg.sender, false);
        emit ProductCreated(NumberOfProducts, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        Product memory _product = products[_id];
        address payable _seller = _product.owner;
        require(_product.id > 0 && _product.id <= NumberOfProducts);
        require(msg.value >= _product.price);
        require(!_product.purchased);
        require(_seller != msg.sender);
        _product.owner = msg.sender;
        _product.purchased = true;
        products[_id] = _product;
        address(_seller).transfer(msg.value);
        emit ProductPurchased(NumberOfProducts, _product.username, _product.price, msg.sender, true);
    }
}