--[[
Demo "Text", demonstrate how to render text using a signed distance field technic and which features are supported.

Dependencies:
- "Text" Codea project for the glyph rendering, the SDF shader.
- "Font" Codea project for a list of already prepared fonts.
]]

-- a instance of the Text class.
local txt
  
local function setup()
  parameter.clear()
  parameter.action("⏮ Back",menu)
  
  textMode(CORNER)
  txt=Text(vec2(100,50),"Hello Textbox")
end

local function draw()
  background(40, 40, 50)
  
  txt:draw(vec2(WIDTH/2,HEIGHT/2))
end

function switchToTextShort()
  setup()
  _G.draw=draw
end
