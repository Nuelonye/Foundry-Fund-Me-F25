// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/FundMeInteractions.s.sol";

contract FundMeInteractionsTest is Test {
    FundMe fundMe;

    uint256 constant INITIAL_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("user");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testUserCanFundAnWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        // payable(address(fundFundMe)).transfer(1 ether);

        fundFundMe.fundFundMe(address(fundMe));
        assertEq(address(fundMe).balance, SEND_VALUE);
        assertEq(fundMe.getFunder(0), msg.sender);

        withdrawFundMe.withdrawFundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
