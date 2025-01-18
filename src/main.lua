import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "player"
import "food"

local gfx <const> = playdate.graphics

local winnerTextSprite = nil
local food
local hasWon = false

function playdate.update()
   gfx.sprite.update()

   if food:activeCount() == 0 then
      hasWon = true
   end
   if hasWon then
      hasWon = false
      winnerTextSprite = gfx.sprite.spriteWithText("You win!", 100, 50)
      winnerTextSprite:moveTo(200, 120)
      winnerTextSprite:add()
   end
end


function myGameSetUp()
   Player():add()
   food = MakeFoodSprites(5)
   for i = 1, #food, 1 do
      food[i]:add()
   end
end

myGameSetUp()

