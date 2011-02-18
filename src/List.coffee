###*
  @fileoverview Contains the implementation of the List data structure.
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 
if require?
  Option   = require './option'
  Some     = Option.Some
  None     = Option.None

###*
  <p>List provides the implementation of the abstract data type 'List' based on a Singly-Linked list</p>
  
  @class List provides the implementation of the abstract data type 'List' based on a Singly-Linked list <br />
  @public
###
List = (elements...) ->
  
  [x,xs...] = elements    
  if (x == undefined or (x instanceof Array and x.length == 0))
    return new Nil()
  if (x instanceof Array) 
    [hd, tl...] = x
    this.head = hd
    this.tail = new List(tl)
  else 
    this.head = x
    this.tail = new List(xs) 
  
  ###*
    Helper method to construct a list from a value and another list 
    
    @private
  ###
  cons = (head, tail) ->
    l = new List(head)
    l.tail = tail
    return l
  
  this.isEmpty = () -> false 

  ###* 
    Update the value with index 'index'. This will copy all values up to the
    given index. 
  ###
  this.update = (index, element) -> 
    if index < 0 
      throw new Error("Index out of bounds by #{index}")
    else if (index == 0)
      cons(element, this.tail)
    else 
      cons(this.head, this.tail.update(index-1,element))
  
  ###*
    Return an Option containt the nth element in the list. Some(element) if it
    exists. Otherwise None
  ###
  this.get = (index) -> 
    if index < 0
      new None()
    else if (index == 0)
      new Some(this.head)
    else 
      this.tail.get(index-1)
  
  ###* 
    Returns an Option containing the last element in the list  
  ###
  this.last = () -> if this.tail.isEmpty() then new Some(this.head) else this.tail.last()

  ###*
    Returns an Option containing the first element in the list
  ###  
  this.first = () -> new Some(this.head)

  ###*
    Create a new list by appending this value
  ###
  this.append = (element) -> 
    cons(this.head, this.tail.append(element))
    
  ###*
    Create a new list by prepending this value
  ###
  this.prepend = (element) -> 
    cons(element,this)

  ###*
    Creates a list by appending the argument list to 'this' list.
  
    Consider two lists. A is the argument passed to the method append
    of list T. R is the resulting list. x2 is a copy of x1 etc.
  
    A: a -> b -> c -> Nil  
    T: x -> y -> z -> Nil   
    R: x2 -> y2 -> z2 -> A  
  
    Thus all of the elements of A are reused.
  ###
  this.appendList = (list) -> 
    cons(this.head, this.tail.appendList(list))
    
  ###*
    Creates a new list by copying all of the items in the argument 'list'
    before of 'this' list
  
    Consider two lists. A is the argument passed to the method prepend
    of list T. R is the resulting list. a2 is a copy of a1 etc.
  
    A: a -> b -> c -> Nil       
    T: x -> y -> z -> Nil   
    R: a2 -> b2 -> c3 -> T   
  
    Thus all of the elements of T are reused
  ###
  this.prependList = (list) -> 
    if list.isEmpty() then this else cons(list.head, this.prependList(list.tail))
  
  ###* 
    Applies a binary operator to a start value and all elements of this list, 
    going left to right
  ###
  this.foldLeft = (seed) -> (f) =>
    __foldLeft = (acc, xs) -> 
      if (xs.isEmpty())
        acc
      else 
        __foldLeft( f(acc, xs.head), xs.tail)
    __foldLeft(seed,this)

  ###*
    Applies a binary operator to a start value and all elements of this list, 
    going right to left
  ###
  this.foldRight = (seed) -> (f) =>
    __foldRight = (xs) -> 
      if (xs.isEmpty())
        seed
      else
        f( xs.head, __foldRight(xs.tail))
    __foldRight(this) 
    
  this

Nil = () -> 
  
  this.head = new None()
  this.tail = new None()

  this.isEmpty =     ()              -> true
  this.append =      (element)       -> new List(element)
  this.prepend =     (element)       -> new List(element)
  this.appendList =  (list)          -> list
  this.prependList = (list)          -> list
  this.last =        ()              -> new None()
  this.first =       ()              -> new None()
  this.get =         (index)         -> new None()
  this.update =      (index,element) -> throw new Error("Index out of bounds by #{index}")
  
  this

if exports?
  exports.List = List
  exports.Nil  = Nil 