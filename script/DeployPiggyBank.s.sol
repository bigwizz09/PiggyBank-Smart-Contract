//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {PiggyBank} from "../src/PiggyBank.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployPiggyBank is Script {
    function run() external returns (PiggyBank) {
        HelperConfig helperConfig = new HelperConfig();
        // 2️⃣ Get the correct lock duration for this network
        uint256 lockDuration = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        PiggyBank piggyBank = new PiggyBank(lockDuration);
        vm.stopBroadcast();
        return piggyBank;
    }
}
