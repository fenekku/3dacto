
import glfw3 as glfw
import camera


type
  TScreen* = object of TObject
    window* : glfw.Window
    camcorder*: PCamera
  PScreen* = ref TScreen

var
  theScreen* : PScreen


method up*(s : PScreen) =
  discard

method down*(s : PScreen) =
  discard

method enter*(s : PScreen) =
  discard

# method selectleft*(screenType : PScreenType) =
#   echo("Select left")


# method selectright*(screenType : PScreenType) =
#   echo("Select right")



# method beforeDisplay(screenType : PScreenType) =
#   discard


method display*(s : PScreen) =
  discard


# method afterDisplay(screenType : PScreenType) =
#   discard


# ## Callbacks
# proc upCallback*(screen: PScreen, window: glfw.Window,
#                 key: cint, scancode: cint, action: cint,
#                 mods: cint){.cdecl.} =
#     screen.screenType.selectup()

# proc downCallback*(screen: PScreen, window: glfw.Window,
#                   key: cint, scancode: cint, action: cint,
#                   mods: cint){.cdecl.} =
#     screen.screenType.selectdown()

# proc leftCallback*(screen: PScreen, window: glfw.Window,
#                   key: cint, scancode: cint, action: cint,
#                   mods: cint){.cdecl.} =
#     screen.screenType.selectleft()

# proc rightCallback*(screen: PScreen, window: glfw.Window,
#                   key: cint, scancode: cint, action: cint,
#                   mods: cint){.cdecl.} =
#     screen.screenType.selectright()

# proc enterCallback*(screen: PScreen, window: glfw.Window,
#                   key: cint, scancode: cint, action: cint,
#                   mods: cint){.cdecl.} =
#     screen.screenType.selectenter(screen)

# proc spaceCallback*(screen: PScreen, window: glfw.Window,
#                   key: cint, scancode: cint, action: cint,
#                   mods: cint){.cdecl.} =
#     screen.screenType.selectspace()

