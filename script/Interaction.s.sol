// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {PiggyBank} from "../src/PiggyBank.sol";

contract DepositInPiggyBank is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function depositInPiggyBank(address mostRecentlyDeployed) public payable {
        vm.startBroadcast();
        PiggyBank(payable(mostRecentlyDeployed)).deposit{value: msg.value}();
        vm.stopBroadcast();

        console.log("Deposited PiggyBank contract with %s ETH", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "PiggyBank",
            block.chainid
        );

        depositInPiggyBank(mostRecentlyDeployed);
    }
}

// contract WithdrawFromPiggyBank is Script {
//     function withdrawFromPiggyBank(address mostRecentlyDeployed) public {
//         console.log(
//             "PiggyBank contract balance before withdraw:",
//             address(mostRecentlyDeployed).balance
//         );
//         PiggyBank(payable(mostRecentlyDeployed)).withdraw();

//         console.log(
//             "PiggyBank contract balance after withdraw:",
//             address(mostRecentlyDeployed).balance
//         );
//         console.log("Wallet balance after withdraw:", msg.sender.balance);
//     }

//     function run() external {
//         address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
//             "PiggyBank",
//             block.chainid
//         );

//         vm.startBroadcast();
//         withdrawFromPiggyBank(mostRecentlyDeployed);
//         vm.stopBroadcast();
//     }
// }

contract WithdrawFromPiggyBank is Script {
    function withdrawFromPiggyBank(address piggyBankAddress) public {
        // Log balances before withdrawal
        console.log(
            "Before withdraw - Contract balance:",
            address(piggyBankAddress).balance,
            "Wallet balance:",
            msg.sender.balance
        );

        // Call
        vm.startBroadcast();
        PiggyBank(payable(piggyBankAddress)).withdraw();
        vm.stopBroadcast();

        // Log balances after withdrawal
        console.log(
            "After withdraw - Contract balance:",
            address(piggyBankAddress).balance,
            "Wallet balance:",
            msg.sender.balance
        );

        // Log remaining balance for the depositor
        console.log(
            "Depositor remaining balance:",
            PiggyBank(payable(piggyBankAddress)).getamountFundedBy(msg.sender)
        );
    }

    function run() external {
        // Get the most recently deployed PiggyBank
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "PiggyBank",
            block.chainid
        );

        // Start broadcast for all transactions in this script

        // Perform withdrawal
        withdrawFromPiggyBank(mostRecentlyDeployed);

        // Stop broadcast
    }
}
