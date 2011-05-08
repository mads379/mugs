###*
  @fileoverview Contains the implementation of the Multimap data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide("mugs.Multimap")

mugs.require("mugs.List")
mugs.require('mugs.RedBlack')
mugs.require('mugs.RedBlackLeaf')
mugs.require('mugs.RedBlackNode')

###
  Multimap
  
  A Multimap is a Map where many values can be associated with one key i.e key -> List(values) rather
  than key -> value. 
  
  @class mugs.Multimap provides the implementation of the Multimap ADT based on a Red Black Tree
###
mugs.Multimap = (keyValuePairs, comparator) -> 
  treeUnderConstruction = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK)
  if keyValuePairs instanceof Array and keyValuePairs.length > 0
    for kv in keyValuePairs
      val = (if kv.value instanceof Array then new mugs.List(kv.value) else new mugs.List([kv.value]))
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, val)
  this.tree_ = treeUnderConstruction  
  this.tree_.comparator = comparator if comparator?
  this

mugs.Multimap.prototype = new mugs.Traversable()

###
  Stores a key-value pair in the multimap.  
  
  @param key key to store in the multimap
  @param value value to store in the multimap
###
mugs.Multimap.prototype.insert = (key, value) -> 
  current_list = this.tree_.get(key).getOrElse(new mugs.List())
  new_tree     = this.tree_.insert(key, current_list.prepend(value))
  this.buildFromTree(new_tree)
  
###
  Returns a List of all values associated with a key.
  
  @param key key to search for in multimap
  @return A mugs.List of all the values associated with the given key.  
          Empty List if the key isn't in map
###
mugs.Multimap.prototype.get = (key) -> 
  this.tree_.get(key).getOrElse(new mugs.List())

###
  Removes a key-value pair from the multimap.
  
  @param key key of entry to remove from the multimap
  @param value value of entry to remove the multimap
###
mugs.Multimap.prototype.remove = (key, value) -> 
  currentList = this.tree_.get(key).getOrElse(new mugs.List())
  indexOfObjInList = currentList.findIndexOf( (item) -> item == value )
  newList = currentList.remove(indexOfObjInList)
  new_tree     = this.tree_.insert(key, newList)
  this.buildFromTree(new_tree)

###
   Removes all values associated with a given key.
   
   @param key key of entries to remove from the multimap
   @return A new mugs.Multimap without any values associated the the key 
###
mugs.Multimap.prototype.removeAll = (key) -> 
  this.buildFromTree(this.tree_.remove(key))

###
  Checks if the key is in the Multimap

  @return True if the Multimap contains the key, otherwise false
###
mugs.Multimap.prototype.contains = (key) -> 
  this.tree_.containsKey(key)

###
  Returns a mugs.List with all of the values in the Multimap. 
  
  @returns a mugs.List with all of the values in the Multimap
###
mugs.Multimap.prototype.values = () -> 
  this.tree_.values().flatMap( (list) -> list )

###
  Returns a mugs.List with all of the keys in the Multimap
  
  @returns a mugs.List with all of the keys in the Multimap
###
mugs.Multimap.prototype.keys = () -> 
  this.tree_.keys()

###
  @private
###
mugs.Multimap.prototype.buildFromTree = (tree) ->
  map = new mugs.Multimap([], this.comparator)
  map.tree_ = tree
  map