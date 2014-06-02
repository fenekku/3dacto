# Match Screen
# ------------------------------------------------------------------

import tables
import unsigned #unsigned comparisons
import strutils
import os

import opengl
import glfw
import ftgl
import soil   #SOIL_load_OGL_texture

import basescreen
import camera
from colors import WHITE, RED, BLUE
import shapes
import general

type
  TMatchScreen = object of TScreenType
    numberPlayers : int
    currentPlayer : int8
    winner : int8
    layout : PLayout
    screenFont : PFont
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


method selectup*(screenType : PMatchScreen) =
  if screenType.selector mod 9 in 6..8:
    screenType.selector -= 6
  else:
    screenType.selector +=3


method selectdown*(screenType : PMatchScreen) =
  if screenType.selector mod 9 in 0..2:
    screenType.selector += 6
  else:
    screenType.selector -=3


method selectright*(screenType : PMatchScreen) =
  if screenType.selector mod 3 == 2:
    screenType.selector -= 2
  else:
    screenType.selector += 1


method selectleft*(screenType : PMatchScreen) =
  if screenType.selector mod 3 == 0:
    screenType.selector += 2
  else:
    screenType.selector -= 1


method selectspace*(screenType : PMatchScreen) =
  screenType.selector += 9
  screenType.selector = screenType.selector mod 27


proc checkTriplet(a : int8, b : int8, c : int8) =
  if (a == 0'i8) or (b == 0'i8) or (c == 0'i8):
    return
  elif (a == b) and (b == c):
    raise newException(E_base, $(a))

proc checkLayer(grid : seq[int8]) =
  var tmp : int8
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


proc getWinner(screenType : PMatchScreen): int8 =
  try:
    #bottom up
    checkLayer(screenType.spaces[0..8])
    checkLayer(screenType.spaces[9..17])
    checkLayer(screenType.spaces[18..26])

    #front back
    checkLayer(@[ screenType.spaces[0], screenType.spaces[1], screenType.spaces[2],
                 screenType.spaces[9], screenType.spaces[10], screenType.spaces[11],
                 screenType.spaces[18], screenType.spaces[19], screenType.spaces[20]
               ])
    checkLayer(@[ screenType.spaces[3], screenType.spaces[4], screenType.spaces[5],
                 screenType.spaces[12], screenType.spaces[13], screenType.spaces[14],
                 screenType.spaces[21], screenType.spaces[22], screenType.spaces[23]
              ])
    checkLayer(@[ screenType.spaces[6], screenType.spaces[7], screenType.spaces[8],
                 screenType.spaces[15], screenType.spaces[16], screenType.spaces[17],
                 screenType.spaces[24], screenType.spaces[25], screenType.spaces[26]
              ])

    #left right
    checkLayer(@[ screenType.spaces[0], screenType.spaces[3], screenType.spaces[6],
                 screenType.spaces[9], screenType.spaces[12], screenType.spaces[15],
                 screenType.spaces[18], screenType.spaces[21], screenType.spaces[24]
              ])
    checkLayer(@[ screenType.spaces[1], screenType.spaces[4], screenType.spaces[7],
                 screenType.spaces[10], screenType.spaces[13], screenType.spaces[16],
                 screenType.spaces[19], screenType.spaces[22], screenType.spaces[25]
              ])
    checkLayer(@[ screenType.spaces[2], screenType.spaces[5], screenType.spaces[8],
                 screenType.spaces[11], screenType.spaces[14], screenType.spaces[17],
                 screenType.spaces[20], screenType.spaces[23], screenType.spaces[26]
              ])

    #diagonals
    checkTriplet(screenType.spaces[0], screenType.spaces[13], screenType.spaces[26])
    checkTriplet(screenType.spaces[18], screenType.spaces[13], screenType.spaces[8])
    checkTriplet(screenType.spaces[6], screenType.spaces[13], screenType.spaces[20])
    checkTriplet(screenType.spaces[24], screenType.spaces[13], screenType.spaces[2])
    return 0'i8
  except:
    let msg = getCurrentExceptionMsg()
    return int8(parseInt(msg))

# proc getWinner(model : PModel): int8 =
#   var grid : array[0..8, int8]
#   if winner == 0:
#     for level in 0..2:
#       grad = [ screenType.spaces[9*level..9*level+8]
#       winner = tictactoeRulesCheck(grid)
#       if winner != 0:
#         break

#   if winner == 0:
#     for depth in 0..2:
#       grid = [screenType.spaces[depth*3], screenType.spaces[1+depth*3], screenType.spaces[2+depth*3]
#               screenType.spaces[depth*3+9], screenType.spaces[1+depth*3+9], screenType.spaces[2+depth*3+9]
#               screenType.spaces[1+depth*3+18], screenType.spaces[1+depth*3+18], screenType.spaces[2+depth*3+18]]
#       winner = tictactoeRulesCheck(grid)
#       if winner != 0:
#         break

#   if winner == 0:
#       winner = checkTriplet(screenType.spaces[0], screenType.spaces[13], screenType.spaces[26])
#       if winner == 0:
#         winner = checkTriplet(screenType.spaces[2], screenType.spaces[13], screenType.spaces[24])


method selectenter*(screenType : PMatchScreen) =
  if screenType.spaces[screenType.selector] == 0:
    screenType.spaces[screenType.selector] = screenType.currentPlayer
    screenType.winner = getWinner(screenType)
    screenType.currentPlayer = (screenType.currentPlayer mod 2'i8) + 1'i8
  else:
    echo("No go")


proc enterMatchCallback(screen: PScreen, window: PGlfwWindow, key: cint,
                        scancode: cint, action: cint, mods: cint) {.cdecl.} =
    screen.screenType.selectenter()

proc zoomInCallback(screen: PScreen, window: PGlfwWindow,
                        key: cint, scancode: cint, action: cint,
                        mods: cint){.cdecl.} =
    screen.screenType.camcorder.zoomIn(0.5)

proc zoomOutCallback(screen: PScreen, window: PGlfwWindow,
                        key: cint, scancode: cint, action: cint,
                        mods: cint){.cdecl.} =
    screen.screenType.camcorder.zoomOut(0.5)

proc rotateLeftCallback(screen: PScreen, window: PGlfwWindow,
                        key: cint, scancode: cint, action: cint,
                        mods: cint){.cdecl.} =
    screen.screenType.camcorder.rotateAround(1.0)

proc rotateRightCallback(screen: PScreen, window: PGlfwWindow,
                        key: cint, scancode: cint, action: cint,
                        mods: cint){.cdecl.} =
    screen.screenType.camcorder.rotateAround(-1.0)

proc nullCallback(screen: PScreen, window: PGlfwWindow,
                  key: cint, scancode: cint, action: cint,
                  mods: cint){.cdecl.} =
    nil


proc newMatchScreenType*(cam : PCamera): PMatchScreen =
  new(result)
  initScreenType(result, cam)
  result.numberPlayers = 2
  result.currentPlayer = 1'i8
  result.winner = 0'i8
  result.screenFont = ftgl.createBitmapFont("/usr/share/fonts/truetype/freefont/FreeSansBold.ttf")
  result.layout = createSimpleLayout()
  result.layout.setFont(result.screenFont)
  result.layout.setAlignment(TTextAlignment.AlignCenter)

  setFaceSize(result.screenFont, 75, 72)

  ## Key map for this screen type
  result.keyMap[(GLFW_KEY_UP, GLFW_PRESS)] = upCallback
  result.keyMap[(GLFW_KEY_DOWN, GLFW_PRESS)] = downCallback
  result.keyMap[(GLFW_KEY_LEFT, GLFW_PRESS)] = leftCallback
  result.keyMap[(GLFW_KEY_RIGHT, GLFW_PRESS)] = rightCallback
  result.keyMap[(GLFW_KEY_SPACE, GLFW_PRESS)] = spaceCallback
  result.keyMap[(GLFW_KEY_ENTER, GLFW_PRESS)] = enterMatchCallback

  result.keyMap[(GLFW_KEY_W, GLFW_PRESS)] = zoomInCallback
  result.keyMap[(GLFW_KEY_S, GLFW_PRESS)] = zoomOutCallback
  result.keyMap[(GLFW_KEY_A, GLFW_PRESS)] = rotateLeftCallback
  result.keyMap[(GLFW_KEY_D, GLFW_PRESS)] = rotateRightCallback
  result.keyMap[(GLFW_KEY_W, GLFW_REPEAT)] = zoomInCallback
  result.keyMap[(GLFW_KEY_S, GLFW_REPEAT)] = zoomOutCallback
  result.keyMap[(GLFW_KEY_A, GLFW_REPEAT)] = rotateLeftCallback
  result.keyMap[(GLFW_KEY_D, GLFW_REPEAT)] = rotateRightCallback

  ## load an image file directly as a new OpenGL texture
  var asset_path = joinPath(getCurrentDir(), "assets")
  O_texture = soil.SOIL_load_OGL_texture(joinPath(asset_path, "circle-white-on-black.png"),
                                         SOIL_LOAD_AUTO, SOIL_CREATE_NEW_ID,
                                         SOIL_FLAG_MIPMAPS or SOIL_FLAG_INVERT_Y or SOIL_FLAG_NTSC_SAFE_RGB or SOIL_FLAG_COMPRESS_TO_DXT)
  X_texture = soil.SOIL_load_OGL_texture(joinPath(asset_path, "x-white-on-black.png"),
                                         SOIL_LOAD_AUTO, SOIL_CREATE_NEW_ID,
                                         SOIL_FLAG_MIPMAPS or SOIL_FLAG_INVERT_Y or SOIL_FLAG_NTSC_SAFE_RGB or SOIL_FLAG_COMPRESS_TO_DXT)

  ## check for an error during the load process
  if( (0'u32 == O_texture) or (0'u32 == X_texture) ):
    echo( "SOIL loading error: " & $SOIL_last_result() )


from  titlescreen import newTitleScreenType
proc winCallback(screen: PScreen, window: PGlfwWindow,
                 key: cint, scancode: cint, action: cint,
                 mods: cint){.cdecl.} =
    screen.screenType = newTitleScreenType(screen.screenType.camcorder)


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


proc drawMarker(marker : int8, asSelector : bool = false) {.inline.} =
  if asSelector:
    # first player is red and second player is blue
  else:
    var currentTexture = 0'u32
    if marker == 1'i8:
      currentTexture = O_texture
    else:
      currentTexture = X_texture
    renderCube(0.8, false, currentTexture)


proc drawXandOs(screenType : PMatchScreen) {.inline.} =
  glEnable(GL_TEXTURE_2D)
  for i, marker in screenType.spaces:
    glPushMatrix()
    glTranslatef(float(i mod 3) - 1.0, float(i div 9) - 1.0, -float((i mod 9) div 3) + 1.0 )
    if marker != 0:
      drawMarker(marker)
    glPopMatrix()
  glDisable(GL_TEXTURE_2D)


proc drawSelector(screenType : PMatchScreen) =
  glPushMatrix()
  glTranslatef(float(screenType.selector mod 3) - 1.0,
               float(screenType.selector div 9) - 1.0,
               -float((screenType.selector mod 9) div 3) + 1.0 )
  var color : array[0..3, uint8]
  if screenType.currentPlayer == 1'i8:
    color = RED
  else:
    color = BLUE
  if screenType.spaces[screenType.selector] != 0'i8:
    color[3] = 0x33'u8

  glColor4ubv(color)
  renderCube(1.0, false)
  glPopMatrix()


method beforeDisplay*(screenType : PMatchScreen) =
  if screenType.winner != 0'i8 and not screenType.ended:
    screenType.keyMap[(GLFW_KEY_ENTER, GLFW_PRESS)] = winCallback
    screenType.keyMap[(GLFW_KEY_UP, GLFW_PRESS)] = nullCallback
    screenType.keyMap[(GLFW_KEY_DOWN, GLFW_PRESS)] = nullCallback
    screenType.keyMap[(GLFW_KEY_LEFT, GLFW_PRESS)] = nullCallback
    screenType.keyMap[(GLFW_KEY_RIGHT, GLFW_PRESS)] = nullCallback
    screenType.keyMap[(GLFW_KEY_SPACE, GLFW_PRESS)] = nullCallback
    screenType.ended = true


method display*(screenType : PMatchScreen) =

  # Actual world of game
  # ====================
  # World camera
  screenType.camcorder.setPerspectiveLens()
  screenType.camcorder.place()

  glScalef(2.5, 2.5, 2.5)

  ## DRAW THE SEPARATING LINES
  glColor4ubv(WHITE)
  drawGrid()

  ## DRAW THE ALREADY PLACED MARKERS
  drawXandOs(screenType)

  ## DRAW SELECTOR
  if screenType.winner == 0'i8:
    drawSelector(screenType)
  else:
    screenType.camcorder.setOrthonormalLens()
    screenType.camcorder.place()


  if screenType.ended:
    # Interface
    # =========
    screenType.camcorder.setOrthonormalLens()

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()

    # Title
    glColor4ubv(WHITE)
    glTranslatef(-screenType.camcorder.filmWidth/2, 3*screenType.camcorder.filmHeight/8.0, 0.0)
    screenType.layout.setLineLength(screenType.camcorder.filmWidth)
    glRasterPos3f(0.0, 0.0, 0.0) #-screenType.camcorder.filmWidth/2.0
    var msg = "Player " & $screenType.winner & " won the game!"
    screenType.layout.render(msg, TRenderMode.RenderAll)

    # glTranslatef(0.0, 3*screenType.camcorder.filmHeight/8.0, 0.0)
    glTranslatef(0.0, -5*screenType.camcorder.filmHeight/8.0, 0.0) #-screenType.camcorder.filmWidth/2.0
    glRasterPos3f(0.0, 0.0, 0.0) #-screenType.camcorder.filmWidth/2.0
    msg = "Press Enter key to go back to the main menu"
    screenType.layout.render(msg, TRenderMode.RenderAll)

    glLoadIdentity()




