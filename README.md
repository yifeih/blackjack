blackjack
=========

Blackjack implemented in ruby. Designed and implemented over a weekend for an interview

To run the file, enter:
  ./main.rb

main.rb also contains a high-level description of the game.

The basic structure of the program is the following:

Game:
Game keeps track of the state of the entire game. Basically, it keeps track of
the players that are left in the game. It holds an instance of Round, which
executes a round of blackjack on the remaining players. 

Round:
Round contains a dealer and a deck. This is really where the game-playing 
happens. Players can choose whether to quit the game or enter an bet amount.
Then, it will give each player a hand of 2 cards, including the dealer, and
ask for player input. Afterwards, it will calculate and execute the payouts
for each player on all their hands.

Person: 
The superclass with Player and Dealer subclasses. A person is an object that
holds a list of Hands.
Player: 
A player in the game. A player holds multiple (up to 4) hands, a sum of money,
and an indicator for whether he has surrendered or not. He also has options
for doubling, splitting, and surrendering, which Dealer does not. 
Dealer: 
The dealer of the game. He can only hold one hand of cards. He also has
functions for determining whether to hit or not.

Hand:
The superclass with PlayerHand and DealerHand subclasses. A hand is an object
that holds a list of Cards.
PlayerHand:
The hand associated with a Player. A hand holds a bet amount, and indicators
for whether the hand has doubled-down or is at its first turn.
DealerHand:
The hand associated with a Dealer.

Deck:
The deck of cards used in the game.

Card:
A card holds a face and a suit value.

Output.rb:
This file holds some of the print statements used to make the user-interface
part of the game.

Utilities.rb:

