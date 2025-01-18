import "CoreLibs/graphics"
import "CoreLibs/sprites"

local tagActive <const> = 1
local tagRemoved <const> = 2

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Snack").extends(gfx.sprite)

--- @class Snack: _Sprite
Snack = Snack or {}

function Snack:init()
   Snack.super.init(self)
   self:setImage(assert(gfx.image.new("images/snack")))
   self:moveTo(math.random(400), math.random(240))
   self:setCollideRect(0, 0, self:getSize())
end

function Snack:add()
   Snack.super.add(self)
   self:setTag(tagActive)
end

function Snack:remove()
   Snack.super.remove(self)
   self:setTag(tagRemoved)
end

--- Make a number of snack sprites
--- @param count integer
--- @return table
function MakeSnacks(count)
   local snacks = {}
   for i = 1, count, 1 do
      table.insert(snacks, Snack())
   end
   function snacks:activeCount()
      local activeCount = 0
      for i = 1, #snacks, 1 do
         if snacks[i]:getTag() == tagActive then
            activeCount = activeCount + 1
         end
      end

      return activeCount
   end
   return snacks
end

