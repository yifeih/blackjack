# Author: Yifei Huang
# Date: Nov 11, 2013
#
# This file specifies information about a Person in the game. A person can
# hold multiple hands of cards. 
# Both classes Player and Dealer extend this class.

require 'hand'
require 'utilities'

# A Person has an array of hands. Hands can be added or removed. 
class Person
  
  # Person.initialize
  # Creates an array to hold hands
  def initialize(name=nil)
    @hands = []
  end

  # Person.addHand
  # If the parameter passed is a Hand, adds this hand to the person's 
  # array of hands
  def addHand(hand)
  	if hand.is_a?Hand
      @hands.push(hand)
    end
  end

  # Person.removeHand
  # Removes a specified hand, if it exists in the person's hand. (Hand is
  # passed by reference, so to checks for pointer to the same instance.)
  # Returns the card removed if it exists and has been removed. Otherwise,
  # returns nil.
  def removeHand(hand, outcome=nil)
  	@hands.delete(hand)
  end

  # Person.getHands
  # Returns the array of hands associated with this person
  def getHands
  	@hands
  end

  # Person.handsAreEmpty
  # Returns true if the Person is holding no hands
  def hadNoHands
  	@hands.empty?
  end

  # Person.clearHands
  # Removes all hands from the Person
  def clearHands
    @hands.clear
  end

end



