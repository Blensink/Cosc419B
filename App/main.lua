--- The program's entry point.
-- Handles startup of composer, then calls the first scene.
-- @module main

local composer = require("composer")

---------------------
-- Set up background.
---------------------
display.setDefault("background", 1.0, 1.0, 1.0)

---------------------------------------------------------------------------
-- Add the composer stage to the stage (ensures background is at the back).
---------------------------------------------------------------------------
local displayStage = display.getCurrentStage()
displayStage:insert(composer.stage)
composer.gotoScene("view.createGameScene")

------------------
-- And here we go!
------------------