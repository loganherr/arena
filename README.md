![# ARENA](https://github.com/loganherr/arena/blob/master/arena/Assets.xcassets/title.spriteatlas/arena_0.imageset/arena_0.png)

Welcome to ARENA! Think three moves ahead to outsmart, outmaneuver, and outlive the competition to be the last gladiator standing.

ARENA is a mix of deck-based, turn-based, RTS. Players selects 3 actions to take from a set hand of actions. Each player's then actions simultaneously take place, moving around the board and attacking those who come within range.

## 

## Rules of Play

Each player is randomly assigned a gladiator and their corresponding deck of actions.

**CURRENT ANIMATED GLADIATORS:**

![archer player](https://github.com/loganherr/arena/blob/master/arena/Assets.xcassets/archer_idle.spriteatlas/archer_idle_0.imageset/archer_idle_0.png) ![axe player](https://github.com/loganherr/arena/blob/master/arena/Assets.xcassets/axe_idle.spriteatlas/axe_idle_0.imageset/axe_idle_0.png) ![knight player](https://github.com/loganherr/arena/blob/master/arena/Assets.xcassets/knight_idle.spriteatlas/knight_idle_0.imageset/knight_idle_0.png)

**SELECT ACTIONS**: For every turn, each player will have 4 actions to choose from. Actions include movement, attack, or varying special moves/attacks. The player will select 3 actions to take, in sequential order, and select the direction to take each said action.

**PERFORM ACTIONS**: Once all players have selected their actions, all actions will be carried out in order (each player's first action, then each player's second action...). Priority of actions: Move > Attack. So if a player moves out of a space a player attacks within the same sequential action, the attack misses. If the player moves into the attacked space, they are hit.

This cycle of selecting and performing actions will continue until there is one player left standing. When a player is attacked 3 times, they die.


## To Do

* implement turns for players (local play)
  * ~~select number of players~~
  * ~~player action selection turn handling~~
  * currently race condition when adding animations for attack responses
  * add a button for turn begin to split up the turns. allows players to pass the phone to the next player without showing/seeing what previous/next player's actions are.
* ~~implement successful attack detection~~
* implement player health management
* ~~implement player action decks~~
  * ~~number of attack and movement actions determined in physical version~~
* add special action for various characters
  * special action assets
  * special action handling
* create assets for animations of character types
  * archer
    * ~~idle~~
    * ~~attack~~
    * attacked
    * die
  * axe
    * ~~idle~~
    * ~~attack~~
    * attacked
    * die
  * knight
    * ~~idle~~
    * ~~attack~~
    * attacked
    * die
  * spear
    * idle
    * attack
    * attacked
    * die
  * swords
    * idle
    * attack
    * attacked
    * die
* implement in-game menu
  * exit/surrender from a game
  * rematch with same player numbers (new random gladiators and same gladiators)
* implement multiplayer across devices
  * online play? peer-to-peer vs. game servers?
* cross-platform
  * MAC OS, Android(?), PC(?)
