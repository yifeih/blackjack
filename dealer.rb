# Author: Yifei Huang
# Date: Nov 11, 2013
#
# This file specifies information about a Dealer in a blackjack game. It 
# extends the Person class.
# A Dealer can only hold one hand. 

require 'person'
require 'dealer_hand'

# The Dealer is a person that can only hold one hand of cards. This is
# reflected in the createNewHand and modified addHand methods.
# Also, the Dealer has methods which determine whether he should keep
# dealing himself cards or not, and functions for adding cards to his
# only hand.
class Dealer < Person

  def initialize(name=nil)
    super
  end

  # Dealer.createNewHand
  # Param: Deck from which to take the cards from
  # Creates a new DealerHand instance, adds two cards to start the hand
  # and places it in the array of this dealer.
  def createNewHand(deck, bet=nil)
  	if @hands.empty?
  	  hand = DealerHand.new()
  	  hand.addCard(deck.removeCard)
      hand.addCard(deck.removeCard)
      addHand(hand)
  	end
  end

  # Dealer.addHand
  # Only add the hand if the current hand of the Dealer is empty. This
  # overrides the superclass's addHand method.
  def addHand(hand)
    if @hands.empty?
      super
    end
  end

  # Dealer.shouldHit
  # Returns true if the dealer can hit. A Dealer must hit if his hand
  # has a value of below 17
  def shouldHit
    # If 17 or above, lock the hand so it cannot receive any more cards
  	if @hands[0].checkHand > 16 or @hands[0].checkHand < 0
  	  @hands[0].lock
  	end
  	@hands[0].canGetCards
  end

  # Dealer.dealSelf
  # Param: The deck to take cards from. This methods places the card at the
  # top of the deck in the dealer's hand.
  def dealSelf(deck)
  	@hands[0].addCard(deck.removeCard)
  end

  # Dealer.dealSelf
  # Returns the result of the Dealer's hand in terms of the constants
  # in utilities.rb (i.e. LOST or BLACKJACK). If it the dealer neither
  # lost or got blackjack, then it returns the best (highest) of his hand 
  # values.
  def getResult
  	@hands[0].checkHand
  end

  # Dealer.printHands
  # Returns a string of how the output of the dealer's hand should be displayed.
  # The output is of the format:
  # Dealer: <card-value>:<card-suit> <card-value>:<card-suit> ...
  # Param: if hide_card is true, then the last card is output as "X:X"
  #        otherwise, print normally.
  def printHands(hide_card=true)
    to_print = "\nDealer: " + @hands[0].printCards(hide_card)
  end


end

