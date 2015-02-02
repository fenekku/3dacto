#ThreeDacto

This is a 3d tic-tac-toe game implemented in Nim (pretty terribly though, but it will get better ;)).

![Start Screen](GameStart.png?raw=true)
![Gameplay](GamePlay.png?raw=true)

##Requirements

- Ubuntu 12.04+
- Nimrod 0.10.2+
- opengl babel package: `nimble install opengl`
- Install the Ubuntu dependencies:
    - Add the pyglfw PPA to get access to libglfw3:

            sudo add-apt-repository ppa:pyglfw/pyglfw
            sudo apt-get update

    - `sudo apt-get install libftgl-dev libsoil-dev libglfw3`

##Install & Play

    nim c threedacto.nim
    ./threedacto

##Gameplay

- 2 Players: O and X
- 3 same symbols in a row, column or diagonal wins the game

##Controls

###Everywhere
- `Enter`: select

###In game
- `W`: zoom in
- `S`: zoom out
- `D`: turn counter-clockwise
- `A`: turn clockwise
- `Right Arrow Key`: move placement cursor (colored cube) to the right
- `Left Arrow Key`: move it to the left
- `Up Arrow Key`: move it in
- `Down Arrow Key`: move it out
- `Space`: move it up a level

##Design

- Make a game!
- Experiment with Nim
- Refactoring playground

##TODO

- Refactor a lot of things!
- Maybe Save/Load
- Maybe Multiplayer
- Maybe AI
