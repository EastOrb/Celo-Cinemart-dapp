// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MovieStore
 * @dev A simple contract for buying and selling movies.
 */
contract MovieStore {
    
    struct Movie {
        address productionCo;   // The address of the production company that created the movie.
        string title;           // The title of the movie.
        string director;        // The director of the movie.
        string image;           // The URL of an image for the movie.
        string description;     // A brief description of the movie.
        uint256 price;          // The price of the movie in wei.
        uint copiesAvailable;   // The number of copies of the movie available for purchase.
    }
    
    uint public movieCount;                 // The total number of movies in the store.
    mapping(uint => Movie) public movies;   // A mapping of movie IDs to their respective Movie struct.
    mapping(address => bool) public authorized;  // A mapping of authorized addresses for adding movies.
    
    event MovieAdded(uint indexed id, string title, string director);    // Event emitted when a new movie is added.
    event MoviePurchased(uint indexed id, string title, string director);    // Event emitted when a movie is purchased.
    
    /**
     * @dev Initializes the contract and authorizes the contract deployer to add movies.
     */
    constructor() {
        authorized[msg.sender] = true;
    }
    
    /**
     * @dev Modifier that only allows authorized addresses to perform certain functions.
     */
    modifier onlyAuthorized() {
        require(authorized[msg.sender], "You are not authorized to perform this action.");
        _;
    }
    
    /**
     * @dev Adds a new movie to the store.
     * @param _title The title of the movie.
     * @param _image The URL of an image for the movie.
     * @param _description A brief description of the movie.
     * @param _director The director of the movie.
     * @param _price The price of the movie in wei.
     * @param _copiesAvailable The number of copies of the movie available for purchase.
     */
    function addMovie(string calldata _title, string calldata _image, string calldata _description, string calldata _director, uint256 _price, uint _copiesAvailable) public onlyAuthorized() {
        movieCount++;
        movies[movieCount] = Movie(msg.sender, _title, _director, _image, _description, _price, _copiesAvailable);
        emit MovieAdded(movieCount, _title, _director);
    }
    
    /**
     * @dev Allows a user to purchase a movie.
     * @param _movieId The ID of the movie to purchase.
     */
    function buyMovie(uint256 _movieId) public payable {
        require(movies[_movieId].copiesAvailable > 0, "This movie is out of stock.");
        require(msg.value == movies[_movieId].price, "The amount sent is not enough to purchase this movie.");
        movies[_movieId].copiesAvailable--;
        emit MoviePurchased(_movieId, movies[_movieId].title, movies[_movieId].director);
    }
    
    /**
     * @dev Returns information about a specific movie.
     * @param _movieId The ID of the movie to retrieve.
     * @return The production company address, title, director, image URL, description, price, and number of copies available for the movie.
     */
    function getMovie(uint256 _movieId) public view returns (address, string memory, string
