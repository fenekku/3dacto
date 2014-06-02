## Load Game Screen
##-----------------

import tables

import opengl
import glfw #GLFW_*
import ftgl #createBitmapFont

import basescreen
import camera
import menus
import colors


type
  TLoadScreen* = object of TScreenType
    title : string
    titleFont : PFont
    loadMenu : PMenu
    layout : PLayout
  PLoadScreen* = ref TLoadScreen


proc newLoadScreenType*(cam : PCamera): PLoadScreen =
  new(result)
  basescreen.initScreenType(result, cam)
  result.title = "Load Game"
  result.titleFont = ftgl.createBitmapFont("/usr/share/fonts/truetype/freefont/FreeSansBold.ttf")
  result.layout = createSimpleLayout()
  result.layout.setFont(result.titleFont)
  result.layout.setAlignment(TTextAlignment.AlignCenter)

  setFaceSize(result.titleFont, 75, 72)
  result.loadMenu = menus.newTitleMenu(["Game 1",
                                        "Game 2",
                                        "Game 3",
                                        "Cancel"],
                                        cam.filmWidth, cam.filmHeight)
  ## Key map for this screen type
  result.keyMap[(GLFW_KEY_UP, GLFW_PRESS)] = upCallback
  result.keyMap[(GLFW_KEY_DOWN, GLFW_PRESS)] = downCallback
  result.keyMap[(GLFW_KEY_ENTER, GLFW_PRESS)] = enterCallback


method selectup*(screenType : PLoadScreen) =
  screenType.loadMenu.selectup()


method selectdown*(screenType : PLoadScreen) =
  screenType.loadMenu.selectdown()


from  titlescreen import newTitleScreenType

method selectenter*(screenType : PLoadScreen, screen : PScreen) =
  case screenType.loadMenu.selectedIdx
  of 3:
    screen.screenType = titlescreen.newTitleScreenType(screenType.camcorder)
  else:
    echo("selectedIdx " & $screenType.loadMenu.selectedIdx)


method display*(screenType : PLoadScreen) =
  ## Display the Load Screen

  screenType.camcorder.place()
  screenType.camcorder.setOrthonormalLens()

  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()

  # Title
  glColor4ubv(colors.WHITE)
  glTranslatef(0.0, 3*screenType.camcorder.filmHeight/8.0, 0.0)

  screenType.layout.setLineLength(screenType.camcorder.filmWidth)
  glRasterPos3f(-screenType.camcorder.filmWidth/2.0, 0.0, 0.0)
  screenType.layout.render(screenType.title, TRenderMode.RenderAll)

  glLoadIdentity()

  # Menu options
  glTranslatef(0.0, screenType.camcorder.filmHeight/4.0, 0.0)
  screenType.loadMenu.display()