// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {DeployMinimal} from "script/DeployMinimal.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract MinimalAccountTest is Test {
    HelperConfig public helperConfig;
    MinimalAccount public minimalAccount;
    ERC20Mock public usdc;

    address randomuser = makeAddr("randomuser");

    uint256 constant AMOUNT = 1e18;

    function setUp() public {
        DeployMinimal deployMinimal = new DeployMinimal();
        (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
        usdc = new ERC20Mock();
    }

    function testOwnerCanExecuteCommands() public {
        assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);

        vm.prank(minimalAccount.owner());
        minimalAccount.execute(dest, value, functionData);
        assertEq(usdc.balanceOf(address(minimalAccount)), AMOUNT);
    }


    function testNotOwnerCannotExecuteCommands() public {

      assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);

        vm.prank(randomuser);
        vm.expectRevert(MinimalAccount.MinimalAccount__NotFromEntryPointorOwner.selector);
        minimalAccount.execute(dest, value, functionData);
    }


}
