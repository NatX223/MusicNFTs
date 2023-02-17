// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.7.0;
pragma abicoder v2;

contract AllNFTs {

    uint nonce;

    struct item {
        address contractAddress;
        string name;
        uint amount;
        uint price;
    }

    mapping (address => item[]) Collection;
    constructor() {
        nonce = 1;
    }

    function addItem(address artiste, address contractAddress, string memory name, uint amount, uint price) external {
        item memory music;

        music.contractAddress = contractAddress;
        music.name = name;
        music.amount = amount;
        music.price = price;

        Collection[artiste].push(music);
    }

    function getAllMusic(address artiste) view public returns (item[] memory) {
        return Collection[artiste];
    }

}