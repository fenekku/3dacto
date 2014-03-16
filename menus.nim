import opengl

import ftgl

import colors
import cycle
import general
import textbox

type
  TMenu* {.inheritable.} = object
    entries : PCycleNode[string]
    tBox : PTextBox
    selectedIdx* : int

  PMenu* = ref TMenu


iterator iterEntries*(menu : PMenu): string =
  for entry in menu.entries.loop():
    yield entry


proc initMenu(menu : PMenu; labels : varargs[string];
              width : float; height : float;
              xPadding : float = 10.0; yPadding : float = 10.0) =
  ## Content
  menu.entries = newCycle(labels)

  ## Display
  menu.tBox = newTextBox()

  var fnt = createBitmapFont("/usr/share/fonts/truetype/freefont/FreeSansBold.ttf")
  setFaceSize(fnt, 40, 60)
  menu.tBox.font(fnt)

  var halfMenuWidth = 0.0
  var halfMenuHeight = 0.0
  var box : array[0..5, cfloat]
  var layout = ftgl.createSimpleLayout()
  layout.setFont(fnt)
  layout.setAlignment(TTextAlignment.AlignCenter)
  layout.setLineLength(width)
  for entry in menu.iterEntries():
    layout.getBBox(entry, box)
    if (box[3] - box[0]) / 2 > halfMenuWidth:
      halfMenuWidth = (box[3] - box[0]) / 2
    if (box[4] - box[1]) / 2 > halfMenuHeight:
      halfMenuHeight = (box[4] - box[1]) / 2

  menu.tBox.halfDimensions(halfMenuWidth, halfMenuHeight)

  menu.tBox.setTextColor(colors.GREY)
  menu.tBox.setBgColor(colors.TRANSLUCENT_PALE_WHITE)


## Title Menu
proc newTitleMenu*(labels : varargs[string], width : float,
                   height : float): PMenu =
  new(result)
  initMenu(result, labels, width, height)


method selectup*(menu : PMenu) =
  menu.selectedIdx = (menu.selectedIdx - 1 + menu.entries.len()) mod menu.entries.len()


method selectdown*(menu : PMenu) =
  menu.selectedIdx = (menu.selectedIdx + 1 + menu.entries.len()) mod menu.entries.len()


method display*(m : PMenu) =
  glPushMatrix()
  var idx : int = 0

  for entry in m.iterEntries():
    m.tBox.render(entry, m.selectedIdx == idx)
    inc(idx)
    glTranslatef(0.0, -3*m.tBox.halfHeight, 0.0)

  glPopMatrix()


# type
#   TActionMenu = object of TMenu

#   PActionMenu* = ref TActionMenu


# proc newActionMenu*(labels : array[0..3, string], width : float,
#                     height : float): PActionMenu =
#   new(result)
#   initMenu(result, labels, width, height)
#   setFaceSize(result.font, 40, 72)


# proc selectup*(m : PActionMenu) =
#   if m.selectedIdx == 2:
#     m.selectedIdx = 1
#   elif m.selectedIdx == 3:
#     m.selectedIdx = 0

# proc selectdown*(m : PActionMenu) =
#   if m.selectedIdx == 0:
#     m.selectedIdx = 3
#   elif m.selectedIdx == 1:
#     m.selectedIdx = 2

# proc selectleft*(m : PActionMenu) =
#   if m.selectedIdx == 1:
#       m.selectedIdx = 0
#   elif m.selectedIdx == 2:
#     m.selectedIdx = 3

# proc selectright*(m : PActionMenu) =
#   if m.selectedIdx == 0:
#     m.selectedIdx = 1
#   elif m.selectedIdx == 3:
#     m.selectedIdx = 2

# proc selectedIdx(halfMenuWidth: float, halfMenuHeight: float) =
#   glLineWidth(3.0)

#   glBegin(GL_LINES)
#   # Top Left
#   glVertex3f(-3.0*halfMenuWidth/8.0, 3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(-halfMenuWidth/4.0, 3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(-3.0*halfMenuWidth/8.0, menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(-3.0*halfMenuWidth/8.0, 3.0*menu.halfMenuHeight/10.0, 0.0)

#   # Top Right
#   glVertex3f(3.0*halfMenuWidth/8.0, 3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(halfMenuWidth/4.0, 3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(3.0*halfMenuWidth/8.0, menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(3.0*halfMenuWidth/8.0, 3.0*menu.halfMenuHeight/10.0, 0.0)

#   # Bottom Left
#   glVertex3f(3.0*halfMenuWidth/8.0, -3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(halfMenuWidth/4.0, -3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(3.0*halfMenuWidth/8.0, -menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(3.0*halfMenuWidth/8.0, -3.0*menu.halfMenuHeight/10.0, 0.0)

#   # Bottom Right
#   glVertex3f(-3.0*halfMenuWidth/8.0, -3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(-halfMenuWidth/4.0, -3.0*menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(-3.0*halfMenuWidth/8.0, -menu.halfMenuHeight/10.0, 0.0)
#   glVertex3f(-3.0*halfMenuWidth/8.0, -3.0*menu.halfMenuHeight/10.0, 0.0)
#   glEnd()

#   glLineWidth(1.0)


# proc display*(m : PActionMenu,
#               backgroundColor: array[0..3, uint8] = colors.TRANSLUCENT_PALE_WHITE,
#               foregroundColor: array[0..3, uint8] = colors.GREY) =

#   glPushMatrix()

#   var halfMenuWidth = m.width / 4.0
#   var menu.halfMenuHeight = m.height / 8.0

#   glColor4ubv(backgroundColor)

#   glBegin(GL_QUADS)
#   glVertex3f(-halfMenuWidth, menu.halfMenuHeight, 0.0)    # Top Left
#   glVertex3f( halfMenuWidth, menu.halfMenuHeight, 0.0)    # Top Right
#   glVertex3f( halfMenuWidth,-menu.halfMenuHeight, 0.0)    # Bottom Right
#   glVertex3f(-halfMenuWidth,-menu.halfMenuHeight, 0.0)    # Bottom Left
#   glEnd()

#   glColor4ubv(foregroundColor)

#   var idx : int = 0

#   for entry in m.iterEntries():
#     glPushMatrix()

#     case idx
#     of 0: glTranslatef(-halfMenuWidth/2.0, menu.halfMenuHeight/2.0, 0.0)
#     of 1: glTranslatef( halfMenuWidth/2.0, menu.halfMenuHeight/2.0, 0.0)
#     of 2: glTranslatef( halfMenuWidth/2.0,-menu.halfMenuHeight/2.0, 0.0)
#     of 3: glTranslatef(-halfMenuWidth/2.0,-menu.halfMenuHeight/2.0, 0.0)
#     else: nil

#     if m.selectedIdx == idx:
#       selectedIdx(halfMenuWidth, menu.halfMenuHeight)

#     # Raster from translated state
#     glRasterPos3f(-halfMenuWidth/4.0, -1.25*menu.halfMenuHeight/10.0, 0.0)
#     render(m.font, entry, TRenderMode.RenderAll)

#     glPopMatrix()

#     idx += 1

#   glPopMatrix()
