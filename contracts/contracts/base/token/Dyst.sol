// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "../../interface/IERC20.sol";

contract Dyst is IERC20 {
	string public symbol = "OMNI";
	string public name = "Omnitopia token";
	uint8 public decimals = 18;
	uint public totalSupply = 0;
	mapping(address => uint) public balanceOf;
	mapping(address => mapping(address => uint)) public allowance;
	address public minter;

	constructor() {
		minter = msg.sender;
		_mint(msg.sender, 0);
	}

	function setMinter(address _minter) external {
		require(msg.sender == minter, "OMNI: Not minter");
		minter = _minter;
	}

	function approve(address _spender, uint _value) external override returns(bool) {
		require(_spender != address(0), "OMNI: Approve to the zero address");
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function _mint(address _to, uint _amount) internal returns(bool) {
		require(_to != address(0), "OMNI: Mint to the zero address");
		balanceOf[_to] += _amount;
		totalSupply += _amount;
		emit Transfer(address(0x0), _to, _amount);
		return true;
	}

	function _transfer(address _from, address _to, uint _value) internal returns(bool) {
		require(_to != address(0), "OMNI: Transfer to the zero address");
		uint fromBalance = balanceOf[_from];
		require(fromBalance >= _value, "OMNI: Transfer amount exceeds balance");

		balanceOf[_to] += _value;
		emit Transfer(_from, _to, _value);
		return true;
	}

	function transfer(address _to, uint _value) external override returns(bool) {
		return _transfer(msg.sender, _to, _value);
	}

	function transferFrom(address _from, address _to, uint _value) external override returns(bool) {
		address spender = msg.sender;
		uint spenderAllowance = allowance[_from][spender];
		if (spenderAllowance != type(uint).max) {
			require(spenderAllowance >= _value, "OMNI: Insufficient allowance");

		}
		return _transfer(_from, _to, _value);
	}

	function mint(address account, uint amount) external returns(bool) {
		require(msg.sender == minter, "OMNI: Not minter");
		_mint(account, amount);
		return true;
	}
}
