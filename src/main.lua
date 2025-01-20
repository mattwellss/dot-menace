import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "player"
import "snack"

local gfx <const> = playdate.graphics

function UpdateFn() end

function playdate.update()
   gfx.sprite.update()
   UpdateFn()
end


function GameSetup()
   local food = {}
   local hasWon = false

   Player():add()
   food = MakeSnacks(5)
   for i = 1, #food, 1 do
      food[i]:add()
   end

   UpdateFn = function ()
      if food:activeCount() == 0 then
         hasWon = true
      end
      if hasWon then
         hasWon = false
         local winnerTextSprite = gfx.sprite.spriteWithText("You win!", 100, 50)
         winnerTextSprite:moveTo(200, 120)
         winnerTextSprite:add()
      end

   end
end

function SplashSetup ()
   local splashSprite = gfx.sprite.new(gfx.image.new(assert("images/card")))
   splashSprite:moveTo(200, 80)
   splashSprite:add()

   local pressASprite = gfx.sprite.spriteWithText("Press A!!!", 100, 50)
   pressASprite:moveTo(200, 170)
   pressASprite:add()

   UpdateFn = function ()
      if playdate.buttonIsPressed(playdate.kButtonA) then
         gfx.sprite.removeAll()
         GameSetup()
      end
   end
end

function Init ()
   local menu = playdate.getSystemMenu()
   menu:addMenuItem(
      "Restart",
      function ()
         gfx.sprite.removeAll()
         SplashSetup()
      end
   )
   SplashSetup()
end


Init()

