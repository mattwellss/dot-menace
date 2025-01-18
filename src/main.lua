import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "player"
local gfx <const> = playdate.graphics

local foodCount = 5
local winnerTextSprite = nil

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.
function playdate.update()


   -- Call the functions below in playdate.update() to draw sprites and keep
   -- timers updated. (We aren't using timers in this example, but in most
   -- average-complexity games, you will.)

   gfx.sprite.update()

   if foodCount == 0 then
      foodCount = -1
      winnerTextSprite = gfx.sprite.spriteWithText("You win!", 100, 50)
      winnerTextSprite:moveTo(200, 120)
      winnerTextSprite:add()
   end
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
   local food = MakeSprite("images/food", math.random(400), math.random(240))
   food:add()
   return food
end


function myGameSetUp()
   Player():add()
   for i = 1, foodCount, 1 do
      MakeFoodSprite()
   end
end

myGameSetUp()

