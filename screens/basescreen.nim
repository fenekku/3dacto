
import glfw3 as glfw
import camera


type
  TScreen* = object of TObject
    window* : glfw.Window
    camcorder*: PCamera
  PScreen* = ref TScreen

var
  SCREEN* : PScreen #it's a global, deal with it


# method up*(s : PScreen) =
#   discard

# method down*(s : PScreen) =
#   discard

# method enter*(s : PScreen) =
#   discard

# method left*(s : PScreen) =
#   discard

# method right*(s : PScreen) =
#   discard

# method space*(s : PScreen) =
#   discard

# method zoomIn*(s : PScreen) =
#   discard

# method zoomOut*(s : PScreen) =
#   discard

# method rotateRight*(s : PScreen) =
#   discard

# method rotateLeft*(s : PScreen) =
#   discard

method draw*(s : PScreen) =
  ## Each screen should know how to draw itself
  discard

method process_key*(s : PScreen, key : cint, action : cint) =
  ## Each screen should know how to handle its key presses
  discard
