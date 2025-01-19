import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics
local momentumMax <const> = 10

class("Player").extends(gfx.sprite)

--- @class Player: _Sprite
Player = Player or {}

Player.xMomentum = 0
Player.yMomentum = 0
Player.xDirection = 0
Player.yDirection = 0

function Player:init()
   Player.super.init(self)
   self:setImage(assert(gfx.image.new("images/pointer")))
   self:moveTo(200, 120)
   self:setCollideRect(0, 0, self:getSize())
   --- @type _InputHandler
   local inputHandler = {
      downButtonDown = function ()
         self.yDirection = 1
      end,
      downButtonUp = function ()
         self.yDirection = 0
      end,
      upButtonDown = function ()
         self.yDirection = -1
      end,
      upButtonUp = function ()
         self.yDirection = 0
      end,
      rightButtonDown = function ()
         self.xDirection = 1
      end,
      rightButtonUp = function ()
         self.xDirection = 0
      end,
      leftButtonDown = function ()
         self.xDirection = -1
      end,
      leftButtonUp = function ()
         self.xDirection = 0
      end,
      cranked = function (change, acceleratedChange)
         local currentRotation = self:getRotation()
         self:setRotation(currentRotation + change)
      end
   }
   pd.inputHandlers.push(inputHandler, true)
end

function Player:remove()
   pd.inputHandlers.pop()
end

function Player:update()
   local playerX, playerY = self:getPosition()
   -- print(self.xDirection, self.yDirection, self.xMomentum, self.yMomentum)

   --- process momentum decay when no direction is active
   if self.xDirection == 0 then
      if self.xMomentum > 0 then
         self.xMomentum = self.xMomentum - 1
      end
      if self.xMomentum < 0 then
         self.xMomentum = self.xMomentum + 1
      end
   end

   if self.yDirection == 0 then
      if self.yMomentum > 0 then
         self.yMomentum = self.yMomentum - 1
      end
      if self.yMomentum < 0 then
         self.yMomentum = self.yMomentum + 1
      end
   end

   --- handle momentum updates when direction is applied
   if math.abs(self.xMomentum) < momentumMax and math.abs(self.xDirection) > 0 then
      self.xMomentum = self.xMomentum + self.xDirection
   end

   if math.abs(self.yMomentum) < momentumMax and math.abs(self.yDirection) > 0 then
      self.yMomentum = self.yMomentum + self.yDirection
   end

   --- define new player coordinates
   local posX, posY, collisions = self:moveWithCollisions(
      playerX + self.xMomentum,
      playerY + self.yMomentum
   )

   --- apply new player coordinates
   if posX > 400 then
      self:moveTo(posX - 400, posY)
   end
   if posX < 0 then
      self:moveTo(posX + 400, posY)
   end
   if posY > 240 then
      self:moveTo(posX, posY - 240)
   end
   if posY < 0 then
      self:moveTo(posX, posY + 240)
   end

   for i, collision in pairs(collisions) do
      collision.other:remove()
   end
end
