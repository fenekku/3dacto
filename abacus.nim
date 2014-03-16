
## Originally from fowltek's vector_math.nim

import math

type
  TVector2*[A] = tuple[x: A, y: A]

  TVector3*[A] = tuple[x: A, y: A, z: A]

  TVector4*[A] = tuple[x: A, y: A, z: A, w: A]


## 2-D vector

proc `$`*[T](a : TVector2[T]): string =
  result = "[" & $a.x & ", " & $a.y & "]"

proc vec2*[A](x, y: A): TVector2[A] =
  result.x = x
  result.y = y

proc `+`*[T](a, b: TVector2[T]): TVector2[T] {.inline.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
proc `+=`*[T](a: var TVector2[T], b: TVector2[T]) {.inline, noSideEffect.} =
  a = a + b

proc `-`*[T](a: TVector2[T]): TVector2[T] {.inline.} =
  result.x = -a.x
  result.y = -a.y
proc `-`*[T](a, b: TVector2[T]): TVector2[T] {.inline.}=
  result.x = a.x - b.x
  result.y = a.y - b.y
proc `-=`*[T](a: var TVector2[T], b: TVector2[T]) {.inline, noSideEffect.} =
  a = a - b

proc `*`*[T](a: TVector2[T], b: T): TVector2[T] {.inline.} =
  result.x = a.x * b
  result.y = a.y * b
proc `*`*[T](a, b: TVector2[T]): TVector2[T] {.inline.} =
  result.x = a.x * b.x
  result.y = a.y * b.y
proc `*=`*[T](a: var TVector2[T], b: float) {.inline, noSideEffect.} =
  a = a * b
proc `*=`*[T](a: var TVector2[T], b: TVector2[T]) {.inline, noSideEffect.} =
  a = a * b

proc `/`*[T](a: TVector2[T], b: cfloat): TVector2[T] {.inline.} =
  result.x = a.x / b
  result.y = a.y / b
proc `/=`*[T](a: var TVector2[T], b: float) {.inline, noSideEffect.} =
  a = a / b

proc `<`*[T](a, b: TVector2[T]): bool {.inline, noSideEffect.} =
  return a.x < b.x or (a.x == b.x and a.y < b.y)
proc `<=`*[T](a, b: TVector2[T]): bool {.inline, noSideEffect.} =
  return a.x <= b.x and a.y <= b.y
proc `==`*[T](a, b: TVector2[T]): bool {.inline, noSideEffect.} =
  return a.x == b.x and a.y == b.y

proc length*[T](a: TVector2[T]): float {.inline.} =
  return sqrt(pow(a.x, 2.0) + pow(a.y, 2.0))
proc lengthSq*[T](a: TVector2[T]): float {.inline.} =
  return pow(a.x, 2.0) + pow(a.y, 2.0)
proc distanceSq*[T](a, b: TVector2[T]): float {.inline.} =
  return pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0)
proc distance*[T](a, b: TVector2[T]): float {.inline.} =
  return sqrt(pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0))

proc rotate*[T](a: TVector2[T], phi: float): TVector2[T] =
  var c = cos(phi)
  var s = sin(phi)
  result.x = a.x * c - a.y * s
  result.y = a.x * s + a.y * c

# proc permul*[T](a, b: TVector2[T]): TVector2[T] =
#   result.x = a.x * b.x
#   result.y = a.y * b.y
# proc perpendicular*[T](a: TVector2[T]): TVector2[T] =
#   result.x = -a.x
#   result.y =  a.y
# proc cross*[T](a, b: TVector2[T]): float =
#   return a.x * b.y - a.y * b.x
proc dot*[T](a, b: TVector2[T]): float {.inline.} =
  return a.x*b.x + a.y*b.y

## 3-D Vector

proc `$`*[T](a : TVector3[T]): string =
  result = "[" & $a.x & ", " & $a.y & ", " & $a.z & "]"

proc vec3*[A](x, y, z: A): TVector3[A] =
  result.x = x
  result.y = y
  result.z = z

proc `+`*[T](a, b: TVector3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
proc `+=`*[T](a: var TVector3[T]; b: TVector3[T]) {.inline, noSideEffect.} =
  a = a + b

proc `-`*[T](a, b: TVector3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z
proc `-`*[T](a: TVector3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
proc `-=`*[T](a: var TVector3[T]; b: TVector3[T]) {.inline, noSideEffect.} =
  a = a - b

proc `*`*[T](a, b: TVector3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.x * b.x
  result.y = a.y * b.y
  result.z = a.z * b.z
proc `*`*[T](a: TVector3[T]; b: T): TVector3[T] {.inline, noSideEffect.}=
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b
proc `*=`*[T](a: var TVector3[T]; b: TVector3[T]) {.inline, noSideEffect.} =
  a = a * b
proc `*=`*[T](a: var TVector3[T]; b: T) {.inline, noSideEffect.} =
  a = a * b

proc `/`*[T](a: TVector3[T]; b: T): TVector3[T] {.inline, noSideEffect.}=
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b
proc `/=`*[T](a: var TVector3[T]; b: T) {.inline, noSideEffect.} =
  a = a / b
# check later
# proc cross*[T](a, b: TVector3[T]): TVector3[T] =
#   result.x = a.y * b.z - a.z * b.y
#   result.y = a.z * b.x - a.x * b.z
#   result.z = a.x * b.y - a.y * b.x

proc dot*[T](a, b: TVector3[T]): float {.inline, noSideEffect.} =
  result = a.x * b.x + a.y * b.y + a.z * b.z
proc length*[T](a: TVector3[T]): float {.inline, noSideEffect.} =
  result = sqrt(float(a.x * a.x + a.y * a.y + a.z * a.z))
proc lengthSq*[T](a: TVector3[T]): float {.inline, noSideEffect.} =
  result = a.x * a.x + a.y * a.y + a.z * a.z
proc distance*[T](a, b: TVector3[T]): float {.inline, noSideEffect.} =
  result = (a - b).length()
proc distanceSq*[T](a, b: TVector3[T]): float {.inline, noSideEffect.} =
  result = (a - b).lengthSq()
proc normalize*[T](a: TVector3[T]): TVector3[T] =
  result = a / length(a)

## 4-D vector math
proc vec4*[A](x, y, z, w: A): TVector4[A] =
  result.x = x
  result.y = y
  result.z = z
  result.w = w

proc `+`*[T](a: TVector4[T]; b: TVector4[T]): TVector4[T] {.inline, noSideEffect.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
  result.w = a.w + b.w
proc `+=`*[T](a: var TVector4[T]; b: TVector4[T]) {.inline, noSideEffect.} =
  a = a + b

proc `-`*[T](a: TVector4[T]): TVector4[T] {.inline, noSideEffect.} =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
  result.w = -a.w
proc `-`*[T](a, b: TVector4[T]): TVector4[T] {.inline, noSideEffect.} =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z
  result.w = a.w - b.w
proc `-=`*[T](a: var TVector4[T]; b: TVector4[T]) {.inline, noSideEffect.} =
  a = a - b

proc `*`*[T](a, b: TVector4[T]): TVector4[T] {.inline, noSideEffect.} =
  result.x = a.x * b.x
  result.y = a.y * b.y
  result.z = a.z * b.z
  result.w = a.w * b.w
proc `*`*[T](a: TVector4[T]; b: T): TVector4[T] {.inline, noSideEffect.}=
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b
  result.w = a.w * b
proc `*=`*[T](a: var TVector4[T]; b: TVector4[T]) {.inline, noSideEffect.} =
  a = a * b
proc `*=`*[T](a: var TVector4[T]; b: T) {.inline, noSideEffect.} =
  a = a * b

proc `/`*[T](a: TVector4[T]; b: T): TVector4[T] {.inline, noSideEffect.}=
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b
  result.w = a.w / b
proc `/=`*[T](a: var TVector4[T]; b: T) {.inline, noSideEffect.} =
  a = a / b


type
  TMatrix2*[A] = tuple[r1: TVector2[A],
                       r2: TVector2[A]]

  TMatrix3*[A] = tuple[r1: TVector3[A],
                       r2: TVector3[A],
                       r3: TVector3[A]]

  TMatrix4*[A] = tuple[r1: TVector4[A],
                       r2: TVector4[A],
                       r3: TVector4[A],
                       r4: TVector4[A]]

## 2-D Matrix math
proc matrix2*[T](r1x,r1y,r2x,r2y : T): TMatrix2[T] =
  result.r1.x = r1x
  result.r1.y = r1y
  result.r2.x = r2x
  result.r2.y = r2y
proc matrix2*[T](m : array[0..1,array[0..1,T]]): TMatrix2[T] =
  result.r1.x = m[0][0]
  result.r1.y = m[0][1]
  result.r2.x = m[1][0]
  result.r2.y = m[1][1]
proc matrix2*[T](m : array[0..3,T]): TMatrix2[T] =
  result.r1.x = m[0]
  result.r1.y = m[1]
  result.r2.x = m[2]
  result.r2.y = m[3]

proc c1*[T](a: TMatrix2[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.r1.x
  result.y = a.r2.x
proc c2*[T](a: TMatrix2[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.r1.y
  result.y = a.r2.y

proc T*[T](a: TMatrix2[T]): TMatrix2[T] {.inline, noSideEffect.} =
  result.x = vec2(a.r1.x, a.r2.x)
  result.y = vec2(a.r1.y, a.r2.y)

proc `*`*[T](a, b: TMatrix2[T]): TMatrix2[T] {.inline, noSideEffect.} =
  result.r1 = vec2( dot(a.r1, b.c1), dot(a.r1, b.c2) )
  result.r2 = vec2( dot(a.r2, b.c1), dot(a.r2, b.c2) )
proc `*`*[T](a: TMatrix2[T], b: TVector3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = dot(a.r1, b)
  result.y = dot(a.r2, b)
proc `*`*[T](a: TMatrix2[T], b: T): TMatrix2[T] {.inline, noSideEffect.} =
  result.r1 = a.r1 * b
  result.r2 = a.r2 * b

proc `+`*[T](a, b: TMatrix2[T]): TMatrix2[T] {.inline, noSideEffect.} =
  result.r1 = a.r1 + b.r1
  result.r2 = a.r2 + b.r2
proc `+=`*[T](a: var TMatrix2[T]; b: TMatrix2[T]) {.inline, noSideEffect.} =
  a = a + b

proc `-`*[T](a, b: TMatrix2[T]): TMatrix2[T] {.inline, noSideEffect.} =
  result.r1 = a.r1 - b.r1
  result.r2 = a.r2 - b.r2
proc `-=`*[T](a: var TMatrix2[T]; b: TMatrix2[T]) {.inline, noSideEffect.} =
  a = a - b

proc `/`*[T](a: TMatrix2[T]; b: T): TMatrix2[T] {.inline, noSideEffect.}=
  result.r1 = a.r1 / b
  result.r2 = a.r2 / b
proc `/=`*[T](a: var TMatrix2[T]; b: T) {.inline, noSideEffect.} =
  a = a / b

## 3-D matrix math
proc matrix3*[A](r1x,r1y,r1z,r2x,r2y,r2z,r3x,r3y,r3z : A): TMatrix3[A] =
  result.r1.x = r1x
  result.r1.y = r1y
  result.r1.z = r1z
  result.r2.x = r2x
  result.r2.y = r2y
  result.r2.z = r2z
  result.r3.x = r3x
  result.r3.y = r3y
  result.r3.z = r3z
proc matrix3*[A](m : array[0..2,array[0..2,A]]): TMatrix3[A] =
  result.r1.x = m[0][0]
  result.r1.y = m[0][1]
  result.r1.z = m[0][2]
  result.r2.x = m[1][0]
  result.r2.y = m[1][1]
  result.r2.z = m[1][2]
  result.r3.x = m[2][0]
  result.r3.y = m[2][1]
  result.r3.z = m[2][2]
proc matrix3*[A](m : array[0..8,A]): TMatrix3[A] =
  result.r1.x = m[0]
  result.r1.y = m[1]
  result.r1.z = m[2]
  result.r2.x = m[3]
  result.r2.y = m[4]
  result.r2.z = m[5]
  result.r3.x = m[6]
  result.r3.y = m[7]
  result.r3.z = m[8]

proc c1*[T](a: TMatrix3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.r1.x
  result.y = a.r2.x
  result.z = a.r3.x
proc c2*[T](a: TMatrix3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.r1.y
  result.y = a.r2.y
  result.z = a.r3.y
proc c3*[T](a: TMatrix3[T]): TVector3[T] {.inline, noSideEffect.} =
  result.x = a.r1.z
  result.y = a.r2.z
  result.z = a.r3.z

proc T*[T](a: TMatrix3[T]): TMatrix3[T] {.inline, noSideEffect.} =
  result.x = vec3(a.r1.x, a.r2.x, a.r3.x)
  result.y = vec3(a.r1.y, a.r2.y, a.r3.y)
  result.z = vec3(a.r1.z, a.r2.z, a.r3.z)

proc `*`*[T](a, b: TMatrix3[T]): TMatrix3[T] {.inline, noSideEffect.} =
  result.r1 = vec3( dot(a.r1, b.c1), dot(a.r1. b.c2), dot(a.r1. b.c3) )
  result.r2 = vec3( dot(a.r2, b.c1), dot(a.r2. b.c2), dot(a.r2. b.c3) )
  result.r3 = vec3( dot(a.r3, b.c1), dot(a.r3. b.c2), dot(a.r3. b.c3) )
proc `*`*[T](a: TMatrix3[T], b: TVector3[T]): TVector3[T] {.inline, noSideEffect.} =
  result = vec3( dot(a.r1, b), dot(a.r2, b), dot(a.r3, b) )
proc `*`*[T](a: TMatrix3[T], b: T): TMatrix3[T] {.inline, noSideEffect.} =
  result.r1 = a.r1 * b
  result.r2 = a.r2 * b
  result.r3 = a.r3 * b

proc `+`*[T](a, b: TMatrix3[T]): TMatrix3[T] {.inline, noSideEffect.} =
  result.r1 = a.r1 + b.r1
  result.r2 = a.r2 + b.r2
  result.r3 = a.r3 + b.r3
proc `+=`*[T](a: var TMatrix3[T]; b: TMatrix3[T]) {.inline, noSideEffect.} =
  a = a + b

proc `-`*[T](a, b: TMatrix3[T]): TMatrix3[T] {.inline, noSideEffect.} =
  result.r1 = a.r1 - b.r1
  result.r2 = a.r2 - b.r2
  result.r3 = a.r3 - b.r3
proc `-=`*[T](a: var TMatrix3[T]; b: TMatrix3[T]) {.inline, noSideEffect.} =
  a = a - b

proc `/`*[T](a: TMatrix3[T]; b: T): TVector4[T] {.inline, noSideEffect.}=
  result.x = a.r1 / b
  result.y = a.r2 / b
  result.z = a.r3 / b
  result.w = a.r4 / b
proc `/=`*[T](a: var TMatrix3[T]; b: T) {.inline, noSideEffect.} =
  a = a / b


## 3-D vector math that depends on 3-D matrix math
proc rotate*[T](a, b: TVector3[T], phi: float): TVector3[T] =
  ## Rotate a around b
  var phiRad = phi*math.PI / 180.0
  var c = cos(phiRad)
  var s = sin(phiRad)
  var one_minus_c = 1 - c
  var m = matrix3(b.x * b.x * one_minus_c + c, b.x * b.y * one_minus_c - b.z * s, b.x * b.z * one_minus_c + b.y * s,
                  b.y * b.x * one_minus_c + b.z * s, b.y * b.y * one_minus_c + c, b.y * b.z * one_minus_c - b.x * s,
                  b.x * b.z * one_minus_c - b.y * s, b.y * b.z * one_minus_c + b.x * s, b.z * b.z * one_minus_c + c
                 )
  result = m * a


## 4-D matrix math