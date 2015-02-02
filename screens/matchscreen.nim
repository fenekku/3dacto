# Match Screen
# ------------------------------------------------------------------

import unsigned #unsigned comparisons
import strutils
import os

import opengl
import ftgl
import soil   #SOIL_load_OGL_texture

import basescreen
import glfw3 as glfw
import camera
import fonts
from colors import WHITE, RED, BLUE
import shapes


type
  TMatchScreen = object of TScreen
    parent: PScreen
    numberPlayers : int
    currentPlayer : int8
    winner : int8
    layout : PLayout
    selector : int
    ended : bool
    spaces : array[0..26, int8] #start at bottom layer as such:
                                #  6 | 7 | 8
                                #  3 | 4 | 5
                                #  0 | 1 | 2
  PMatchScreen* = ref TMatchScreen

var
  O_texture : uint32
  X_texture : uint32


proc key_callback(window : glfw.Window, key : cint, scancode : cint,
                  action : cint, mods : cint) {.cdecl.} =
  if key == glfw.KEY_UP and action == glfw.PRESS:
    basescreen.theScreen.up()
  if key == glfw.KEY_DOWN and action == glfw.PRESS:
    basescreen.theScreen.down()
  if key == glfw.KEY_LEFT and action == glfw.PRESS:
    basescreen.theScreen.left()
  if key == glfw.KEY_RIGHT and action == glfw.PRESS:
    basescreen.theScreen.right()
  if key == glfw.KEY_ENTER and action == glfw.PRESS:
    basescreen.theScreen.enter()
  if key == glfw.KEY_SPACE and action == glfw.PRESS:
    basescreen.theScreen.space()
  if key == glfw.KEY_W and ((action == glfw.PRESS) or (action == glfw.REPEAT)):
    basescreen.theScreen.zoomIn()
  if key == glfw.KEY_S and ((action == glfw.PRESS) or (action == glfw.REPEAT)):
    basescreen.theScreen.zoomOut()
  if key == glfw.KEY_A and ((action == glfw.PRESS) or (action == glfw.REPEAT)):
    basescreen.theScreen.rotateLeft()
  if key == glfw.KEY_D and ((action == glfw.PRESS) or (action == glfw.REPEAT)):
    basescreen.theScreen.rotateRight()


proc newMatchScreen*(parent: PScreen): PMatchScreen =
  new(result)
  result.window = parent.window
  result.camcorder = parent.camcorder
  result.parent = parent
  result.numberPlayers = 2
  result.currentPlayer = 1'i8
  result.winner = 0'i8
  result.layout = ftgl.createSimpleLayout()
  result.layout.setFont(fonts.FreeSansBold)
  result.layout.setAlignment(ftgl.TTextAlignment.AlignCenter)
  setFaceSize(fonts.FreeSansBold, 75, 72)

  ## load an image file directly as a new OpenGL texture
  let asset_path = joinPath(getCurrentDir(), "assets")
  O_texture = soil.SOIL_load_OGL_texture(joinPath(asset_path, "circle-white-on-black.png"),
                                         SOIL_LOAD_AUTO, SOIL_CREATE_NEW_ID,
                                         SOIL_FLAG_MIPMAPS or SOIL_FLAG_INVERT_Y or SOIL_FLAG_NTSC_SAFE_RGB or SOIL_FLAG_COMPRESS_TO_DXT)
  X_texture = soil.SOIL_load_OGL_texture(joinPath(asset_path, "x-white-on-black.png"),
                                         SOIL_LOAD_AUTO, SOIL_CREATE_NEW_ID,
                                         SOIL_FLAG_MIPMAPS or SOIL_FLAG_INVERT_Y or SOIL_FLAG_NTSC_SAFE_RGB or SOIL_FLAG_COMPRESS_TO_DXT)

  ## check for an error during the load process
  if( (0'u32 == O_texture) or (0'u32 == X_texture) ):
    echo( "SOIL loading error: " & $SOIL_last_result() )

  discard glfw.SetKeyCallback(parent.window, key_callback)


method up(s : PMatchScreen) =
  if s.selector mod 9 in 6..8:
    s.selector -= 6
  else:
    s.selector += 3

method down(s : PMatchScreen) =
  if s.selector mod 9 in 0..2:
    s.selector += 6
  else:
    s.selector -=3

method right(s : PMatchScreen) =
  if s.selector mod 3 == 2:
    s.selector -= 2
  else:
    s.selector += 1

method left(s : PMatchScreen) =
  if s.selector mod 3 == 0:
    s.selector += 2
  else:
    s.selector -= 1

method space(s : PMatchScreen) =
  s.selector += 9
  s.selector = s.selector mod 27

method zoomIn(s: PMatchScreen) =
  s.camcorder.zoomIn(0.5)

method zoomOut(s: PMatchScreen)  =
  s.camcorder.zoomOut(0.5)

method rotateLeft(s: PMatchScreen) =
  s.camcorder.rotateAround(1.0)

method rotateRight(s: PMatchScreen) =
  s.camcorder.rotateAround(-1.0)


proc checkTriplet(a : int8, b : int8, c : int8) =
  if (a == 0'i8) or (b == 0'i8) or (c == 0'i8):
    return
  elif (a == b) and (b == c):
    raise newException(E_base, $(a))


proc checkLayer(grid : seq[int8]) =
  ## vertical
  for i in 0..2:
    checkTriplet(grid[i], grid[i+3], grid[i+6])
  ## horizontal
  for i in [0,3,6]:
    checkTriplet(grid[i], grid[i+1], grid[i+2])
  ## diagonal
  checkTriplet(grid[0], grid[4], grid[8])
  checkTriplet(grid[6], grid[4], grid[2])
  return


proc getWinner(s : PMatchScreen) =
  try:
    #bottom up
    checkLayer(s.spaces[0..8])
    checkLayer(s.spaces[9..17])
    checkLayer(s.spaces[18..26])

    #front back
    checkLayer(@[ s.spaces[0], s.spaces[1], s.spaces[2],
                 s.spaces[9], s.spaces[10], s.spaces[11],
                 s.spaces[18], s.spaces[19], s.spaces[20]
               ])
    checkLayer(@[ s.spaces[3], s.spaces[4], s.spaces[5],
                 s.spaces[12], s.spaces[13], s.spaces[14],
                 s.spaces[21], s.spaces[22], s.spaces[23]
              ])
    checkLayer(@[ s.spaces[6], s.spaces[7], s.spaces[8],
                 s.spaces[15], s.spaces[16], s.spaces[17],
                 s.spaces[24], s.spaces[25], s.spaces[26]
              ])

    #left right
    checkLayer(@[ s.spaces[0], s.spaces[3], s.spaces[6],
                 s.spaces[9], s.spaces[12], s.spaces[15],
                 s.spaces[18], s.spaces[21], s.spaces[24]
              ])
    checkLayer(@[ s.spaces[1], s.spaces[4], s.spaces[7],
                 s.spaces[10], s.spaces[13], s.spaces[16],
                 s.spaces[19], s.spaces[22], s.spaces[25]
              ])
    checkLayer(@[ s.spaces[2], s.spaces[5], s.spaces[8],
                 s.spaces[11], s.spaces[14], s.spaces[17],
                 s.spaces[20], s.spaces[23], s.spaces[26]
              ])

    #diagonals
    checkTriplet(s.spaces[0], s.spaces[13], s.spaces[26])
    checkTriplet(s.spaces[18], s.spaces[13], s.spaces[8])
    checkTriplet(s.spaces[6], s.spaces[13], s.spaces[20])
    checkTriplet(s.spaces[24], s.spaces[13], s.spaces[2])
    s.winner = 0'i8
  except:
    let msg = getCurrentExceptionMsg()
    s.winner = int8(parseInt(msg))


method enter*(s : PMatchScreen) =
  if s.winner != 0'i8:
    basescreen.theScreen = s.parent
  else:
    if s.spaces[s.selector] == 0:
      s.spaces[s.selector] = s.currentPlayer
      s.getWinner()
      s.currentPlayer = (s.currentPlayer mod int8(s.numberPlayers)) + 1'i8
    else:
      echo("No go")


## Screen Display code
## ---------------------------------------------------------------------
proc drawGrid() {.inline.} =
  glPushMatrix()
  glLineWidth(4.0)

  glBegin(GL_LINES)

  #4 lines
  glVertex3f( -0.5, 0.5, 1.5)
  glVertex3f( -0.5, 0.5, -1.5)

  glVertex3f( 0.5, 0.5, 1.5)
  glVertex3f( 0.5, 0.5, -1.5)

  glVertex3f( 0.5, -0.5, 1.5)
  glVertex3f( 0.5, -0.5, -1.5)

  glVertex3f( -0.5, -0.5, 1.5)
  glVertex3f( -0.5, -0.5, -1.5)

  #4 lines
  glVertex3f( -1.5, 0.5, -0.5)
  glVertex3f( 1.5, 0.5, -0.5)

  glVertex3f( -1.5, -0.5, -0.5)
  glVertex3f( 1.5, -0.5, -0.5)

  glVertex3f( -1.5, -0.5, 0.5)
  glVertex3f( 1.5, -0.5, 0.5)

  glVertex3f( -1.5, 0.5, 0.5)
  glVertex3f( 1.5, 0.5, 0.5)

  #4 lines
  glVertex3f( 0.5, 1.5, -0.5)
  glVertex3f( 0.5, -1.5, -0.5)

  glVertex3f( 0.5, 1.5, 0.5)
  glVertex3f( 0.5, -1.5, 0.5)

  glVertex3f( -0.5, 1.5, 0.5)
  glVertex3f( -0.5, -1.5, 0.5)

  glVertex3f( -0.5, 1.5, -0.5)
  glVertex3f( -0.5, -1.5, -0.5)
  glEnd()

  glLineWidth(1.0)
  glPopMatrix()


proc drawMarker(marker : int8) {.inline.} =
  var currentTexture = 0'u32
  if marker == 1'i8:
    currentTexture = O_texture
  else:
    currentTexture = X_texture
  renderCube(0.8, false, currentTexture)


proc drawXandOs(s : PMatchScreen) {.inline.} =
  glEnable(GL_TEXTURE_2D)
  for i, marker in s.spaces:
    glPushMatrix()
    glTranslatef(float(i mod 3) - 1.0, float(i div 9) - 1.0, -float((i mod 9) div 3) + 1.0 )
    if marker != 0:
      drawMarker(marker)
    glPopMatrix()
  glDisable(GL_TEXTURE_2D)


proc drawSelector(s : PMatchScreen) =
  glPushMatrix()
  glTranslatef(float(s.selector mod 3) - 1.0,
               float(s.selector div 9) - 1.0,
               -float((s.selector mod 9) div 3) + 1.0 )
  var color : array[0..3, uint8]
  if s.currentPlayer == 1'i8:
    color = RED
  else:
    color = BLUE
  if s.spaces[s.selector] != 0'i8:
    #translucify
    color[3] = 0x33'u8

  glColor4ubv(addr(color[0]))
  renderCube(1.0, false)
  glPopMatrix()


method display*(s : PMatchScreen) =

  # Actual world of game
  # ====================
  # World camera
  s.camcorder.setPerspectiveLens()
  s.camcorder.place()

  glScalef(2.5, 2.5, 2.5)

  ## DRAW THE SEPARATING LINES
  glColor4ubv(addr(WHITE[0]))
  drawGrid()

  ## DRAW THE ALREADY PLACED MARKERS
  drawXandOs(s)

  ## DRAW SELECTOR
  if s.winner == 0'i8:
    drawSelector(s)
  else:
    # Actual world of game
    # ====================
    s.camcorder.place()

    # Interface
    # =========
    s.camcorder.setOrthonormalLens()

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()

    # Title
    glColor4ubv(addr(RED[0]))
    glTranslatef(-s.camcorder.filmWidth/2, 3*s.camcorder.filmHeight/8.0, 0.0)
    s.layout.setLineLength(s.camcorder.filmWidth)
    glRasterPos3f(0.0, 0.0, 0.0)
    var msg = "Player " & $s.winner & " won the game!"
    s.layout.render(msg, ftgl.TRenderMode.RenderAll)

    glTranslatef(0.0, -5*s.camcorder.filmHeight/8.0, 0.0)
    glRasterPos3f(0.0, 0.0, 0.0)
    msg = "Press Enter key to go back to the main menu"
    s.layout.render(msg, TRenderMode.RenderAll)

    glColor4ubv(addr(WHITE[0]))

    glLoadIdentity()
