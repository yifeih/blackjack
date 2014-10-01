# Author: Yifei Huang
# Date: Nov 11, 2013
# 
# This file specifies information about the Rounds in a game. Round receives
# a list of players everytime to execute a round.

require 'deck'
require 'utilities'
require 'output'

# The class holds a deck, a dealer, the round number, and a list of 
# players and quitters for a certain round.
class Round
  
  # Round.initialize
  # Receives the size of the deck (in # of 52-card decks) and creates a deck,
  # dealer, and initializes the round number. 
  # quitters and players are initialized at the beginning of every round.
  def initialize(num_decks)
    @dealer = Dealer.new
    @deck = Deck.new(num_decks)
    @quitters = []
    @players = []
    @round_num = 0
  end

  # Round.playRound
  # Given a list of players, it will play a round.
  # Each round consists of resetting, setting up (dealing initial cards),
  # processing players' moves, deleting players that lost, dealing the dealer,
  # and then checking the game out. In the meantime, it accrues a list of
  # quitters to return to be removed from the entire Game.
  def playRound(players)
    resetRound

    # Figures out who's playing, and their bets
    printBeginRoundMessage(@round_num.to_s)

    # Deals 2 cards per person
    setupRound(players)

    # Asks each player for their input
    @players.each do |player|
      dealPlayer(player)
    end
    # Delete the players from the list for this round if they already busted 21
    deleteEmptyHandedPlayers

    # If there are still players in teh game, allow the dealer to finish his
    # hand
    if not @players.empty?
      printDealerGetCards
      dealDealer
      checkGameOutcome                       # Check outcome of the game
    elsif players.length > @quitters.length  # Notify users why the dealer 
      printAllPlayersLost                    # won't be shown dealing himself
    end

    @quitters  # List of quitters to be removed from the entire Game.
  end

  # Round.resetRound
  # This is run before every round to update the round number, and return
  # the state of the round to a fresh new round.
  def resetRound
    @players.each do |player|
      player.resetPlayerForNewRound
    end
    @players.clear
    @dealer.clearHands
    @deck.shuffle
    @quitters = []
    @round_num += 1    # update round number
  end

  # Round.setupRound
  # This prompts each user for a bet. They can choose to either 'quit' or enter
  # a valid amount. If a user gives an invalid response, prompt them the
  # same thing until a valid response is given. After processeing others,
  # the dealer will start off his own hand.
  #
  # RangeError will be raised if the bet is more than the player owns.
  # ArgumentError will be raised if the argument is not a positive integer.
  def setupRound(players)
    players.each do |player|
      begin
        printSetupInstr(player)   # print statements instructions
        input = gets.strip
        if input == 'quit'        # put in quitters array
          @quitters.push(player)
        else                      # make bet by creating new hand.
          bet_amount = toPositiveInt(input, "Bet amount")
          player.createNewHand(@deck, bet_amount)
          @players.push(player)
        end
      rescue ArgumentError, RangeError => ex
        puts "#{ex.class}: #{ex.message}"
        retry
      end
    end
    if not @players.empty?          # If there are player sin this round, the
      @dealer.createNewHand(@deck)  # dealer should give himself card :D
      printGameState
    end
  end

  # dealPlayer
  # This abstracts the calling for a players' turn. Once their inptus have
  # been called, the correct output should be printed to let the user
  # know what is going on
  def dealPlayer(player)
    askForPlayerMove(player)
    # Now print output based on move-results:
    if player.hadNoHands and (not player.hasSurrendered)
      printNoMoreHandsMessage
    elsif player.hasSurrendered
      printSurrenderMessage
    else
      printTurnOver(player)
    end
  end

  # Round.deleteEmptyHandedPlayers
  # Remove the players without hands from the Players array for this round
  def deleteEmptyHandedPlayers
    @players.delete_if do |player|
      player.hadNoHands
    end
  end

  # Round.dealDealer
  # Give the dealer cards until he shouldn't hit anymore. The dealer reveals
  # his cards one-by-one, so print the entire Table State between every card.
  def dealDealer
    while @dealer.shouldHit
      @dealer.dealSelf(@deck)
      printGameState(false)
    end
  end

  # Round.askForPlayerMore
  # Prompts the user for an input on each one of his cases, and then processes
  # the input. There may be many errors, hence the begin...rescue. 
  def askForPlayerMove(player)
    puts "---Player " + player.getName + "'s turn---"
    player.getHands.each do |hand|
      while hand.canGetCards
        begin
          printAskUserInstr(player,@dealer,hand)
          case gets.strip
          when 'dd'
            doubledownhelper(player, hand)
          when "split"
            player.splitHand(hand, @deck)
          when "surr"
            player.surrender
            hand.lock
          when "hit"
            hand.hit(@deck)
          when "stay"
            hand.lock
          else
            raise ArgumentError, "That's not a valid move. Please enter a valid move."
          end
        rescue ArgumentError, RangeError => ex
          puts "#{ex.class}: #{ex.message}"
          retry
        end

        if hand.checkHand == LOST
          printEmptyHandMessage(player, @dealer)
          hand.lock
        end
      end
    end
    player.removeLostHands
  end

  # Round.doubledownhelper
  # Given a player, hand, and the hand's turn_number whether a player can
  # doubledown on that deck. If so, prompt for a doubledown amount. Otherwise,
  # throw an Error and inform the player why they can't double down.
  # Fu
  def doubledownhelper(player, hand)
    if hand.isFirstTurn
      puts "Player " + player.getName + ", how much would you like to increase your bet by?"
      amount = toPositiveInt(gets.strip, "Bet amount")
      player.doubledown(hand, amount)
    else
      raise ArgumentError, "It's not this hand's first turn. You can't double down"
    end
  end

  # Round.checkGameOutcome
  # Gets the result of the dealer, and determines each of the remaining hands'
  # outcomes in relation to the dealer's. It prints out a message specifying
  # the user's outcome, and distributes money accordingly. 
  def checkGameOutcome
    dealer_outcome = @dealer.getResult
    @players.each do |player|
      puts "Player " + player.getName + " outcome: "
      player.getHands.each do |hand|
        outcome = hand.getResult(dealer_outcome)
        printOutcomeMessage(hand, outcome)
      end
      player.processAndRemoveHands(dealer_outcome)
      pressKeyToContinue
    end
  end


end