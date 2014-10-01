# Author: Yifei Huang
# Date: Nov 11, 2013
#
# This file includes specifications for a single Card object for a game of
# blackjack.

# The Card class simulates a card in a 52-card deck, each with a suit and 
# a face value
class Card
  
  # Card.initialize
  def initialize(value, suit)
    @value = value
    @suit = suit
  end
  
  # Card.getValue
  # Gets all the possible numeric vales of the card (i.e. A can be 1 or 11),
  # and returns them in an array
  def getValue
    case @value
    when 'A' then [1,11]
    when 'J', 'Q', 'K' then [10]
    else [(@value).to_i]
    end
  end

  # Card.getName
  # Returns the string format of the card:
  # "face-value : suit"
  def getName
    @value + ":" + @suit + " "
  end

end