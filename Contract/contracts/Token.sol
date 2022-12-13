// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./safeMath.sol";
import "./IToken.sol";
import "./Ownable.sol";
import "./context.sol";

contract Token is IToken, context, ownable {

    mapping (address => uint256) private _balances;
    mapping (address => mapping(address => uint256)) private _allowance;

    uint256 private _totalSupply;
    uint256 private _cap;
    uint8 private _decimals;
    string private _name;
    string private _symbol;

    constructor(string memory _Name, string memory _Symbol, uint8 _Decimals, uint256 _Cap, uint256 _TotalSupply) public {
        _name = _Name;
        _symbol = _Symbol;
        _decimals = _Decimals;
        _cap = _Cap;
        _totalSupply = _TotalSupply;
        address msgSender = _msgSender();
        _balances[msgSender] = _totalSupply;
        emit Transfer (address(0), msgSender, _totalSupply);


    }

    function totalSupply() external view returns (uint256){
        return _totalSupply;
    }

    function decimals() external view returns (uint256){
        return _decimals;
    }

    function name() external view returns (string memory){
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    function getOwner() external view returns (address){
        return _msgSender();
    }
    
    function balanceOf (address account) external view returns (uint256){
        return _balances[account];
    }

    function _transfer (address sender, address receipt, uint256 amount)internal {
        require(sender != address(0));
        require(receipt != address(0));
        _balances[sender] = safeMath.subtract(_balances[sender], amount);
        _balances[receipt] = safeMath.add(_balances[receipt], amount);
        emit Transfer(sender, receipt, amount);
    }

    function transfer (address receipt, uint256 amount) external returns (bool){
        _transfer(_msgSender(), receipt, amount);
        return true;
    }
 
    function _approve (address owner, address spender, uint256 amount) internal {
        require(owner != address(0));
        require(spender != address(0));
        _allowance[owner][spender] = amount;
        emit approval(owner, spender, amount);
    }

    function approve (address spender, uint256 amount) external returns (bool){

    }

     function allowance (address owner, address spender) external view returns (uint256){
        return _allowance[owner][spender];
    }

    function transferFrom (address sender, address receipt, uint256 amount) external returns (bool){
        _transfer(sender, receipt, amount);
        _approve(sender, _msgSender(), safeMath.subtract(_allowance[sender][_msgSender()], amount));
        return true;
    }

    function increaseAllowance(address spender, uint256 addValue) public returns (bool) {
        _approve(_msgSender(), spender, safeMath.add(_allowance[_msgSender()][spender], addValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractValue) public returns (bool) {
        _approve(_msgSender(), spender, safeMath.subtract(_allowance[_msgSender()][spender], subtractValue));
        return true;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0));
        _totalSupply = safeMath.add(_totalSupply, amount);
        _balances[account] = safeMath.add(_balances[account], amount);
        emit Transfer (address(0), account, amount);
    }

    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;   
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0));
        _totalSupply = safeMath.subtract(_totalSupply, amount);
        _balances[account] = safeMath.subtract(_balances[account], amount);
        emit Transfer (address(0), account, amount);
    }

    function burn(uint256 amount) public onlyOwner returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function burnFrom(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
        _approve(account, _msgSender(), safeMath.subtract(_allowance[account][_msgSender()], amount));
    }
    
    function _mintCap (address account, uint256 amount) internal {
        require(_totalSupply + amount <= _cap);
        _mint(account, amount);

    }

    function mintCap(uint256 amount) public onlyOwner{
        require(_cap > 0);
        _mintCap(_msgSender(), amount);
    }
} 