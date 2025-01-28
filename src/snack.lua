import "CoreLibs/graphics"
import "CoreLibs/sprites"

local tagActive <const> = 1
local tagRemoved <const> = 2
local rand <const> = math.random

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Snack").extends(gfx.sprite)

--- @class Snack: _Sprite
Snack = Snack or {}

Snack.xDirection = 0
Snack.yDirection = 0

function getMovement()
   local direction = rand(1, 3)
   if rand(1, 2) == 1 then
      return -1 * direction
   end
   return direction
end

function Snack:init()
   Snack.super.init(self)
   self:setImage(assert(gfx.image.new("images/snack")))
   self:moveTo(rand(400), rand(240))
   self.xDirection, self.yDirection = getMovement(), getMovement()
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

function Snack:update()
   local posX, posY = self:getPosition()
   if posX <= 0 or posX >= 400 then
      self.xDirection = self.xDirection * -1
   end
   if posY <= 0 or posY >= 240 then
      self.yDirection = self.yDirection * -1
   end
   self:moveBy(self.xDirection, self.yDirection)
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

