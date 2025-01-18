import "CoreLibs/graphics"
import "CoreLibs/sprites"

local tagActive <const> = 1
local tagRemoved <const> = 2

local gfx <const> = playdate.graphics

--- Make a number of food sprites
--- @param count integer
--- @return table
function MakeFoodSprites(count)
   local food = {}
   for i = 1, count, 1 do
      table.insert(food, MakeFoodSprite())
   end
   function food:activeCount()
      local activeCount = 0
      for i = 1, #food, 1 do
         if food[i]:getTag() == tagActive then
            activeCount = activeCount + 1
         end
      end

      return activeCount
   end
   return food
end

--- Create a sprite
--- @param spriteImagePath string
--- @param startX integer
--- @param startY integer
--- @return _Sprite
function MakeSprite(spriteImagePath, startX, startY)
   local spriteImage = gfx.image.new(spriteImagePath)
   assert(spriteImage)

   local sprite = gfx.sprite.new(spriteImage)
   sprite:moveTo(startX, startY)
   sprite:setCollideRect(0, 0, sprite:getSize())
   return sprite
end

function MakeFoodSprite()
   local _food = MakeSprite("images/food", math.random(400), math.random(240))
   function _food:remove()
      gfx.sprite.remove(self)
      self:setTag(tagRemoved)
   end

   function _food:add()
      gfx.sprite.add(self)
      _food:setTag(tagActive)
   end

   return _food
end
