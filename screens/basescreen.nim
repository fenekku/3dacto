
import tables

import glfw

import camera
import menus


type
  TKeyAction = tuple[key:int, action:int8]
  TScreenKeyCallback = proc (screen: PScreen, window: PGlfwWindow,
                             key: cint, scancode: cint, action: cint,
                             mods: cint){.cdecl.}

  TScreenType* {.inheritable.} = object
    camcorder* : PCamera
    keyMap* : TTable[TKeyAction, TScreenKeyCallback]
  PScreenType* = ref TScreenType

  TScreen = object
    screenType* : PScreenType
    window* : PGlfwWindow
  PScreen* = ref TScreen


## Basic ScreenType
## ------------------------------------------------------------------
proc initScreenType*(screenType : PScreenType, cam : PCamera) =
  screenType.camcorder = cam
  screenType.keyMap = initTable[TKeyAction, TScreenKeyCallback]()


method selectup*(screenType : PScreenType) =
  echo("Select Up")


method selectdown*(screenType : PScreenType) =
  echo("Select Down")


method selectleft*(screenType : PScreenType) =
  echo("Select left")


method selectright*(screenType : PScreenType) =
  echo("Select right")


method selectenter*(screenType : PScreenType, screen : PScreen) =
  echo("Select Enter")


method selectenter*(screenType : PScreenType) =
  echo("Select Enter")


method selectspace*(screenType : PScreenType) =
  echo("Select Enter")


method beforeDisplay(screenType : PScreenType) =
  nil


method display(screenType : PScreenType) =
  nil


method afterDisplay(screenType : PScreenType) =
  nil


## Callbacks
proc upCallback*(screen: PScreen, window: PGlfwWindow,
                key: cint, scancode: cint, action: cint,
                mods: cint){.cdecl.} =
    screen.screenType.selectup()

proc downCallback*(screen: PScreen, window: PGlfwWindow,
                  key: cint, scancode: cint, action: cint,
                  mods: cint){.cdecl.} =
    screen.screenType.selectdown()

proc leftCallback*(screen: PScreen, window: PGlfwWindow,
                  key: cint, scancode: cint, action: cint,
                  mods: cint){.cdecl.} =
    screen.screenType.selectleft()

proc rightCallback*(screen: PScreen, window: PGlfwWindow,
                  key: cint, scancode: cint, action: cint,
                  mods: cint){.cdecl.} =
    screen.screenType.selectright()

proc enterCallback*(screen: PScreen, window: PGlfwWindow,
                  key: cint, scancode: cint, action: cint,
                  mods: cint){.cdecl.} =
    screen.screenType.selectenter(screen)

proc spaceCallback*(screen: PScreen, window: PGlfwWindow,
                  key: cint, scancode: cint, action: cint,
                  mods: cint){.cdecl.} =
    screen.screenType.selectspace()

## Screen
## ------------------------------------------------------------------
proc getKeyMap*(screen : PScreen): TTable[TKeyAction, TScreenKeyCallback] =
  return screen.screenType.keyMap


proc tick*(screen : PScreen) =
  screen.screenType.beforeDisplay()
  screen.screenType.display()
  screen.screenType.afterDisplay()

