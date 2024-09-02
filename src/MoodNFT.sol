// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    error MoodnFT_CantFlipMoodIfNotOwner();
    uint256 private s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIDtoMood;

    constructor(
        string memory sadSVGImageURI,
        string memory happySVGImageURI
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_happySVGImageURI = happySVGImageURI;
        s_sadSVGImageURI = sadSVGImageURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIDtoMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenID) public {
        //only want the owner of the nft to change the mood
        if (
            ownerOf(tokenID) != msg.sender && getApproved(tokenID) != msg.sender
        ) {
            revert MoodnFT_CantFlipMoodIfNotOwner();
        }
        if (s_tokenIDtoMood[tokenID] == Mood.HAPPY) {
            s_tokenIDtoMood[tokenID] = Mood.SAD;
        } else {
            s_tokenIDtoMood[tokenID] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json:base64,";
    }

    function tokenURI(
        uint256 tokenID
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIDtoMood[tokenID] == Mood.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value: 100"}], "image:" "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
