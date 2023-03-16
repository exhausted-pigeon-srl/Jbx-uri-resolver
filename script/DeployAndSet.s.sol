// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { JBTiered721Delegate } from "@jbx-protocol/juice-721-delegate/contracts/JBTiered721Delegate.sol";
import { XPigeonUriResolver } from "../src/XPigeonUriResolver.sol";

contract DeployAndSet is Script {
    function setUp() public {}

    function run() public {
        JBTiered721Delegate nft = JBTiered721Delegate(0x563F751b6aA9710769DC7877DBA9B62b43a40E3a);
        string memory baseUriAsset = "ipfs://Qme4mgUyYezSZkrbBy4cYMq8Xo8HUx4qcLTpwtQAz64jys/";

        vm.startBroadcast(nft.owner());
        
        XPigeonUriResolver resolver = new XPigeonUriResolver(baseUriAsset, ".png");      
        nft.setTokenUriResolver(resolver);
        
        vm.stopBroadcast();

        console.log("et voila!");        
    }
}
