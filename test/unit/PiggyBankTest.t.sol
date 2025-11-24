//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {PiggyBank} from "../../src/PiggyBank.sol";
import {DeployPiggyBank} from "../../script/DeployPiggyBank.s.sol";

contract PiggyBankTest is Test {
    PiggyBank piggyBank;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10 ether;
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        DeployPiggyBank deployPiggyBank = new DeployPiggyBank();
        piggyBank = deployPiggyBank.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    modifier deposited() {
        vm.prank(USER); //next tx will be snt by USER
        piggyBank.deposit{value: SEND_VALUE}();
        _;
    }

    function testdeposit() public deposited {
        uint256 amountFunded = piggyBank.getamountFundedBy(USER);
        assertEq(amountFunded, SEND_VALUE, "not equal");
    }

    function testWithdrawBeforeUnlockTime() public deposited {
        vm.expectRevert();
        vm.prank(USER);
        piggyBank.withdraw();
    }

    function testWithdrawAfterUnlockTime() public deposited {
        vm.prank(USER);
        vm.warp(block.timestamp + 1 minutes);
        piggyBank.withdraw();

        uint256 amountFunded = piggyBank.getamountFundedBy(USER);
        assertEq(amountFunded, 0, "Did not Withdraw");
    }
}
