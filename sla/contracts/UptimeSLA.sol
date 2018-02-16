pragma solidity ^0.4.18;

import "chainlink/solidity/contracts/Chainlinked.sol";
import "chainlink/solidity/contracts/Chainlink.sol";

contract UptimeSLA is Chainlinked {
  uint256 private requestId;
  bytes32 public currentPrice;

  function UptimeSLA(address _oracle) public {
    oracle = Oracle(_oracle);
  }

  function requestEthereumPrice(string _currency) public {
    Chainlink.Run memory run = newRun("someJobId", this, "fulfill(uint256,bytes32)");
    run.add("url", "https://etherprice.com/api");
    string[] memory path = new string[](2);
    path[0] = "recent";
    path[1] = _currency;
    run.add("path", path);
    requestId = chainlinkRequest(run);
  }

  function fulfill(uint256 _requestId, bytes32 _data)
    public
    onlyOracle
    checkRequestId(_requestId)
  {
    currentPrice = _data;
  }

  modifier checkRequestId(uint256 _requestId) {
    require(requestId == _requestId);
    _;
  }

}
