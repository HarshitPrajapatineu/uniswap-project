// SPDX-License-Identifier: GPL-3.0-or-later

//solhint-disable-next-line compiler-version
pragma solidity ^0.8.10;

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}
