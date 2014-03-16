
type
  TCycleNode[T] = object
    previous,next : ref TCycleNode[T]
    data : T

  PCycleNode*[T] = ref TCycleNode[T]


proc newCycle*[T](items : varargs[T]): PCycleNode[T] =
  new(result)
  var tmpPtr : PCycleNode[T] = result
  for index, data in items:
    tmpPtr.data = data

    if index == (len(items) - 1):
      tmpPtr.next = result
      tmpPtr.next.previous = tmpPtr
    else:
      new(tmpPtr.next)
      tmpPtr.next.previous = tmpPtr
      tmpPtr = tmpPtr.next


proc next*[T](node : PCycleNode[T]): PCycleNode[T] {.inline.} =
  return node.next


proc prev*[T](node : PCycleNode[T]): PCycleNode[T] {.inline.} =
  return node.previous


iterator loop*[T](node : PCycleNode[T], times : int = 1): T {.inline.} =
  var tmpPtr : PCycleNode[T] = node
  var loops: int = 0

  while loops < times:
    yield tmpPtr.data
    tmpPtr = next(tmpPtr)
    if tmpPtr == node:
      inc(loops)


proc len*[T](node : PCycleNode[T]): int {.inline.} =
  var length : int = 0

  for e in node.loop():
    length += 1

  return length


when isMainModule:
  var cycleA : PCycleNode[string] = newCycle("Alfred","Natasha","Alice")

  for element in loop(cycleA):
    echo(element)
