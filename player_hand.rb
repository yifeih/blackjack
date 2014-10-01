# Author: Yifei Huang
# Date: Nov 11, 2013
# 
# This file specifies information about a PlayerHand. PlayerHand extends
# the class Hand.

require 'hand'

# PlayerHand represents a player's hand. In addition to extending Hand, a 
# player's hand has a bet and name associated with it. It also has an 
# indicator for whether it has doubled down, and whether the hand's
# first turn has passed.
# Furthermore, there are hitting, doubling down, splitting, and surrender
# options associated with PlayerHand. Also, getResult will return the result
# of this hand's game given the dealer's input. 
class PlayerHand < Hand

  # PlayerHand.initialize
  # Params: name of the hand, and a bet associated with the hand.
  # Set the bet and the name. Allow double-down by default. The name is
  # usually just an index, used to refer to the hand in the terminal interface.
  def initialize(name, bet)
    @bet = toPositiveInt(bet, "Bet amount")  # make sure bet is a positive int!
    super
    @doubledown = false
    @name = name.to_s
    @first_turn = true
  end

  # PlayerHand.addCard
  # This overrides the addCard class of the superclass
  # If the card was successfully added by the superclass addCard method
  # then this hand also updates @can_get_cards indicator according to the
  # rules of doubling down (when you double down, you can't draw more than
  # one more card, making at most 3 in total per hand)
  def addCard(card)
    if super
      if @doubledown and @cards.length >= 3
        @can_get_cards = false
      end
    end
  end

  # PlayerHand.getName
  # Accessor method for the PlayerHand's name
  def getName
    @name
  end

  # PlayerHand.isFirstTurn
  # Accesor method for the first-turn indicator. Returns true if this is the 
  # hand's first move
  def isFirstTurn
    @first_turn
  end

  # PlayerHand.getBet
  # Accessor method for the bet. Returns the current bet on this hand.
  def getBet
    @bet
  end

  # PlayerHand.hit
  # Add another card to the hand. addCard checks if the hand is allowed to
  # take more cards, and will raise a ArgumentError if not.
  # Also, this is a turn, so set the first-turn indicator to false.
  def hit(deck)
    addCard(deck.removeCard) # Can raise an ArgumentError if adding is not allowed
    @first_turn = false
  end

  # PlayerHand.raiseBet
  # Param: amount to increase the bet by. 
  # If the value entered is an integer, raise the bet. Otherwise, throw an
  # ArgumentError
  def raiseBet(amount)
    amount = toPositiveInt(amount, "Bet-raise amount")      
    @bet += amount
  end

  # PlayerHand.doubledown
  # Param: new-bet-amount. Adds this new-bet-amount to the current bet of the
  # hand only if the new-bet-amount doesn't exceed the old bet. Otherwise,
  # raise a RangeError.
  # Also, only allows the player to doubledown if it's the hand's first turn.
  # Otherwise, it throws an ArgumentError.
  # If the update was successful, set the doubledown and first_turn indicators.
  def doubledown(amount)
    if amount <= @bet and @first_turn
      raiseBet(amount)
      @doubledown = true
      @first_turn = false
    elsif amount > @bet
      raise RangeError, "You can only double up to your original bet."
    elsif not @first_turn
      raise ArgumentError,"You can only doubledown on the first move on a hand."
    else
      raise ArgumentError
    end
  end

  # PlayerHand.canSplit
  # Checks the hand for conditions on splitting. Returns true if the
  # hand can be split (there are exactly two card that have same face value).
  # Otherwise, returns false.
  def canSplit
    if @cards.length == 2 and @cards[0].getValue == @cards[1].getValue
      true
    else
      false
    end
  end

  # PlayerHand.split
  # If the hand can be split, and it's the hand's first turn, then remove a 
  # card and return it. 
  # If the hand cannot be split or it's not the hand's first turn, then
  # raise an ArgumentError.
  def split
    if canSplit and @first_turn
      card = @cards.pop
    elsif not canSplit
      raise ArgumentError, "This hand cannot be split."
    elsif not @first_turn
      raise ArgumentError, "You can only split on the hand's first move."
    else
      raise ArgumentError
    end
    card
  end

  # PlayerHand.getResult 
  # Param: dealer_outcome
  # Returns the game-outcome of this deck, given the hand of the dealer 
  # (either a Blackjack, loss, or a hand value between 0 and 21).
  # Returns is either BLACKJACK, DRAW, WIN or LOST
  def getResult(dealer_outcome)
    this_hand_outcome = checkHand
    # When this hand is a blackjack - DRAW if dealer=BJ, BJ otherwise
    if this_hand_outcome == BLACKJACK
      case dealer_outcome
      when BLACKJACK then DRAW
      else BLACKJACK
      end
    # When hand isn't a blackjack - WIN if dealer lost, or got a smaller value
    # draw if dealer got the same value, and the player LOST otherwise
    elsif checkHand > 0
      case dealer_outcome
      when LOST then WIN
      when 1..(this_hand_outcome-1) then WIN
      when this_hand_outcome then DRAW
      else LOST
      end
    else
      LOST
    end
  end

  # PlayerHand.printCards
  # Returns a string of the output format of this instance of hand.
  # The string looks like this:
  # <card-value>:<card-suit> <card-value>:<card-suit> ...
  def printCards
    printArray = printCardsArray
    to_print = ""
    printArray.each do |card_string|
      to_print += card_string
    end
    to_print + "\n"
  end

end

