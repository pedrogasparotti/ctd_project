This is an implementation of a circuit on the DE2 development board, making use of the structures and knowledge acquired during ctd EEL5105-08213 classes held in federal university of santa catarina campus. Our goal was to develop an interactive game to obtain a 10-bit secret code, the game's behavior is defined as follows:

### Init State:
The user starts in the Init state and initiates the game by pressing the enter button (KEY1).

Once in the Setup state, the user must select one of the 16 possible sequences using Switches 3 to 0, SW (3 downto 0), which are stored in the ROM memory (configured in the rom.vhd file).

![image](https://github.com/user-attachments/assets/cca358fd-e521-4571-a217-aa01464a44e4)

The ROM memory contains 16 lines of 10-bit information (16 × 10), and each of the 10-bit vectors may only contain exactly four logical "1"s (you can check the sequences in rom.vhd)

Switches 7 to 4, SW(7 downto 4), are used to set the game duration per round (setup state), allowing the user to choose between a minimum of 5 seconds and a maximum of 10 seconds. In this state, displays HEX5 and HEX3 will show the letters "t" for time and "n" for level, while displays HEX4 and HEX2 will show the time value and the selected memory line.

### Play State:
Pressing enter again transitions the game to the Play state, starting the game. In the Play state, the user has the chosen time value to select a sequence using Switches SW (9 downto 0).

In this state, displays HEX5 and HEX4 will show the letter "t" for time and an ascending count at a frequency of 1Hz, respectively.

![image](https://github.com/user-attachments/assets/70d1dd89-902d-45ea-ab30-b08fb888f302)

There are two rules for play state:

1. It is important to note that the player can only input four logical "1"s per round, if he does so, an error will be raised during Check state (sw_error = '1') and the game finishes, turning to Result state.

2. If the player does not press enter before the countdown ends, a status signal called end_time is activated, and the game also transitions to the Result state.

![image](https://github.com/user-attachments/assets/499f6535-f780-4ef9-b113-4d270b09aa1c)


Respecting the above conditions, if the player selects a sequence and presses enter before the countdown ends, the game transitions to the Count_Round state.

### Count_Round State:

In this state, the round count is updated, and the game moves to the Check state. The player has 10 rounds to guess the sequence.

### Check State:
In the Check state, the game evaluates whether:

The player did not input four logical "1"s on the switches, activating a status signal called sw_erro.

The player has used up the maximum number of rounds. If they reach 10 rounds, a status signal called end_round is activated.

The player guessed the positions of the four logical "1"s in the sequence, activating a status signal called end_game.

If any of these three status signals is active, the game transitions to the Result state. Otherwise, it forwards to the Wait state.

### Wait State:
In this state, displays HEX3 and HEX2 show the letter "r" for round and the round count, respectively.

The time counter is reset in this state.

Displays HEX1 and HEX0 show the letter "A" for accuracy and the number of correct guesses.

![image](https://github.com/user-attachments/assets/76160b36-4ed3-4fed-8467-468e18a2841d)


When the player presses enter (KEY1), the game transitions back to the Play state for the next round.

### Result State:
In this state, the sequence to be guessed is displayed on the red LEDs, LEDR(9::0). The Result state also shows the final score in hexadecimal on displays HEX1 and HEX0. The final score is calculated using the formula 16 × end_game + Round, where Round is the number of rounds (the formula is expressed as a vector in the datapath). The user must press enter to return to the Init state and start another round.

![image](https://github.com/user-attachments/assets/02f67428-4c60-4ed0-a9c0-9a2650617526)


Reset (KEY0):
At any time, the user can stop the game by pressing the reset button (KEY0), resetting the system and starting over.

Button Synchronization:
To prevent timing issues caused by the duration of a human pressing a KEY lasting many clock cycles, a Button Press Synchronizer (ButtonSync) converts KEY presses into pulses lasting one clock cycle.
