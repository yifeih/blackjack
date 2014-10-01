# Author: Yifei Huang
# Date: Nov 13, 2013
#
# This flie contains functions that deal with the user interface of the 
# Blackjack program. 
#

# printSetupInstr
# Params: player. Prints the instructions to set up a round, asking each player
# for a bet amount. 
def printSetupInstr(player)
  puts "Player " + player.getName + ", you have $" + player.getMoney.to_s + \
    ". What is your starting bet?"
  puts "Also, enter 'quit' if you want to quit."
end

# printBeginRoundMessage
# Prints "--- BEGIN ROUND # ---"
def printBeginRoundMessage(num)
  puts "--- BEGIN ROUND " + num + " ---"
end

# printGameState
# Prints the state of the entire game: dealer hand and player hands.
# Asks for a key-input to continue.
# PARAM: If hide_dealer_card is true, the last card of the dealer will not
# be revealed
def printGameState(hide_dealer_card=true)
  puts "--- TABLE STATE ---"
  puts @dealer.printHands(hide_dealer_card)
  @players.each do |player|
    puts player.printHands
  end
  pressKeyToContinue
end

# printAskUserInstr
# Given the player, dealer, and the hand, it prints out the instructions that
# ask for the user move on a hand, and information needed for that user
# to make such a move. This includes (in order):
# Dealer's Hand (hiding the last card)
# Each hand belonging to the player
# Question: Ask for input from <player name> for <hand name>
# The allowed moves for this query
def printAskUserInstr(player,dealer,hand)
  puts dealer.printHands(true)
  puts player.printHands
  puts "Player " + player.getName + ", what would you like to do on Hand " + hand.getName + "?"
  if hand.isFirstTurn and (player.getHands.length == 1)
    puts "'dd'=doubledown 'split'=split 'surr'=surrender 'hit'=hit 'stay'=stay"
  elsif hand.isFirstTurn and player.canSplit
  	puts "dd'=doubledown 'split'=split 'hit'=hit 'stay'=stay"
  elsif hand.isFirstTurn
    puts "dd'=doubledown 'hit'=hit 'stay'=stay"
  else
    puts "'hit'=hit 'stay'=stay"
  end
end

# printEmptyHandMessage
# Prints the message that signals to the user that his hand lost.
# Require key input to continue
def printEmptyHandMessage(player, dealer)
  puts dealer.printHands(true)
  puts player.printHands
  puts "Uh oh. This hand is now over 21. Sorry :("
  pressKeyToContinue
end

# printNoMoreHandsMessage
# Prints the message that signals to the player that he does not have any more
# valid cards in this round, and he will thus be removed from this round
def printNoMoreHandsMessage
  puts "Looks like you don't have more valid hands. Sorry :("
  pressKeyToContinue
end

# printDealerGetCards
# Prints this message when all the players are done making their moves, and
# so the dealer must now reveal his cards and (maybe) add to the deck.
# Then, it prints the entire table's state (with the daler's card revealed)
# and waits for key input
def printDealerGetCards
  puts "And now the dealer will reveal his cards..."
  pressKeyToContinue
  printGameState(false)
end

# printTurnOver
# Given a player, it will inform to the user that this player's turn is over,
# and remind the player of his hand(s) one more time by printing his hand out.
# Then, waits for key-input
def printTurnOver(player)
  puts "Player " + player.getName + ", your turn is now over. Here are your hand(s):"
  puts player.printHands
  pressKeyToContinue
end

# pressKeyToContinue
# Waits for user input, and prints out a message informing the user that any
# key pressed will allow the program to continue
def pressKeyToContinue
  puts "\n-- press any key to continue --"
  gets
end

# printSurrenderMessage
# Prints this message when a user decides to surrender
def printSurrenderMessage
  puts "Aww it's sad to see you go so early. Better luck next round!"
  pressKeyToContinue
end

# printOutcomeMessage
# Given a hand, it prints out the outcome of the hand informing the users what
# the outcome of their hands are
def printOutcomeMessage(hand, outcome)
  puts "\tHand " + hand.getName + " result is: " + $outcomeHash[outcome]
end

# printAllPlayersLost
# Prints this message when all players have either lost, quit, or surrendered
# a game. This signals that the round is over, and the dealer doesn't even
# need to deal out his deck.
def printAllPlayersLost
  puts "Looks like all the players lost. Better luck next round!"
  pressKeyToContinue
end

# printBankruptMessage
# Prints this message when a player goes bankrupt, informing the user
# that he is no longer in the game
def printBankruptMessage(player)
  puts "Player " + player.getName + ", you are now bankrupt and must leave"\
    " the game. Sorry! Better luck next time!"
end
