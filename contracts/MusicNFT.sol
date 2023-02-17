// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.7.0;

// importing the ERC1155 token standard
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface AllContracts {
    function addItem(address artiste, address contractAddress, string memory name, uint amount, uint price) external;
}

contract MusicNFT is ERC1155 {
    // the artiste or owner of the songs
    address owner;
    uint amount;
    uint price;
    string name;

    address ContractsAddress; // to be set to the address of the AllNFTs contract that has been deployed already
    AllContracts Contracts = AllContracts(ContractsAddress);

    using Counters for Counters.Counter; // OpenZepplin Counter
    Counters.Counter private _mintedCount; // Counter For amount minted

    constructor(string memory uri, uint _amount, uint _price, string memory _name) ERC1155(uri) {
        owner = msg.sender;
        amount = _amount;
        price = _price;
        name = _name;

        mint(msg.sender, 1, 1);

        Contracts.addItem(msg.sender, address(this), _name, _amount, _price);
    }

    // function to mint the NFT to the artiste
    // this function takes the default token ID as '1'
    // and mints just 1 copy to the artiste/owner of the contract
    // it is called as the contract is deployed
    function mint(address account, uint256 id, uint256 _amount) internal {
        bytes memory data = abi.encode("0");
        _mint(account, id, _amount, data);
    }

    // function for a user to buy the NFT
    // this function takes the default token ID as '1'
    // and mints just 1 copy to the buyer
    function buy() public payable {
        require(msg.value == price, "you need to pay the required amount");
        require(_mintedCount.current() <= amount, "All NFTs have been minted");

        bytes memory data = abi.encode("0");
        _mintedCount.increment();
        _mint(msg.sender, 1, 1, data);
    }

    function getPrice() public view returns(uint) {
        return price;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function getAmount() public view returns(uint) {
        return amount;
    }

    function getAvailable() public view returns (uint) {
        if (_mintedCount.current() == amount) {
            return 0;
        } else {
            uint available = amount - _mintedCount.current();
            return available;
        }
        
    }
}

