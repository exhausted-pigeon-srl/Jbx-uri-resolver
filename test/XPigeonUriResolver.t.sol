// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { JBTiered721Delegate } from "@jbx-protocol/juice-721-delegate/contracts/JBTiered721Delegate.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "../src/XPigeonUriResolver.sol";

contract XPigeonUriResolverTest is Test {
    using Strings for uint256;

    XPigeonUriResolver public resolver;
    JBTiered721Delegate public nft;
    address public owner;

    function setUp() public {
        vm.createSelectFork("https://rpc.ankr.com/eth", 16835971);
        string memory baseUriAsset = "ipfs://Qme4mgUyYezSZkrbBy4cYMq8Xo8HUx4qcLTpwtQAz64jys/";
        resolver = new XPigeonUriResolver(baseUriAsset, ".jpg");
        nft = JBTiered721Delegate(0x563F751b6aA9710769DC7877DBA9B62b43a40E3a);
        owner = nft.owner();
    }

    function testSetResolver_returnCorrectUri(uint256 _tokenId) public {
        // Only 1 tier at this block
        _tokenId = bound(_tokenId, 1000000001, 1000000000 + nft.store().totalSupply(address(nft)));

        vm.prank(owner);
        nft.setTokenUriResolver(resolver);

        string memory json = Base64.encode(bytes(string(abi.encodePacked(
            '{"description":"AI Generated Exhausted Pigeons.","name":"Exhausted Pigeons","externalLink":"https://www.exhausted-pigeon.xyz","image":"',
            'ipfs://Qme4mgUyYezSZkrbBy4cYMq8Xo8HUx4qcLTpwtQAz64jys/',
            _tokenId.toString(),
            '.jpg',
            '","attributes":[{"trait_type":"Min. Contribution","value":0.01},{"trait_type":"Max. Supply"},{"trait_type":"tier","value":1}]}'))));

        string memory tokenUri = string(abi.encodePacked('data:application/json;base64,', json));

        assertEq(nft.tokenURI(_tokenId), tokenUri);
    }

    function testSetResolver_returnEmptyUriIfNonExisting(uint256 _tokenId) public {
        // One more than supply
        _tokenId = bound(_tokenId, 1000000001 + nft.store().totalSupply(address(nft)), 1000000001 * 9);

        vm.startPrank(owner);
        nft.setTokenUriResolver(resolver);

        assertEq(nft.tokenURI(_tokenId), "" );
    }
}