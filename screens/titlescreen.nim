## Title Screen
## ------------------------------------------------------------------

import opengl
import ftgl

import glfw3 as glfw
import basescreen
from matchscreen import newMatchScreen
from loadgamescreen import newLoadScreen
import camera
import menus
import colors
import fonts

type
  TTitleScreen = object of TScreen
    title : string
    titleMenu : PMenu
    layout : PLayout
  PTitleScreen* = ref TTitleScreen

proc key_callback(window : glfw.Window, key : cint, scancode : cint,
                  action : cint, mods : cint) {.cdecl.} =
  if key == glfw.KEY_UP and action == glfw.PRESS:
    basescreen.theScreen.up()
  if key == glfw.KEY_DOWN and action == glfw.PRESS:
    basescreen.theScreen.down()
  if key == glfw.KEY_ENTER and action == glfw.PRESS:
    basescreen.theScreen.enter()
  #Using a reference to basescreen. What this means is unfortunately
  #basescreen must have an empty implementation of all possible methods
  #called inside all key_callbacks.
  #All of this b/c key_callback needs the current screen and can't be
  #defined as a closure inside the newScreen implementation b/c
  #glfw.SetKeyCallback(window, key_callback) does not accept closures


proc newTitleScreen*(window: glfw.Window, camcorder: PCamera): PTitleScreen =
  new(result)
  result.window = window
  result.camcorder = camcorder
  result.title = "Threedacto"
  result.layout = ftgl.createSimpleLayout()
  result.layout.setFont(fonts.FreeSansBold)
  result.layout.setAlignment(ftgl.TTextAlignment.AlignCenter)
  setFaceSize(fonts.FreeSansBold, 70, 72)
  result.titleMenu = menus.newTitleMenu(camcorder, "New Game",
                                        "Multiplayer Game",
                                        "Load Game", "Quit Game")
  discard glfw.SetKeyCallback(window, key_callback)

method up(s : PTitleScreen) =
  s.titleMenu.up()

method down(s : PTitleScreen) =
  s.titleMenu.down()

method enter(s : PTitleScreen) =
  case s.titleMenu.selectedIdx
  of 0:
    basescreen.theScreen = newMatchScreen(s)
  of 1:
    echo("Not Implemented!")
  of 2:
    basescreen.theScreen = newLoadScreen(s)
  of 3: quit "Exit Game!", QuitSuccess
  else:
    echo("This should not happen")

method display*(s : PTitleScreen) =
  ## Display the Title Screen

  # Actual world of game
  # ====================
  s.camcorder.place()

  # Interface
  # =========
  s.camcorder.setOrthonormalLens()

  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()

  # Title
  glColor4ubv(colors.WHITE)
  glTranslatef(-s.camcorder.filmWidth/2,
               3*s.camcorder.filmHeight/8.0, 0.0)
  s.layout.setLineLength(s.camcorder.filmWidth)

  glRasterPos3f(0.0, 0.0, 0.0) #-screenType.camcorder.filmWidth/2.0
  s.layout.render(s.title, TRenderMode.RenderAll)

  glLoadIdentity()

  # Menu options
  glTranslatef(0.0, s.camcorder.filmHeight/4.0, 0.0)
  s.titleMenu.display()
