// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20,IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyMock} from "@openzeppelin/contracts/mocks/ReentrancyMock.sol";

/**
 * @title BFT
 * @author Jitendra Kumar
 * @dev ERC20 token with an initial supply distributed among predefined stakeholders.
 */
contract BFT is ERC20, Ownable, ReentrancyMock {
    /// @notice Total initial supply of tokens.
    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18; 

    /// @notice Percentage of total supply allocated to the team.
    uint256 public constant TEAM_PERCENTAGE = 20; 
    /// @notice Percentage of total supply allocated to marketing.
    uint256 public constant MARKETING_PERCENTAGE = 30; 
    /// @notice Percentage of total supply allocated to development.
    uint256 public constant DEVELOPMENT_PERCENTAGE = 40; 
    /// @notice Percentage of total supply allocated to the community.
    uint256 public constant COMMUNITY_PERCENTAGE = 10; 

    /// @notice Address of the team wallet.
    address public teamWallet;
    /// @notice Address of the marketing wallet.
    address public marketingWallet;
    /// @notice Address of the development wallet.
    address public developmentWallet;
    /// @notice Address of the community wallet.
    address public communityWallet;

    /// @notice Indicates whether the token distribution is completed.
    bool public distributionCompleted;

    /// @dev Event emitted when tokens are distributed to a wallet.
    /// @param to The recipient address.
    /// @param amount The amount of tokens distributed.
    event Distribution(address indexed to, uint256 amount);

    /// @dev Event emitted when wallet addresses are updated.
    /// @param teamWallet The updated team wallet address.
    /// @param marketingWallet The updated marketing wallet address.
    /// @param developmentWallet The updated development wallet address.
    /// @param communityWallet The updated community wallet address.
    event WalletsUpdated(
        address indexed teamWallet,
        address indexed marketingWallet,
        address indexed developmentWallet,
        address communityWallet
    );

    /// @dev Ensures that the provided address is valid (non-zero).
    /// @param _address The address to validate.
    modifier validAddress(address _address) {
        require(_address != address(0), "Invalid wallet address");
        _;
    }

    /**
     * @notice Constructs the TokenLaunch contract.
     * @param _teamWallet Address of the team wallet.
     * @param _marketingWallet Address of the marketing wallet.
     * @param _developmentWallet Address of the development wallet.
     * @param _communityWallet Address of the community wallet.
     */
    constructor(
        address _teamWallet,
        address _marketingWallet,
        address _developmentWallet,
        address _communityWallet
    ) ERC20("BFT", "BFT") Ownable(msg.sender) {
        require(
            _teamWallet != address(0) &&
                _marketingWallet != address(0) &&
                _developmentWallet != address(0) &&
                _communityWallet != address(0),
            "Invalid wallet address"
        );

        teamWallet = _teamWallet;
        marketingWallet = _marketingWallet;
        developmentWallet = _developmentWallet;
        communityWallet = _communityWallet;

        // Mint the initial supply to the contract
        _mint(address(this), INITIAL_SUPPLY);
    }

    /**
     * @notice Distributes the initial token supply to predefined stakeholders.
     * @dev Can only be called by the owner and only once.
     */
    function distributeTokens() external onlyOwner nonReentrant {
        require(!distributionCompleted, "Tokens already distributed");

        uint256 teamAmount = (INITIAL_SUPPLY * TEAM_PERCENTAGE) / 100;
        uint256 marketingAmount = (INITIAL_SUPPLY * MARKETING_PERCENTAGE) / 100;
        uint256 developmentAmount = (INITIAL_SUPPLY * DEVELOPMENT_PERCENTAGE) / 100;
        uint256 communityAmount = (INITIAL_SUPPLY * COMMUNITY_PERCENTAGE) / 100;

        _transfer(address(this), teamWallet, teamAmount);
        emit Distribution(teamWallet, teamAmount);

        _transfer(address(this), marketingWallet, marketingAmount);
        emit Distribution(marketingWallet, marketingAmount);

        _transfer(address(this), developmentWallet, developmentAmount);
        emit Distribution(developmentWallet, developmentAmount);

        _transfer(address(this), communityWallet, communityAmount);
        emit Distribution(communityWallet, communityAmount);

        distributionCompleted = true;
    }

    /**
     * @notice Updates the wallet addresses for stakeholders.
     * @param _teamWallet The new team wallet address.
     * @param _marketingWallet The new marketing wallet address.
     * @param _developmentWallet The new development wallet address.
     * @param _communityWallet The new community wallet address.
     */
    function updateWallets(
        address _teamWallet,
        address _marketingWallet,
        address _developmentWallet,
        address _communityWallet
    ) external onlyOwner {
        require(
            _teamWallet != address(0) &&
                _marketingWallet != address(0) &&
                _developmentWallet != address(0) &&
                _communityWallet != address(0),
            "Invalid wallet address"
        );

        teamWallet = _teamWallet;
        marketingWallet = _marketingWallet;
        developmentWallet = _developmentWallet;
        communityWallet = _communityWallet;

        emit WalletsUpdated(_teamWallet, _marketingWallet, _developmentWallet, _communityWallet);
    }

    /**
     * @notice Recovers tokens accidentally sent to the contract.
     * @param tokenAddress The address of the token to recover.
     * @param amount The amount of tokens to recover.
     * @dev Cannot be used to recover the launch tokens.
     */
    function recoverTokens(address tokenAddress, uint256 amount) external onlyOwner nonReentrant {
        require(tokenAddress != address(this), "Cannot recover launch tokens");
        IERC20(tokenAddress).transfer(owner(), amount);
    }
}
