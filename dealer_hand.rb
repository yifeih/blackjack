# Author: Yifei Huang
# Date: Nov 11, 2013
# 
# This file specifies information about a DealerHand. DealerHand extends
# the class Hand.

require 'hand'

# DealerHand represents the hand of the dealer. 
class DealerHand < Hand

  # DealerHand.initialize
  def initialize(name=nil, bet=nil)
    super
  end

  # DealerHand.printCards
  # Returns a string of the output format of this instance of hand.
  # The string looks like this:
  # <card-value>:<card-suit> <card-value>:<card-suit> ...
  # Param: True if we hide the dealer's last card.
  #        False if we want to show the dealer's last card.
  def printCards(hide_card=true)
    card_strings_array = printCardsArray
    if hide_card                     # If hide the last card, remove the last
      card_strings_array.pop         # string and replace it with "X:X"
      card_strings_array.push("X:X")
    end
    to_print = ""
    card_strings_array.each do |card_string|  # concatenate everything
      to_print += card_string
    end
    to_print + "\n"
  end


end