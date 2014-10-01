# Author: Yifei Huang
# Date: Nov 11, 2013
#
# This file specifies information about a Player in a blackjack game. It 
# extends the Person class.
# A Player can hold multiple hands, has a name, has some money and
# has a count specifying the number of splits 

require 'person'
require 'player_hand'

MAX_HANDS = 4 # The max number of hands a player is allowed to create in a 
              # round. This means a player is allowed to split a max of 3
              # times
# The payouts for the Players given each outcome. This includes the sum of
# money that they placed as their bet.
BJ_PAYOUT = 2.5
WIN_PAYOUT = 2
DRAW_PAYOUT = 1
SURR_PAYOUT = 0.5

# A Player holds an array of PlayerHands, a name, some money (always an 
# integer), an indicator of whether he has surrendered, and a counter of
# all the hands he has created in a certain round.
class Player < Person

  # Player.initialize
  # Param: The string, which will be set as the name of the player.
  # The function then sets the initial money to 1000. The player does not
  # surrender on creation, and initially has 0 cards.
  def initialize(name)
  	super
  	@name = name.to_s  # String format of the player's name
  	@money = 1000      # Starting money amount. Money is always an integer.
    @surrender = false
    @num_hands_on_round = 0
  end

  # Player.getName
  # Accessor function for the Player's name.
  def getName
    @name
  end

  # Player.getMoney
  # Accessor function for the Player's money amount
  def getMoney
    @money
  end

  # Player.hasSurrendered
  # Accessor function for the Player's surrender indicator. Returns true if
  # the player has surrendered.
  def hasSurrendered
    @surrender
  end

  # Player.isBankrupt
  # Returns true if the player is bankrupt. 
  def isBankrupt
    @money < 1
  end

  # Player.createNewHand
  # Param: The deck to use, and the initial bet on the hand.
  # Adds a newly initialized PlayerHand with 2 cards to this player's hand. 
  # Then, it updates the count of the Players' hand.
  def createNewHand(deck, bet)
  	if makeBet(bet)
  	  hand = PlayerHand.new(@num_hands_on_round+1, bet)
  	  hand.addCard(deck.removeCard)
  	  hand.addCard(deck.removeCard)
      addHand(hand)
      @num_hands_on_round += 1
  	end
  end

  # Player.resetPlayerForNewRound
  # Returns the surrender and number-of-hands indicators to their starting
  # values (not surrender, and 0 hands) for the start of a new round.
  def resetPlayerForNewRound
     @surrender = false
     @num_hands_on_round = 0
  end

  # Player.makeBet
  # Param: Amount to bet. If this bet is allowed, it will will subtract the
  # bet amount from this user's money and return true. Otherwise, it will
  # will throw an RangeError exception. 
  def makeBet(bet)
    if canMakeBet(bet)
      @money -= bet
      true
    else
      raise RangeError, "You don't have enough money :("
    end
  end

  # Player.canMakeBet
  # Param: Bet to be made.
  # Checks whether the player has enough money to make a bet. If so, return
  # true. Otherwise, return false.
  def canMakeBet(bet)
    bet = toPositiveInt(bet, 'Bet-amount')
  	if bet <= @money
      true
    else
      false
    end
  end

  # Player.canSplit
  # Returns true if the player can make another split
  def canSplit
  	@num_hands_on_round < MAX_HANDS
  end

  # Player.splitHand
  # Param: hand to be split, and the deck used to add card to it. 
  # If the hand can be split, then it creates a new Hand, takes one of the
  # cards from the passed in hand, and places it in the new hand. Then it
  # fills both hands to 2-cards.
  # Finally, adds the new cards to belong to this Player, and updates the
  # count on the number of hands created for this round.
  def splitHand(hand, deck)
  	if canSplit and @hands.include? hand and canMakeBet(hand.getBet)
      card = hand.split    # Can throw an Argument error if this hand does not
      makeBet(hand.getBet) # allow splitting.
      new_hand = PlayerHand.new(@num_hands_on_round + 1, hand.getBet)
      new_hand.addCard(card)
      new_hand.addCard(deck.removeCard)
      hand.addCard(deck.removeCard)
      @hands.push(new_hand)
      @num_hands_on_round += 1
    elsif not canSplit
      raise ArgumentError, "You have maxed out your splitting limit."
    elsif not @hands.include? hand
      raise ArgumentError, "Weird. It seems like this isn't your hand."
    elsif not canMakeBet(hand.getBet)
      raise ArgumentError, "You don't have enough money to make this bet."
    else
      raise ArgumentError
    end
  end

  # Player.doubledown
  # Param: the hand to double down on, and the amount to double.
  # If the amount of money entered is valid for this Player, then proceed
  # with doublingdown. Otherwise, raise a RangeError.
  def doubledown(hand, amount)
  	if canMakeBet(amount)
  	  hand.doubledown(amount) # Can raise an Error if doubledown is not allowed
  	  makeBet(amount)         # on this hand, or if amount is not appropriate
    else
      raise RangeError, "You don't have enough money :("
  	end
  end

  # Player.canSurrender
  # Returns true if the player can surrender (holds only 1 hand, since the
  # player can only surrender on his first turn ever.)
  def canSurrender
    if @hands.length == 1
      true
    end
  end

  # Player.surrender
  # Checks if the player can surrender (if he holds only one hand, and if
  # he hasn't acted on that hand). If so, removes this hand from this player
  # processes the result of "surrendered", and marks this player as 
  # surrendered.
  # If the player can't surrender, it will raise an ArgumentError
  def surrender
    if canSurrender and @hands[0].isFirstTurn
      removeHand(@hands[0], SURRENDER)
      @surrender = true
    else
      raise ArgumentError, "You can only surrender on the first turn " \
        "on your first hand."
    end
  end

  # Player.removeHand
  # This overrides the removeHand option of the Person class.
  # Param: hand to be removed, and the hand's outcome in comparison to the
  #   dealer
  # If the passed exists for this user, remove it, and update this user's
  # money based on the outcome
  # Otherwise, return nil.
  def removeHand(hand, outcome)
    if super  # If removal was successful (i.e. hand exists for this user.)
      if outcome == BLACKJACK
        @money += Integer((BJ_PAYOUT*hand.getBet).ceil)
      elsif outcome == WIN
        @money += Integer((WIN_PAYOUT*hand.getBet).ceil)
      elsif outcome == DRAW
        @money += Integer((DRAW_PAYOUT*hand.getBet).ceil)
      elsif outcome == SURRENDER
        @money += Integer((SURR_PAYOUT*hand.getBet).ceil)
      end
    else
      nil
    end
  end

  # Player.removeLostHands
  # Processes the result and removes each hand belonging to this player
  # that has busted.
  def removeLostHands
    to_be_removed = []
    @hands.each do |hand|
      if hand.checkHand == LOST
        to_be_removed.push(hand)
      end
    end
    to_be_removed.each do |hand|
      removeHand(hand, LOST)
    end
  end

  # Player.processAndRemoveHands
  # Processes the result and removes each hand belonging to this player,
  # given the outcome of the dealer. 
  def processAndRemoveHands(dealer_outcome)
    while not @hands.empty?
      outcome = @hands[0].getResult(dealer_outcome)
      removeHand(@hands[0], outcome)
    end
  end

  # Player.printHands
  # Returns a string of how the output of the player's hand should be displayed.
  # The output is of the format:
  # Player <name> | Money left $<money>
  #   Hand <name>: (Bet: <bet>)  <card-value>:<card-suit> <card-value>:<card-suit> ...
  #   Hand <name>: (Bet: <bet>)  <card-value>:<card-suit> <card-value>:<card-suit> ...
  # ...
  def printHands
    to_print = "\nPlayer " + @name + " | Money left: $" + @money.to_s
    unless @hands.nil?
      @hands.each do |hand|
        to_print = to_print +  "\n\tHand " + hand.getName + " (Bet: " + \
          hand.getBet.to_s + ")"
        to_print = to_print + "\t"
        card_strings = hand.printCardsArray
        card_strings.each do |card_name|
          to_print += card_name
        end
      end
      to_print
    end
    to_print
  end

end
