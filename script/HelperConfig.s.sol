//SPDX-License-Identifier : MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    uint256 private constant LOCK_DURATION_SEPOLIA = 5 minutes;
    uint256 private constant LOCK_DURATION_ANVIL = 1 minutes;
    uint256 private constant LOCK_DURATION_MAINNET = 1 weeks;

    function activeNetworkConfig() public returns (uint256) {
        if (block.chainid == 31337) {
            // Anvil / local
            return LOCK_DURATION_ANVIL;
        } else if (block.chainid == 11155111) {
            // Sepolia
            return LOCK_DURATION_SEPOLIA;
        } else {
            // Mainnet or unknown network

            return LOCK_DURATION_MAINNET;
        }
    }
}
