// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.7.0;
pragma abicoder v2 ;

//OpenZeppelin's counter Contract.
import "@openzeppelin/contracts/utils/Counters.sol";

contract FilMedia {
    address public owner;
    using Counters for Counters.Counter;
    Counters.Counter private _podcastIds;

    // the podcast struct
    struct podcast {
        address author;
        string title;
        string description;
        uint price;
    }

    mapping (uint => podcast) Podcasts;
    mapping (uint => string) podcastHash;

    podcast[] public allPodcasts;

    constructor() {
        owner = payable(msg.sender);
    }

    function createPodcast(string memory _title, string memory _description, string memory _ipfsHash, uint _price) public {
        
        Podcasts[_podcastIds.current()].author = msg.sender;
        Podcasts[_podcastIds.current()].title = _title;
        Podcasts[_podcastIds.current()].description = _description;
        podcastHash[_podcastIds.current()] = _ipfsHash;
        Podcasts[_podcastIds.current()].price = _price;

        _podcastIds.increment();
        allPodcasts.push(Podcasts[_podcastIds.current()]);
    }

    function accessPodcast(uint id) public payable returns(string memory) {
        require(msg.value == Podcasts[id].price, "send required fee");
        
        address author = Podcasts[id].author;
        (bool sent, bytes memory data) = author.call{value: msg.value}("");

        if (sent == true) {
            return podcastHash[id];
        }
    }

    function tipPodcast(uint id) public payable {
        require(msg.value > 0, "send a specific amount");
        
        address author = Podcasts[id].author;
        (bool sent, bytes memory data) = author.call{value: msg.value}("");

    }

    function getPodcasts() view public returns (podcast[] memory) {
        return allPodcasts;
    }

}

