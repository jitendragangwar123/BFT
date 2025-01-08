// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {BFT} from "../src/BFT.sol";

contract DeployBFT is Script {
    // Define the wallet addresses
    address private constant TEAM_WALLET = 0xEB0d204cc98F7900AD22717Ffb58212279fCDCdB;
    address private constant MARKETING_WALLET = 0xEB0d204cc98F7900AD22717Ffb58212279fCDCdB;
    address private constant DEVELOPMENT_WALLET = 0xEB0d204cc98F7900AD22717Ffb58212279fCDCdB;
    address private constant COMMUNITY_WALLET = 0xEB0d204cc98F7900AD22717Ffb58212279fCDCdB;

    function run() external returns (BFT) {
        vm.startBroadcast();
        BFT bft = new BFT(TEAM_WALLET, MARKETING_WALLET, DEVELOPMENT_WALLET, COMMUNITY_WALLET);
        vm.stopBroadcast();
        return bft;
    }
}
