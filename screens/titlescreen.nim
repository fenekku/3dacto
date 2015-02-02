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


method process_key(s : PTitleScreen, key : cint, action : cint) =
  if key == glfw.KEY_UP and action == glfw.PRESS:
    s.titleMenu.up()
  if key == glfw.KEY_DOWN and action == glfw.PRESS:
    s.titleMenu.down()
  if key == glfw.KEY_ENTER and action == glfw.PRESS:
    case s.titleMenu.selectedIdx
      of 0:
        SCREEN = newMatchScreen(s)
      of 1:
        echo("Not Implemented!")
      of 2:
        SCREEN = newLoadScreen(s)
      of 3: quit "Exit Game!", QuitSuccess
      else:
        echo("This should not happen")


method draw*(s : PTitleScreen) =
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
  glColor4ubv(addr(colors.WHITE[0]))
  glTranslatef(-s.camcorder.filmWidth/2,
               3*s.camcorder.filmHeight/8.0, 0.0)
  s.layout.setLineLength(s.camcorder.filmWidth)

  glRasterPos3f(0.0, 0.0, 0.0)
  s.layout.render(s.title, TRenderMode.RenderAll)

  glLoadIdentity()

  # Menu options
  glTranslatef(0.0, s.camcorder.filmHeight/4.0, 0.0)
  s.titleMenu.display()
