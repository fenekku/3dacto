## Title Screen
## ------------------------------------------------------------------

import tables

import opengl
import ftgl

import glfw3 as glfw
import basescreen
import camera
import menus
import colors

type
  TTitleScreen = object of TScreenType
    title : string
    titleFont : PFont
    titleMenu : PMenu
    layout : PLayout
  PTitleScreen* = ref TTitleScreen

proc newTitleScreenType*(cam : PCamera): PTitleScreen =
  new(result)
  initScreenType(result, cam)
  result.title = "3Dactoe"
  result.titleFont = ftgl.createBitmapFont("/usr/share/fonts/truetype/freefont/FreeSansBold.ttf")
  result.layout = createSimpleLayout()
  result.layout.setFont(result.titleFont)
  result.layout.setAlignment(TTextAlignment.AlignCenter)

  setFaceSize(result.titleFont, 70, 72 )
  result.titleMenu = menus.newTitleMenu(["New Game", "Load Game",
                                         "Multiplayer Game",
                                         "Exit Game"],
                                        cam.filmWidth, cam.filmHeight)

  ## Key map for this screen type
  result.keyMap[(glfw.KEY_UP, glfw.PRESS)] = upCallback
  result.keyMap[(glfw.KEY_DOWN, glfw.PRESS)] = downCallback
  result.keyMap[(glfw.KEY_ENTER, glfw.PRESS)] = enterCallback


proc newTitleScreen*(cam : PCamera): PScreen =
  new(result)
  result.screenType = newTitleScreenType(cam)


method selectup*(screenType : PTitleScreen) =
  screenType.titleMenu.selectup()


method selectdown*(screenType : PTitleScreen) =
  screenType.titleMenu.selectdown()


from matchscreen import newMatchScreenType
from loadgamescreen import newLoadScreenType

method selectenter*(screenType : PTitleScreen, screen : PScreen) =
  case screenType.titleMenu.selectedIdx
  of 0:
    screen.screenType = newMatchScreenType(screenType.camcorder)
  of 1:
    screen.screenType = newLoadScreenType(screenType.camcorder)
  of 2:
    echo("Not Implemented!")
  of 3: quit "Exit Game!"
  else:
    echo("selectedIdx " & $screenType.titleMenu.selectedIdx)


method beforeDisplay*(screenType : PTitleScreen) =
  discard


method display*(screenType : PTitleScreen) =
  ## Display the Title Screen

  # Actual world of game
  # ====================
  screenType.camcorder.place()

  # Interface
  # =========
  screenType.camcorder.setOrthonormalLens()

  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()

  # Title
  glColor4ubv(colors.WHITE)
  glTranslatef(-screenType.camcorder.filmWidth/2, 3*screenType.camcorder.filmHeight/8.0, 0.0)
  screenType.layout.setLineLength(screenType.camcorder.filmWidth)

  glRasterPos3f(0.0, 0.0, 0.0) #-screenType.camcorder.filmWidth/2.0
  screenType.layout.render(screenType.title, TRenderMode.RenderAll)

  glLoadIdentity()

  # Menu options
  glTranslatef(0.0, screenType.camcorder.filmHeight/4.0, 0.0)
  screenType.titleMenu.display()

method afterDisplay*(screenType : PTitleScreen) =
  discard
