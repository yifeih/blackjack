#!/usr/bin/env ruby
# Author: Yifei Huang
# Date: Nov 13, 2013
#
# This is the main file for the Blackjack program. 
# 
# In this version of the game, there can be 1 to 8 players initially, and 
# 1 to 8 decks. Players can quit the game between rounds, but 
# no players can enter the game.
# 
# In this game of Blackjack, each user starts with $1000 and can only bet full
# dollar amounts. When the player gets money from the dealer, it must also be
# in full dollars. When the exact amount is a fraction of a full dollar, the
# dealer always rounds up the payout. (i.e. a payout of $1.5 would round to 
# $2).
#
# The game is played until all players either go bankrupt or quit the game. At
# the beginning of each round, each player can either choose to quit the game
# or enter a dollar amount to bet. If they choose to quit, they have permanently
# left the game and cannot rejoin. If they put down a dollar amount to bet with,
# then they are dealt 2 cards. If there are players still in the game, the
# dealer will deal himself two cards, but leave one face down.
# 
# Going from player 1 to player 8, the dealer will ask each player what they
# want to do on each of their hands. The options for the players are the 
# following:
#
# Surrender: This option is only valid for the player immediately after their
#   first hand is dealt. Surrender must be the first move that the player
#   makes the entire round. The player then gives up his hand, and is returned
#   half of what he originally bet.
# Split: If a hand starts out with 2 cards of the same face value (i.e. 2 3s,
#   or a K and a J), then a player can split this into two hands, with the 
#   same bet on each hand (given that he has enough money). A card will be
#   added to each additional hand. This must be the first move made on the
#   hand (no doubling down before splitting). A player may split up to 3 times
#   per round (four hands total).
# Doubledown: A player can add an amount to the bet if it his first move on 
#   the hand. He can only add up to the original bet. However, after doubling
#   down, only a max of one more card can be added to this hand.
# Hit: Add a card to the hand
# Stay: Make no changes to the hand.
# 
# After each player has made a move on each of his hands, the dealer will
# reveal his hidden card, and hit until he hits 17. If one possible amount of
# the dealer's hand is 17 or higher, he will not hit the soft 17. 
#
# Afterwards, each remaining player's hand is compared with the dealer's. The
# outcomes are:
# DRAW: If the dealer and the player have the same hand value of 21 or less,
#   the player simply keeps his original bet.
# WIN: If the dealer busts, or gets a smaller value than the player, the
#   player keeps his original bet, and the dealer gives him the bet amount.
# BLACKJACK: If the player has a hand that is 21, and the dealer doesn't,
#   the player keeps his original bet, and is paid 1.5 times his bet by the
#   dealer.
# LOSE: If the player gets a value less thant eh dealer, the player loses his
#   original bet.
#
# When a player is bankrupt, he must leave the game.
#
# The deck is shuffled between every round, whether it runs out or not.

require 'utilities'
require 'game'

if __FILE__ == $0
  
  num_players = 0
  num_decks = 0

  # Request the # of players. If it is not a positive value, raise an
  # ArgumentError. If it is out of the 1-8 range, raise a RangeError, and
  # keep asking until a valid value is given.
  begin
    puts "Welcome to Blackjack! How many players are at your table? Enter"\
      "a value in the range 1-8."
    num_players = toPositiveInt(gets.strip, "Number of players")
    if num_players > 8
      raise RangeError, "Too many players. The maximum is 8."
    end
  rescue ArgumentError, RangeError => ex
  	puts "#{ex.class}: #{ex.message}"
  	retry
  end

  # Request the # of decks. If it is not a positive value, raise an
  # ArgumentError. If it is out of the 1-8 range, raise a RangeError, and
  # keep asking until a valid value is given.
  begin
    puts "How many decks would you like to use? Enter a value in the range 1-8."
    num_decks = toPositiveInt(gets.strip, "Number of decks")
    if num_decks > 8
      raise RangeError, "That maximum deck size is 8 decks."
    end
  rescue ArgumentError, RangeError => ex
  	puts "#{ex.class}: #{ex.message}"
  	retry
  end

  # Creates a game, and lets the fun begin!
  game = Game.new(num_players, num_decks)
  game.playGame


end
