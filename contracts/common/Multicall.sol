// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.19;

import '../interfaces/common/IMulticall.sol';
import '../common/library/UncheckedIncrement.sol';

/// NOTE: from https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/Multicall.sol
/// @title Multicall
/// @notice Enables calling multiple methods in a single call to the contract
abstract contract Multicall is IMulticall {
    using UncheckedIncrement for uint;

    /// @inheritdoc IMulticall
    function multicall(bytes[] calldata data) public payable virtual override returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint i; i < data.length; i = i.uinc()) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);

            if (!success) {
                // Next 5 lines from https://ethereum.stackexchange.com/a/83577
                if (result.length < 68) revert();
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }

            results[i] = result;
        }
    }
}
