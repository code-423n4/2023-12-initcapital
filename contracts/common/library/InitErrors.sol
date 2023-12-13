// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity >=0.7.1 <0.9.0;

// solhint-disable

/**
 * @dev Reverts if `condition` is false, with a revert reason containing `errorCode`. Only codes up to 999 are
 * supported.
 * Uses the default 'INC' prefix for the error code
 */
function _require(bool condition, uint errorCode) pure {
    if (!condition) _revert(errorCode);
}

/**
 * @dev Reverts if `condition` is false, with a revert reason containing `errorCode`. Only codes up to 999 are
 * supported.
 */
function _require(bool condition, uint errorCode, bytes3 prefix) pure {
    if (!condition) _revert(errorCode, prefix);
}

/**
 * @dev Reverts with a revert reason containing `errorCode`. Only codes up to 999 are supported.
 * Uses the default 'INC' prefix for the error code
 */
function _revert(uint errorCode) pure {
    _revert(errorCode, 0x494e43); // This is the raw byte representation of "INC"
}

/**
 * @dev Reverts with a revert reason containing `errorCode`. Only codes up to 999 are supported.
 */
function _revert(uint errorCode, bytes3 prefix) pure {
    uint prefixUint = uint(uint24(prefix));
    // We're going to dynamically create a revert string based on the error code, with the following format:
    // 'INC#{errorCode}'
    // where the code is left-padded with zeroes to three digits (so they range from 000 to 999).
    //
    // We don't have revert strings embedded in the contract to save bytecode size: it takes much less space to store a
    // number (8 to 16 bits) than the individual string characters.
    //
    // The dynamic string creation algorithm that follows could be implemented in Solidity, but assembly allows for a
    // much denser implementation, again saving bytecode size. Given this function unconditionally reverts, this is a
    // safe place to rely on it without worrying about how its usage might affect e.g. memory contents.
    assembly {
        // First, we need to compute the ASCII representation of the error code. We assume that it is in the 0-999
        // range, so we only need to convert three digits. To convert the digits to ASCII, we add 0x30, the value for
        // the '0' character.

        let units := add(mod(errorCode, 10), 0x30)

        errorCode := div(errorCode, 10)
        let tenths := add(mod(errorCode, 10), 0x30)

        errorCode := div(errorCode, 10)
        let hundreds := add(mod(errorCode, 10), 0x30)

        // With the individual characters, we can now construct the full string.
        // We first append the '#' character (0x23) to the prefix. In the case of 'INC', it results in 0x42414c23 ('INC#')
        // Then, we shift this by 24 (to provide space for the 3 bytes of the error code), and add the
        // characters to it, each shifted by a multiple of 8.
        // The revert reason is then shifted left by 200 bits (256 minus the length of the string, 7 characters * 8 bits
        // per character = 56) to locate it in the most significant part of the 256 slot (the beginning of a byte
        // array).
        let formattedPrefix := shl(24, add(0x23, shl(8, prefixUint)))

        let revertReason := shl(200, add(formattedPrefix, add(add(units, shl(8, tenths)), shl(16, hundreds))))

        // We can now encode the reason in memory, which can be safely overwritten as we're about to revert. The encoded
        // message will have the following layout:
        // [ revert reason identifier ] [ string location offset ] [ string length ] [ string contents ]

        // The Solidity revert reason identifier is 0x08c739a0, the function selector of the Error(string) function. We
        // also write zeroes to the next 28 bytes of memory, but those are about to be overwritten.
        mstore(0x0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
        // Next is the offset to the location of the string, which will be placed immediately after (20 bytes away).
        mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
        // The string length is fixed: 7 characters.
        mstore(0x24, 7)
        // Finally, the string itself is stored.
        mstore(0x44, revertReason)

        // Even if the string is only 7 bytes long, we need to return a full 32 byte slot containing it. The length of
        // the encoded message is therefore 4 + 32 + 32 + 32 = 100.
        revert(0, 100)
    }
}

library Errors {
    // Common
    uint internal constant ZERO_VALUE = 100;
    uint internal constant NOT_INIT_CORE = 101;
    uint internal constant SLIPPAGE_CONTROL = 102;
    uint internal constant CALL_FAILED = 103;
    uint internal constant NOT_OWNER = 104;
    uint internal constant NOT_WNATIVE = 105;
    uint internal constant ALREADY_SET = 106;

    // Input
    uint internal constant ARRAY_LENGTH_MISMATCHED = 200;
    uint internal constant INPUT_TOO_LOW = 201;
    uint internal constant INVALID_INPUT = 202;
    uint internal constant INVALID_TOKEN_IN = 203;
    uint internal constant INVALID_TOKEN_OUT = 204;

    // Core
    uint internal constant POSITION_NOT_HEALTHY = 300;
    uint internal constant POSITION_NOT_FOUND = 301;
    uint internal constant LOCKED_MULTICALL = 302;
    uint internal constant POSITION_HEALTHY = 303;
    uint internal constant INVALID_HEALTH_AFTER_LIQUIDATION = 304;
    uint internal constant FLASH_PAUSED = 305;
    uint internal constant INVALID_FLASHLOAN = 306;
    uint internal constant NOT_AUTHORIZED = 307;
    uint internal constant INVALID_CALLBACK_ADDRESS = 308;

    // Lending Pool
    uint internal constant MINT_PAUSED = 400;
    uint internal constant REDEEM_PAUSED = 401;
    uint internal constant BORROW_PAUSED = 402;
    uint internal constant REPAY_PAUSED = 403;
    uint internal constant NOT_ENOUGH_CASH = 404;
    uint internal constant INVALID_AMOUNT_TO_REPAY = 405;
    uint internal constant SUPPLY_CAP_REACHED = 406;
    uint internal constant BORROW_CAP_REACHED = 407;

    // Config
    uint internal constant INVALID_MODE = 500;
    uint internal constant TOKEN_NOT_WHITELISTED = 501;
    uint internal constant INVALID_FACTOR = 502;

    // Position Manager
    uint internal constant COLLATERALIZE_PAUSED = 600;
    uint internal constant DECOLLATERALIZE_PAUSED = 601;
    uint internal constant MAX_COLLATERAL_COUNT_REACHED = 602;
    uint internal constant NOT_CONTAIN = 603;
    uint internal constant ALREADY_COLLATERALIZED = 604;

    // Oracle
    uint internal constant NO_VALID_SOURCE = 700;
    uint internal constant TOO_MUCH_DEVIATION = 701;
    uint internal constant MAX_PRICE_DEVIATION_TOO_LOW = 702;
    uint internal constant NO_PRICE_ID = 703;
    uint internal constant PYTH_CONFIG_NOT_SET = 704;
    uint internal constant DATAFEED_ID_NOT_SET = 705;
    uint internal constant MAX_STALETIME_NOT_SET = 706;
    uint internal constant MAX_STALETIME_EXCEEDED = 707;

    // Risk Manager
    uint internal constant DEBT_CEILING_EXCEEDED = 800;

    // Misc
    uint internal constant UNIMPLEMENTED = 999;
}
