// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import{DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";

contract BasicNFTTest is Test{
      DeployBasicNFT public deployer;
      BasicNFT basicNFT;
      address public USER = makeAddr("user");
      string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
      
      function setUp() public{
      deployer = new DeployBasicNFT();
      basicNFT = deployer.run();
      }

      function testNameIsCorrect() public view{
            string memory name = "BasicNFT";
            string memory actualName = basicNFT.name();
            assert(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(actualName)));

      }

      function testCanMintAndHaveABalance() public {
            vm.prank(USER);
            basicNFT.mintNFT(PUG);


            assert(basicNFT.balanceOf(USER) == 1);
            assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
      }
}