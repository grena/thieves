local class = require 'middleclass'

Collection = class('Collection')

function Collection:initialize()
    self.elements = {}
    self.count = 0
end

function Collection:empty()
    self.elements = {}
end

function Collection:size()
    return self.count
end

function Collection:add_(anObject)
    self.elements[self.count] = anObject
    self.count = self.count + 1
    return anObject
end

function Collection:insert_at_(anObject, anIndex)
    local index = self.count
    while ( index > anIndex  ) do
         self.elements[index] = self.elements[index-1]
    index = index - 1
    end
    self.elements[anIndex] = anObject
    self.count = self.count + 1
    return anObject
end

function Collection:removeObjectAt_(anIndex)
    local index = anIndex
    local anObject = self:at_(index)
    self.elements[index] = nil
    while ( index < self.count - 1 ) do
         self.elements[index] = self.elements[index + 1]
    index = index + 1
    end
    self.elements[self.count - 1] = nil
    self.count = self.count - 1
    return anObject
end

function Collection:remove_(anObject)
    local index = self:indexOf_(anObject)
    return self:removeObjectAt_(index)
end

function Collection:addAll_(aCollection)
    local enm = aCollection:enumerator()
    local item = enm:next()
    while ( item ~= nil ) do
    self.add_(item)
    item = enm:next()
    end
    return self
end

function Collection:indexOf_(anObject)
   local i, v = next(self.elements, nil)
   while i do
        if ( v == anObject ) then return i end
        i, v = next(self.elements, i)
    end
    return -1
end

function Collection:at_(index)
     return rawgettable( self.elements, index)
end

function Collection:at_put_(index, anObject)
    local oldObject = self.elements[index]
    self.elements[index] = anObject
    return oldObject
end

function Collection:contains_(anItem)
   if ( self:indexOf_(anItem) == -1 ) then return 0 end
   return 1
end

function Collection:isEmpty_(anObject)
    if ( self.count == 0 ) then return 1 end
    return 0
end

function Collection:isNotEmpty_(anObject)
    if ( self.count == 0 ) then return 0 end
    return 1
end

function Collection:sortBy_(astring) -- unfinished
    local enm =  self:enumerator()
    local c = 1
    local value = enm:next()
    while ( c < count ) do
        local e1 = self.elements[c]
        local d = c + 1
        while ( d < count ) do
            --local e2 =
           d = d + 1
        end
        c = c + 1
    end
    return enm
end