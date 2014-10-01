# Author: Yifei Huang
# Date: Nov 13, 2013
# This file holds information about the class Game, which holds information
# about the state of the Blackjack game, and simulates rounds.

require 'round'
require 'player'
require 'dealer'
require 'output'

# This class holds information about the current state of the game, which
# consists of the players still in the game.
# It also holds an instance of Round, which keeps track of the things
# related to a playing the game.
class Game

  # Game.initialize
  # Params: players in the game, number of decks to be used
  # Creates players, and stores them in an array. Creates an instance of
  # Round, which plays the game.
  def initialize(players, num_decks)
  	@players = []
  	for i in 1..players
      @players.push(Player.new(i.to_s))
    end
    @rounds = Round.new(num_decks)
  end

  # Game.playGame
  # Plays Blackjack until there are no more players in the game.
  # Calls Round.playRound to play one round. After the round, it removes
  # from the game the players who quit the game, and the players
  # who are bankrupt. 
  def playGame
  	while not @players.empty?
      quitters = @rounds.playRound(@players)
      quitters.each do |player|          # Remove quitters
      	@players.delete(player)
      end
      @players.delete_if do |player|     # Remove bankrupt players
      	if player.isBankrupt
      	  printBankruptMessage(player)
      	  true
      	end
      end
    end
    puts "Game over. Thanks for playing! Byebye!"
  end


end