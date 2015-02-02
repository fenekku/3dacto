
## textbox class

import opengl

import ftgl

import colors

type
  TTextBox* = object
    font : PFont
    halfWidth : float
    halfHeight* : float
    layout : PLayout
    xPadding : float
    yPadding : float
    textColor : array[0..3, uint8]
    bgColor : array[0..3, uint8]
    selected : bool

  PTextBox* = ref TTextBox


proc newTextBox*(): PTextBox =
  new(result)
  result.textColor = colors.BLACK
  result.bgColor = colors.WHITE
  result.layout = ftgl.createSimpleLayout()
  result.xPadding = 10.0
  result.yPadding = 10.0

proc font*( ptb : PTextBox, f : PFont) =
  ptb.font = f
  setFaceSize(ptb.font, 40, 60)
  ptb.layout.setFont(ptb.font)

proc halfDimensions*( ptb : PTextBox, halfX : float, halfY : float) =
  ptb.halfWidth = halfX + ptb.xPadding
  ptb.halfHeight = halfY + ptb.yPadding

proc setTextColor*( ptb : PTextBox, c : array[0..3, uint8]) =
  ptb.textColor = c

proc setBgColor*( ptb : PTextBox, bgC : array[0..3, uint8]) =
  ptb.bgColor = bgC

proc render*(ptb : PTextBox, t : string, selected : bool = false ) {.inline.} =

  glPushMatrix()

  ## Box
  if selected:
    glColor4ubv(addr(ptb.textColor[0]))
  else:
    glColor4ubv(addr(ptb.bgColor[0]))
  glBegin(GL_QUADS)
  glVertex3f(-ptb.halfWidth, ptb.halfHeight, 0.0)    # Top Left
  glVertex3f( ptb.halfWidth, ptb.halfHeight, 0.0)    # Top Right
  glVertex3f( ptb.halfWidth,-ptb.halfHeight, 0.0)    # Bottom Right
  glVertex3f(-ptb.halfWidth,-ptb.halfHeight, 0.0)    # Bottom Left
  glEnd()

  ## Box line
  glLineWidth(1.0)
  glBegin(GL_LINE_LOOP)
  glColor4ubv(addr(colors.BLACK[0]))
  glVertex3f(-ptb.halfWidth, ptb.halfHeight, 0.0)    # Top Left
  glVertex3f( ptb.halfWidth, ptb.halfHeight, 0.0)    # Top Right
  glVertex3f( ptb.halfWidth,-ptb.halfHeight, 0.0)    # Bottom Right
  glVertex3f(-ptb.halfWidth,-ptb.halfHeight, 0.0)    # Bottom Left
  glEnd()

  ## Textline
  var box : array[0..5, cfloat]
  ptb.layout.getBBox(t, box)
  # -(box[4] - box[1])/2 - ptb.yPadding
  glTranslatef(-ptb.halfWidth, -( (box[4]-box[1])/2 + box[1] ), 0.0)

  # glBegin(GL_LINE_LOOP)
  # glColor4ubv(colors.RED)
  # glVertex3f(box[0], box[1], box[2])
  # glVertex3f(box[0], box[4], box[2])
  # glVertex3f(box[3], box[4], box[5])
  # glVertex3f(box[3], box[1], box[5])
  # glEnd()

  ## Text
  # -(ptb.halfHeight - ptb.yPadding)/2
  if selected:
    glColor4ubv(addr(ptb.bgColor[0]))
  else:
    glColor4ubv(addr(ptb.textColor[0]))
  ptb.layout.setLineLength( 2*ptb.halfWidth )
  # layout.setLineSpacing(boxHeight)
  ptb.layout.setAlignment(TTextAlignment.AlignCenter)
  glRasterPos3f(0.0, 0.0, 0.0) #-screenType.camcorder.filmWidth/2.0

  ptb.layout.render(t, TRenderMode.RenderAll)

  glPopMatrix()

