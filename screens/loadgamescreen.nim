## Load Game Screen
##-----------------

import opengl
import ftgl

import glfw3 as glfw #glfw.*
import basescreen
import menus
import colors
import fonts
import camera

type
  TLoadScreen* = object of TScreen
    title : string
    loadMenu : PMenu
    layout : PLayout
    parent : PScreen
  PLoadScreen* = ref TLoadScreen

proc key_callback(window : glfw.Window, key : cint, scancode : cint,
                  action : cint, mods : cint) {.cdecl.} =
  if key == glfw.KEY_UP and action == glfw.PRESS:
    basescreen.theScreen.up()
  if key == glfw.KEY_DOWN and action == glfw.PRESS:
    basescreen.theScreen.down()
  if key == glfw.KEY_ENTER and action == glfw.PRESS:
    basescreen.theScreen.enter()


proc newLoadScreen*(parent: PScreen): PLoadScreen =
  new(result)
  result.window = parent.window
  result.camcorder = parent.camcorder
  result.parent = parent
  result.title = "Load Game"
  result.loadMenu = menus.newTitleMenu(parent.camcorder, "Game 1",
                                       "Game 2", "Game 3", "Cancel")
  result.layout = ftgl.createSimpleLayout()
  result.layout.setFont(fonts.FreeSansBold)
  result.layout.setAlignment(ftgl.TTextAlignment.AlignCenter)
  setFaceSize(fonts.FreeSansBold, 75, 72)
  discard glfw.SetKeyCallback(parent.window, key_callback)


method up(s : PLoadScreen) =
  s.loadMenu.up()


method down(s : PLoadScreen) =
  s.loadMenu.down()


method enter*(s : PLoadScreen) =
  case s.loadMenu.selectedIdx
  of 3:
    basescreen.theScreen = s.parent
  else:
    echo "Not implemented yet"


method display*(s : PLoadScreen) =
  ## Display the Load Screen

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
  glTranslatef(0.0, 3*s.camcorder.filmHeight/8.0, 0.0)

  s.layout.setLineLength(s.camcorder.filmWidth)
  glRasterPos3f(-s.camcorder.filmWidth/2.0, 0.0, 0.0)
  s.layout.render(s.title, ftgl.TRenderMode.RenderAll)

  glLoadIdentity()

  # Menu options
  glTranslatef(0.0, s.camcorder.filmHeight/4.0, 0.0)
  s.loadMenu.display()
