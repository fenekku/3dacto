## Title Screen
## ------------------------------------------------------------------

import opengl
import tables

import glfw
import ftgl

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
  result.keyMap[(GLFW_KEY_UP, GLFW_PRESS)] = upCallback
  result.keyMap[(GLFW_KEY_DOWN, GLFW_PRESS)] = downCallback
  result.keyMap[(GLFW_KEY_ENTER, GLFW_PRESS)] = enterCallback


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
  of 3: quit "Exit Game!"
  else:
    echo("selectedIdx " & $screenType.titleMenu.selectedIdx)


method beforeDisplay*(screenType : PTitleScreen) =
  nil


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
  nil
