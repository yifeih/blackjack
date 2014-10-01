# Author: Yifei Huang
# Date: Nov 13, 2013
#
# This file contains constants and other universal functions that are used
# throughout the Blackjack program. 

# These vaues are indicators for different outcome situations. BLACKJACK
# and LOST refer to both hand-outcome and game-outcome situations. 
# (for hand-outcome, BJ=21, and LOST is when handvalue > 21)
# SURRENDER, DRAW and WIN refer to game-outcome situations between the
# dealer and the player
BLACKJACK = 21  # Blackjack outcome. Card hand = 21
LOST = -1       # Lost outcome. Card hand > 21
DRAW = -2       # When dealer hand is the same value as player hand
WIN = -3        # When the player has a higher hand the the dealer
SURRENDER = -4

# This hashmap maps the indicators to the strings to faciliate the
# generation of the user interface
$outcomeHash = { -1 => "LOST", -2 => "DRAW", -3 => "WIN", -4=> "SURRENDER",
	21 => "BLACKJACK"}

# method toPositiveInt
# Params: @a (String), @name (String)
# Return: a (int)
# Raises: ArgumentError
# This method checks whether a given input @a is a string representation of
# a positive integer value. If so, it returns it. If not, it raises an
# ArgumentError exception. In the exception, it details @name as the real-world
# value that @a is to represent.
def toPositiveInt(a, name)
  begin
    a_int = Integer(a)
    if a_int <= 0
      raise ArgumentError
    else
      a_int
    end
  rescue ArgumentError
    raise ArgumentError, name + " entered is not a positive integer. Try Again."
  end
end