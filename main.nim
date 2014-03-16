import opengl   #all opengl stuff
import strutils
import os
import tables
import unsigned #uint comparison

import glfw
import ftgl
import soil

import camera
import colors
import basescreen
import titlescreen
import abacus

var
  running : bool = true
  frameCount : int = 0
  lastTime : float = 0.0
  lastFPSTime : float = 0.0
  currentTime : float = 0.0
  frameRate : int = 0
  frameDelta : float = 0.0
  x : float = 0.0
  y : float = 0.0
  vx : float = 200.0
  vy : float = 200.0

  w : ptr cint
  h : ptr cint
  c : ptr cint
  image : pointer

  windowW : cint = 1024
  windowH : cint = 768
  window : PGlfwWindow
  camcorder : PCamera
  screen : PScreen


## Callbacks
## -------------------------------------------------------------------------------

proc error_callback(error: cint, description: cstring ) {.cdecl.} =
  write(stderr, description)


proc size_callback(window: PGlfwWindow, width: cint, height: cint) {.cdecl.} =
  if height == 0:
    windowH = 1
  else:
    windowH = height

  windowW = width

  glViewport(0,0,windowW,windowH)

  camcorder.setFilmWidth(float(windowW))
  camcorder.setFilmHeight(float(windowH))


proc key_callback(window : PGlfwWindow, key : cint, scancode : cint,
                  action : cint, mods : cint) {.cdecl.} =
  var t = screen.getKeyMap()
  var k = (int(key), int8(action))
  if t.hasKey( k ):
    t[k](screen, window, key, scancode, action, mods)


## -------------------------------------------------------------------------------

proc initialize() =

  glfwSetErrorCallback(error_callback)

  if glfwInit() == 0:
      write(stdout, "Could not initialize GLFW! \n")
      quit()

  window = glfwCreateWindow(windowW.cint, windowH.cint, "3Dactoe",
                            nil, nil)
  if window == nil:
      glfwTerminate()
      quit()

  glfwMakeContextCurrent(window)

  opengl.loadExtensions()

  glfwSwapInterval(0)
  glViewport(0, 0, windowW, windowH)

  camcorder = camera.newCamera(float(windowW), float(windowH), 60.0,
                               pos = vec3(0.0, 4.0, 8.0))
  screen = titlescreen.newTitleScreen(camcorder)

  glClearColor(0.0, 0.0, 0.0, 0.0)
  glClearDepth(1.0)                   # Enables Clearing Of The Depth Buffer
  glDepthFunc(GL_LESS)                # The Type Of Depth Test To Do

  glEnable(GL_DEPTH_TEST)             # Enables Depth Testing

  glEnable(GL_LINE_SMOOTH)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE)

  glEnable(GL_POLYGON_OFFSET_FILL)    # Enables wire frame + solid
  glPolygonOffset(1.0, 2)

  glShadeModel(GL_SMOOTH)             # Enables Smooth Color Shading
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)

  ## Callbacks
  glfwSetWindowSizeCallback(window, size_callback)
  glfwSetKeyCallback(window, key_callback)

  lastTime = glfwGetTime()
  lastFPSTime = lastTime


proc update() =

  currentTime = glfwGetTime()

  frameDelta = currentTime - lastTime

  lastTime = currentTime

  if currentTime - lastFPSTime > 1.0:
    frameRate = int(float(frameCount) / (currentTime - lastFPSTime))
    glfwSetWindowTitle(window, "3Dactoe - FPS = $1" % intToStr(frameRate))

    lastFPSTime = currentTime
    frameCount = 0

  frameCount += 1


when isMainModule:

  initialize()

  while glfwWindowShouldClose(window) == 0:

    update()

    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

    screen.tick()

    glfwSwapBuffers(window)

    glfwPollEvents()


  glfwTerminate()
