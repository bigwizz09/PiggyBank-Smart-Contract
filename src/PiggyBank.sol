//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract PiggyBank {
    error Withdraw__FundsAreStillLocked();
    error Withdraw__NotDepositor();

    mapping(address => uint256) private amountFundedBy;
    mapping(address => bool) private s_hasFunded;
    mapping(address => uint256) s_unlockTime;
    address[] private s_funders;
    uint256 private immutable i_lockDuration;

    event DepositMade(address indexed user, uint256 amount, uint256 unlockTime);
    event WithdrawalMade(address indexed user, uint256 amount);

    modifier onlyAfterDeadline() {
        if (block.timestamp < s_unlockTime[msg.sender]) {
            revert Withdraw__FundsAreStillLocked();
        }
        _;
    }

    modifier onlyDepositor() {
        if (amountFundedBy[msg.sender] == 0) {
            revert Withdraw__NotDepositor();
        }
        _;
    }

    constructor(uint256 lockDuration) {
        i_lockDuration = lockDuration;
    }

    function deposit() public payable {
        amountFundedBy[msg.sender] += msg.value;
        //Reset unlockTime for everytime a user deposit
        s_unlockTime[msg.sender] = block.timestamp + i_lockDuration;
        if (!s_hasFunded[msg.sender]) {
            s_funders.push(msg.sender);
            s_hasFunded[msg.sender] = true; //mark has funded
        }
        emit DepositMade(msg.sender, msg.value, s_unlockTime[msg.sender]);
    }

    function withdraw() public onlyDepositor onlyAfterDeadline {
        uint256 amountToWithdraw = amountFundedBy[msg.sender];
        amountFundedBy[msg.sender] = 0;
        s_unlockTime[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amountToWithdraw}(
            ""
        );
        require(success, "ETH transfer failed");

        emit WithdrawalMade(msg.sender, amountToWithdraw);
    }

    function getamountFundedBy(
        address addressFunder
    ) external view returns (uint256) {
        return amountFundedBy[addressFunder];
    }

    function getLockDuration() public view returns (uint256) {
        return i_lockDuration;
    }

    function timeLeft(address user) public view returns (uint256) {
        if (block.timestamp >= s_unlockTime[user]) {
            return 0;
        } else {
            return s_unlockTime[user] - block.timestamp;
        }
    }

    receive() external payable {
        deposit();
    }

    fallback() external payable {
        if (msg.value > 0) {
            deposit();
        }
    }
}
