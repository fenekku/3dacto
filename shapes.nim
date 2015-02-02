## Squares and cubes

import unsigned #unsigned comparisons

import opengl

from colors import BLACK, WHITE

proc renderSquare(side : float, wire : bool, texture_id : uint32 = 0'u32) =
  var halfSide = side / 2.0
  if wire:
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
  else:
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)


  #if is textured
  if texture_id != 0'u32:
    glBindTexture(GL_TEXTURE_2D, texture_id)
    glBegin(GL_QUADS)

    glTexCoord2d(0,1)
    glVertex3f( -halfSide, halfSide, halfSide)

    glTexCoord2d(1,1)
    glVertex3f( halfSide, halfSide, halfSide)

    glTexCoord2d(1,0)
    glVertex3f( halfSide, -halfSide, halfSide)

    glTexCoord2d(0,0)
    glVertex3f( -halfSide, -halfSide, halfSide)

    glColor4ubv(addr(WHITE[0]))
    glEnd()
  else:
    glBegin(GL_QUADS)
    glVertex3f( -halfSide, halfSide, halfSide)
    glVertex3f( halfSide, halfSide, halfSide)
    glVertex3f( halfSide, -halfSide, halfSide)
    glVertex3f( -halfSide, -halfSide, halfSide)
    glEnd()

  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)


proc renderCube*(side : float, wire : bool, texture_id : uint32 = 0'u32) =
  glPushMatrix()

  # side faces
  renderSquare(side, wire, texture_id)
  glRotatef(90.0, 0.0, 0.5, 0.0)
  renderSquare(side, wire, texture_id)
  glRotatef(90.0, 0.0, 0.5, 0.0)
  renderSquare(side, wire, texture_id)
  glRotatef(90.0, 0.0, 0.5, 0.0)
  renderSquare(side, wire, texture_id)

  glRotatef(90.0, 0.0, 0.5, 0.0)

  #bottom and top faces
  glRotatef(90.0, 0.5, 0.0, 0.0)
  renderSquare(side, wire, texture_id)
  glRotatef(180.0, 0.5, 0.0, 0.0)
  renderSquare(side, wire, texture_id)

  glPopMatrix()
