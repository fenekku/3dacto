import strutils
import os
import tables
import unsigned #uint comparison

import opengl   #all opengl stuff

import glfw3 as glfw
import camera
import colors
import basescreen
import titlescreen
import abacus

var
  frameCount : int = 0
  lastTime : float = 0.0
  lastFPSTime : float = 0.0
  currentTime : float = 0.0
  frameRate : int = 0
  frameDelta : float = 0.0
  windowW : cint = 1024
  windowH : cint = 768
  window : glfw.Window
  camcorder : PCamera


## Callbacks
## -------------------------------------------------------------------------------

proc error_callback(error: cint, description: cstring ) {.cdecl.} =
  write(stderr, description)


proc size_callback(window: glfw.Window, width: cint, height: cint) {.cdecl.} =
  if height == 0:
    windowH = 1
  else:
    windowH = height

  windowW = width

  glViewport(0,0,windowW,windowH)

  camcorder.setFilmWidth(float(windowW))
  camcorder.setFilmHeight(float(windowH))


proc key_callback(window : glfw.Window, key : cint, scancode : cint,
                  action : cint, mods : cint) {.cdecl.} =
  SCREEN.process_key(key, action)

## -------------------------------------------------------------------------------

proc initialize() =

  enableAutoGlErrorCheck(false)

  discard glfw.SetErrorCallback(error_callback)

  if glfw.Init() == 0:
      write(stdout, "Could not initialize GLFW! \n")
      quit()

  window = glfw.CreateWindow(windowW.cint, windowH.cint, "3Dactoe",
                            nil, nil)
  if window == nil:
      glfw.Terminate()
      quit()

  glfw.MakeContextCurrent(window)

  opengl.loadExtensions()

  glfw.SwapInterval(0)
  glViewport(0, 0, windowW, windowH)

  camcorder = camera.newCamera(float(windowW), float(windowH), 60.0,
                               pos = vec3(0.0, 4.0, 8.0))
  SCREEN = titlescreen.newTitleScreen(window, camcorder)

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
  discard glfw.SetWindowSizeCallback(window, size_callback)
  discard glfw.SetKeyCallback(window, key_callback)

  lastTime = glfw.GetTime()
  lastFPSTime = lastTime


proc monitor_frame_rate() =

  currentTime = glfw.GetTime()

  frameDelta = currentTime - lastTime

  lastTime = currentTime

  if currentTime - lastFPSTime > 1.0:
    frameRate = int(float(frameCount) / (currentTime - lastFPSTime))
    glfw.SetWindowTitle(window, "threeDactoe - FPS = $1" % intToStr(frameRate))

    lastFPSTime = currentTime
    frameCount = 0

  frameCount += 1


when isMainModule:

  initialize()

  while glfw.WindowShouldClose(window) == 0:

    monitor_frame_rate()

    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

    SCREEN.draw()

    glfw.SwapBuffers(window)

    glfw.PollEvents()

  glfw.Terminate()
