//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {PiggyBank} from "../../src/PiggyBank.sol";
import {DeployPiggyBank} from "../../script/DeployPiggyBank.s.sol";
import {DepositInPiggyBank, WithdrawFromPiggyBank} from "../../script/Interaction.s.sol";

contract Interaction is Test {
    DepositInPiggyBank depositInPiggyBank;
    WithdrawFromPiggyBank withdrawFromPiggyBank;
    PiggyBank piggyBank;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10 ether;
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        depositInPiggyBank = new DepositInPiggyBank();
        withdrawFromPiggyBank = new WithdrawFromPiggyBank();
        DeployPiggyBank deployPiggyBank = new DeployPiggyBank();
        piggyBank = deployPiggyBank.run();

        vm.deal(USER, STARTING_BALANCE);
    }

    function testDepositaAndWithdrawScript() public {
        depositInPiggyBank.depositInPiggyBank{value: 0.01 ether}(
            address(piggyBank)
        );

        vm.warp(block.timestamp + 1 minutes);

        assertEq(piggyBank.getamountFundedBy(msg.sender), 0.01 ether);

        withdrawFromPiggyBank.withdrawFromPiggyBank(address(piggyBank));

        assertEq(piggyBank.getamountFundedBy(msg.sender), 0);
    }
}
