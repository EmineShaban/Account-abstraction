// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

contract SendPackedUserOp is Script {
    function run() public{}

    function generatedSigneduserOperation(bytes memory callData, address sender) public returns(PackedUserOperation memory){
        uint256 nonce = vm.getNorce(sender);
        PackedUserOperation memory unsignedUserUpOp = _generatePackedUserOp(callData, sender, nonce);
    }
    function _generationUnsignedUserOperation (bytes memory callData, address sender, uint256 nonce) internal pure returns(PackedUserOperation memory){
        uint128 verificationGasLimit = 16777222;
        uint128 callGasLimit = verificationGasLimit;
        uint128 maxPriorityFeePerGas = 256;
        uint128 maxFeePerGas = maxPriorityFeePerGas;

        return PackedUserOperation({
            sender: sender,
            nonce: nonce,
            initCode: hex"",
            callData: callData,
            accountGasLimits: bytes32(uint256(verificationGasLimit) << 128 | callGasLimit),
            preVerificationGas: verificationGasLimit,
            gasFees: bytes32(uint256(maxPriorityFeePerGas) << 128 | maxFeePerGas),
            paymasterAndData: hex"",
            signature: hex""
        });
    }
}