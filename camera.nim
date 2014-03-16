# Camera class

import opengl
import strutils

import abacus

const
  near = 0.01
  far = 1000.0
  zoomRatio = 5.0

type
  TLens = enum
    perspective, orthonormal

  TCamera = object
    position : TVector3[float]
    aim : TVector3[float]
    up : TVector3[float]
    lens : TLens
    fov : float
    filmWidth*: float
    filmHeight*: float

  PCamera* = ref TCamera

var
  rotated = 0.0


proc place*(camera : PCamera) {.inline.} =
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  gluLookAt(camera.position.x, camera.position.y, camera.position.z,
            camera.aim[0], camera.aim[1], camera.aim[2],
            camera.up[0], camera.up[1], camera.up[2] )


proc place*(camera : PCamera, x : float, y : float, z : float) {.inline.} =
  camera.position.x = x
  camera.position.y = y
  camera.position.z = z

  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  gluLookAt(camera.position.x, camera.position.y, camera.position.z,
            camera.aim[0], camera.aim[1], camera.aim[2],
            camera.up[0], camera.up[1], camera.up[2] )


proc setOrthonormalLens*(camera : PCamera) =
  ## Sets the camera projection to
  ## an othonormal projection

  camera.lens = TLens.orthonormal

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  gluOrtho2D(-camera.filmWidth/2.0, camera.filmWidth/2.0,
             -camera.filmHeight/2.0, camera.filmHeight/2.0)


proc setPerspectiveLens*(camera : PCamera) =
  ## Resets the camera projection to
  ## a perspective projection

  camera.lens = TLens.perspective

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  gluPerspective(camera.fov, camera.filmWidth / camera.filmHeight,
                 near, far)


proc setFilmWidth*(camera : PCamera, width : float) {.inline.} =
  camera.filmWidth = width


proc setFilmHeight*(camera : PCamera, height : float) {.inline.} =
  camera.filmHeight = height


proc zoomIn*(camera : PCamera, zoom : float) =
  camera.fov = max(camera.fov - zoom * zoomRatio, 30.0)
  camera.setPerspectiveLens()


proc zoomOut*(camera : PCamera, zoom : float) =
  camera.fov = min(camera.fov + zoom * zoomRatio, 170.0)
  camera.setPerspectiveLens()


proc move*(camera : PCamera, movement : TVector3) =
  camera.position += movement


proc newCamera*(filmWidth: float, filmHeight: float,
                lensAngle : float,
                pos : TVector3[float] = vec3(0.0, 0.0, 1.0),
                aim : TVector3[float] = vec3(0.0, 0.0, 0.0),
                up : TVector3[float] = vec3(0.0, 1.0, 0.0),
                lens : TLens = TLens.orthonormal): PCamera =
  new(result)
  result.filmWidth = filmWidth
  result.filmHeight = filmHeight
  result.fov = lensAngle
  result.position = pos
  result.aim = aim
  result.up = up
  case lens:
  of TLens.orthonormal:
    result.setOrthonormalLens()
  of TLens.perspective:
    result.setPerspectiveLens()

  result.place()


proc rotateAround*(camera : PCamera, angle : float) =
  ##Takes rotation angle in degrees
  if (rotated + angle) in -45.0..45.0:
    rotated += angle
    camera.position = camera.position.rotate(camera.aim + camera.up,
                                             angle)
    camera.place()


proc `$`*(camera : PCamera): string =
  # proc floatToStr(x : float): string =
  #   formatFloat(x, format=ffDecimal, precision = 4)
  return """Camera .position=[$#,$#,$#]
                   .up=[$#,$#,$#]""" % [$camera.position.x,
                                         $camera.position.y,
                                         $camera.position.z,
                                         $camera.up[0], $camera.up[1],
                                         $camera.up[2]]


when isMainModule:
  # var test : int
  # var camcorder : PCamera

  # camcorder = newCamera([0.0, 0.0, 1.0], [0.0,0.0,0.0], [0.0,1.0,0.0])

  # var m : array[0..15, GLfloat]
  # var f : ptr GLdouble
  # opengl.loadExtensions()
  # glMatrixMode(GL_MODELVIEW)
  # glLoadIdentity()
  # glTranslatef(1.0,
  #              2.0,
  #              3.0)
  # glPushMatrix()
  # glGetDoublev(GL_MODELVIEW_MATRIX, f)
  # echo(repr(f))
  # import general
  # echo($m)