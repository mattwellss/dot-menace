import "CoreLibs/graphics"
import "CoreLibs/sprites"

local tagActive <const> = 1
local tagRemoved <const> = 2

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Food").extends(gfx.sprite)

--- @class Food: _Sprite
Food = Food or {}

function Food:init()
   Food.super.init(self)
   self:setImage(assert(gfx.image.new("images/food")))
   self:moveTo(math.random(400), math.random(240))
   self:setCollideRect(0, 0, self:getSize())
end

function Food:add()
   Food.super.add(self)
   self:setTag(tagActive)
end

function Food:remove()
   Food.super.remove(self)
   self:setTag(tagRemoved)
end

--- Make a number of food sprites
--- @param count integer
--- @return table
function MakeFoodSprites(count)
   local food = {}
   for i = 1, count, 1 do
      table.insert(food, Food())
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

