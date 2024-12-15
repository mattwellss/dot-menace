import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local playerSprite = nil
local foodSprite = nil
local winnerTextSprite = nil
local momentumX, momentumY = 0, 0
local momentumMax = 5

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.
function playdate.update()
   assert(playerSprite)

   -- Poll the d-pad and move our player accordingly.
   -- (There are multiple ways to read the d-pad; this is the simplest.)
   -- Note that it is possible for more than one of these directions
   -- to be pressed at once, if the user is pressing diagonally.
   local isUpPressed = playdate.buttonIsPressed( playdate.kButtonUp )
   local isRightPressed = playdate.buttonIsPressed( playdate.kButtonRight )
   local isDownPressed = playdate.buttonIsPressed( playdate.kButtonDown )
   local isLeftPressed = playdate.buttonIsPressed( playdate.kButtonLeft )

   --- increase momentum up to a limit when buttons are pressed
   if momentumY > -10 and isUpPressed then
      momentumY = momentumY - 1
   end
   if momentumX < 10 and isRightPressed then
      momentumX = momentumX + 1
   end
   if momentumY < 10 and isDownPressed then
      momentumY = momentumY + 1
   end
   if momentumX > -10 and isLeftPressed then
      momentumX = momentumX - 1
   end

   --- momentum decays to zero when an X/Y direction isn't pressed
   if (not isUpPressed) and (not isDownPressed) then
      if momentumY > 0 then
         momentumY = momentumY - 1
      end
      if momentumY < 0 then
         momentumY = momentumY + 1
      end
   end
   if (not isLeftPressed) and (not isRightPressed) then
      if momentumX > 0 then
         momentumX = momentumX - 1
      end
      if momentumX < 0 then
         momentumX = momentumX + 1
      end
   end

   local rotation = 0
   if playdate.isCrankDocked() == false then
      rotation = playdate.getCrankPosition()
   end
   playerSprite:setRotation(rotation)
   playerSprite:moveBy(momentumX, momentumY)

   local posX, posY = playerSprite:getPosition()
   if posX > 400 then
      posX = posX - 400
      playerSprite:moveTo(posX, posY)
   end
   if posX < 0 then
      posX = posX + 400
      playerSprite:moveTo(posX, posY)
   end
   if posY > 240 then
      posY = posY - 240
      playerSprite:moveTo(posX, posY)
   end
   if posY < 0 then
      posY = posY + 240
      playerSprite:moveTo(posX, posY)
   end

   -- Call the functions below in playdate.update() to draw sprites and keep
   -- timers updated. (We aren't using timers in this example, but in most
   -- average-complexity games, you will.)

   gfx.sprite.update()
   playdate.timer.updateTimers()

   local collisions = gfx.sprite.allOverlappingSprites()

   for i = 1, #collisions do
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
   sprite:add() -- This is critical!
   sprite:setCollideRect(0, 0, sprite:getSize())
   return sprite
end

function myGameSetUp()

   playerSprite = MakeSprite("images/player", 200 ,120)
   foodSprite = MakeSprite("images/food", math.random(400), math.random(240))
end

myGameSetUp()

