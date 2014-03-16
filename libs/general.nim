import strutils

proc `$`*[T](a: openarray[T]): string =
  return "[" & join(map(a, proc (x:T): string = $x), ", ") & "]"