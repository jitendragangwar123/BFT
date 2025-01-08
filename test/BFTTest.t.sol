// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {BFT} from "../src/BFT.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BFTTest is Test {
    BFT public bft;

    address public owner = address(1);
    address public teamWallet = address(2);
    address public marketingWallet = address(3);
    address public developmentWallet = address(4);
    address public communityWallet = address(5);
    address public randomAddress = address(6);

    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18;

    function setUp() public {
        vm.startPrank(owner);
        bft = new BFT(teamWallet, marketingWallet, developmentWallet, communityWallet);
        vm.stopPrank();
    }

    function testDeployment() public view {
        assertEq(bft.owner(), owner);
        assertEq(bft.balanceOf(address(bft)), INITIAL_SUPPLY);
        assertEq(bft.teamWallet(), teamWallet);
        assertEq(bft.marketingWallet(), marketingWallet);
        assertEq(bft.developmentWallet(), developmentWallet);
        assertEq(bft.communityWallet(), communityWallet);
        assertFalse(bft.distributionCompleted());
    }

    function testDistributeTokens() public {
        vm.startPrank(owner);
        bft.distributeTokens();
        vm.stopPrank();

        uint256 teamAmount = (INITIAL_SUPPLY * bft.TEAM_PERCENTAGE()) / 100;
        uint256 marketingAmount = (INITIAL_SUPPLY * bft.MARKETING_PERCENTAGE()) / 100;
        uint256 developmentAmount = (INITIAL_SUPPLY * bft.DEVELOPMENT_PERCENTAGE()) / 100;
        uint256 communityAmount = (INITIAL_SUPPLY * bft.COMMUNITY_PERCENTAGE()) / 100;

        assertEq(bft.balanceOf(teamWallet), teamAmount);
        assertEq(bft.balanceOf(marketingWallet), marketingAmount);
        assertEq(bft.balanceOf(developmentWallet), developmentAmount);
        assertEq(bft.balanceOf(communityWallet), communityAmount);
        assertTrue(bft.distributionCompleted());
    }

    function testDistributeTokensTwice() public {
        vm.startPrank(owner);
        bft.distributeTokens();
        vm.expectRevert("Tokens already distributed");
        bft.distributeTokens();
        vm.stopPrank();
    }

    function testUpdateWallets() public {
        address newTeamWallet = address(7);
        address newMarketingWallet = address(8);
        address newDevelopmentWallet = address(9);
        address newCommunityWallet = address(10);

        vm.startPrank(owner);
        bft.updateWallets(newTeamWallet, newMarketingWallet, newDevelopmentWallet, newCommunityWallet);
        vm.stopPrank();

        assertEq(bft.teamWallet(), newTeamWallet);
        assertEq(bft.marketingWallet(), newMarketingWallet);
        assertEq(bft.developmentWallet(), newDevelopmentWallet);
        assertEq(bft.communityWallet(), newCommunityWallet);
    }

    function testUpdateWalletsInvalidAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("Invalid wallet address");
        bft.updateWallets(address(0), marketingWallet, developmentWallet, communityWallet);
        vm.stopPrank();
    }

    function testRecoverLaunchTokensFails() public {
        vm.startPrank(owner);
        vm.expectRevert("Cannot recover launch tokens");
        bft.recoverTokens(address(bft), 100);
        vm.stopPrank();
    }

    function testNonOwnerCannotCallRestrictedFunctions() public {
        vm.startPrank(randomAddress);
        vm.expectRevert();
        bft.distributeTokens();

        vm.expectRevert();
        bft.updateWallets(randomAddress, randomAddress, randomAddress, randomAddress);

        vm.expectRevert();
        bft.recoverTokens(address(bft), 100);
        vm.stopPrank();
    }
}
