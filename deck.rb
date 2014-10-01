# Author: Yifei Huang
# Date: Nov 11, 2013
#
# This file creates a deck of cards for the blackjack game. A deck of cards 
# holds the standard 52 cards.

require 'card'
require 'utilities'

# The Deck class simulates a multi-deck pile of cards used for the game,
# holding an array of references to cards, and a pointer to the top of the
# deck.
class Deck

  # Class variables @@faces and @@suits represent the possible faces and
  # suits of cards. These are used to help create the deck.
  @@faces = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  @@suits = ['H', 'D', 'S', 'C']
  
  # Deck.initialize
  # Params: @num_decks (default=8) the number of card decks to be used
  # Creates 52 cards, and creates 52*num_deck references to those
  # cards, storing the array of references as the deck of cards.
  # Also creates pointer to the top of the deck.
  def initialize(num_decks=8)
    @top_of_deck = 0         # pointer to the top of the deck
    oneDeck = createNewDeck  # creates 52 unique cards

    # the @deck variable contains 52*@num_deck references to the 52 cards
    @deck = []
    for i in 1..num_decks
      @deck += oneDeck.shuffle
    end
  end

  private
    # Deck.createNewDeck
    # Returns an array of 52 card objects-references, each representing a card
    # in a 52-card deck.
    def createNewDeck
      new_deck = Array.new
      @@faces.each do |face|
        @@suits.each do |suit|
          card = Card.new(face, suit)
          new_deck.push(card)
        end
      end
      new_deck
    end

  public
    # Deck.shuffle
    # Randomly reorders the card-references in the deck, and resets the 
    # top-of-deck pointer
    def shuffle
      @top_of_deck = 0
      @deck = @deck.shuffle
    end

    # Deck.removeCard
    # Returns the card at the top of the deck, and updates that pointer.
    # If reached the end of the deck, shuffle the deck.
    def removeCard
      card = @deck[@top_of_deck]
      @top_of_deck += 1
      if @top_of_deck == @deck.length
        shuffle
      end
      card
    end

end

