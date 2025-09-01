// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant INITIAL_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testMinimumUsdIsFive() public view {
        console.log(fundMe.getMinimumUsd());
        assertEq(fundMe.getMinimumUsd(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getPriceFeedVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getPriceFeedVersion();
            assertEq(version, 6);
        } else {
            uint256 version = fundMe.getPriceFeedVersion();
            assertEq(version, 0);
        }
    }

    function testFundFailsWithoutMinimumUsd() public {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.fund{value: 4}(); // sending less than minimum
    }

    function testDataStructureUpdatesWhenFunded() public {
        //Arrange
        vm.prank(USER);
        //Action
        fundMe.fund{value: SEND_VALUE}();
        //Assert
        assertEq(fundMe.getFunder(0), USER);
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testWithdrawFailsIfNotOwner() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // let's say 0.2 ether
        uint256 startingFundMeContractBalance = address(fundMe).balance; // let's say 0.1 ether

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw(); // withdraws the 0.1 ether to owner's address

        // Assert
        uint256 endingFundMeContractBalance = address(fundMe).balance; // Now 0 ether after withdraw
        uint256 endingOwnerBalance = fundMe.getOwner().balance; // Now 0.2 + 0.1 = 0.3 ether
        assertEq(endingFundMeContractBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeContractBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public {
        // Arrange
        uint256 numberOfFunders = 10;
        for (
            uint160 funderIndex = 1;
            funderIndex < numberOfFunders;
            funderIndex++
        ) {
            hoax(address(funderIndex), INITIAL_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // let's say 0.2 ether
        uint256 startingFundMeContractBalance = address(fundMe).balance; // let's say 0.1 ether

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(
            fundMe.getOwner().balance,
            startingOwnerBalance + startingFundMeContractBalance
        );
    }

    function testCheaperWithdraw() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeContractBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 endingFundMeContractBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingFundMeContractBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeContractBalance,
            endingOwnerBalance
        );
    }
}
