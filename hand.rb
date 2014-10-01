# Author: Yifei Huang
# Date: Nov 11, 2013
# 
# This file specifies information about a Hand. A hand contains an array
# of cards. 
# Both DealerHand and PlayerHand extend Hand.

require 'deck' 
require 'card'
require 'set'
require 'utilities'

# A hand contains an array of Cards, which belong to the hand, and an 
# indicator specifying whether cards can be added to the hand.
class Hand

  # Hand.initialize
  # Creates an array of cards, and allow cards to be added to the hand.
  def initialize(name=nil, bet=nil)
  	@cards = []
    @can_get_cards = true
  end

  # Hand.addCard
  # Param: Card to be added. Adds card to the hand only if it is a card and
  # the hand can receive cards
  def addCard(card)
  	if @can_get_cards
  	  @cards.push(card)
    else
      raise ArgumentError, "Cards cannot be added to this hand anymore."
  	end
  end

  # Hand.removeCard
  # Param: Card to be removed. If the card is in the array, remove it and
  # return it. Otherwise, return nil.
  def removeCard(card)
    @cards.delete(card)
  end

  # Hand.canGetCards
  # Accessor function. Returns true if this hand can receive cards.
  def canGetCards
    @can_get_cards
  end

  # Hand.lock
  # Locks the hand. This does not allow any more cards to be placed in it.
  # Thus, it is a modifier function for @can_get_cards
  def lock
    @can_get_cards = false
  end

  # Hand.CheckHand
  # Returns the result of the hand. Returns BLACKJACK or LOST if the hand
  # is a blackjack or above blackjack, respectively. Otherwise, returns the
  # the best (highest) hand valuess.
  def checkHand
    possible_hands = possibleHandValues
    if possible_hands.include?(21)
      return BLACKJACK
    elsif possible_hands.empty?
      return LOST
    else
      return possible_hands.max
    end
  end

  # Hand.printCardsArray
  # Returns an array of strings. The elements are the string-formats of
  # each card in the hand.
  def printCardsArray
    cards_as_string = []
    @cards.each do |card|
      cards_as_string.push(card.getName)
    end
    cards_as_string
  end
  
  # Hands.possibleHandValues
  # Returns a set of the possible numeric values associated with this hand. 
  # If there are no values below BLACKJACK, then return the empty set.
  #
  # Start with a set with the value 0. For each card in the hand, add its 
  # possible values to all the values in the set from the previous iteration. 
  # Filter out the values that are forbitten (above 21).
  # Return the remaining list. 
  # This is a helper function to 
  def possibleHandValues
  	hand_values = Set.new [0]              # start with value 0
  	@cards.each do |card|                  # for each card in the hand
  	  card_values = card.getValue
  	  new_hand_values = Set.new            # add its value to all the possible
  	  hand_values.each do |total|          # values for each of the previous
  	  	card_values.each do |card_value|   # cards
          new_hand_values << total+card_value
        end
      end
      # Swap variable names. This makes the loop simpler
      new_hand_values, hand_values = hand_values, new_hand_values
      new_hand_values.clear
    end
    # Get the values that are below 21
    hand_values.delete_if do |value|
      if value > BLACKJACK
        true
      end
    end
    hand_values # Return set of possible values
  end

end



      