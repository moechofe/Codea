--[[
Demo "Text", demonstrate how to render text using a signed distance field technic and which features are supported.

Dependencies:
- "Text" Codea project for the glyph rendering, the SDF shader.
- "Font" Codea project for a list of already prepared fonts.
]]

-- the Font table, see: Tab "Font.lua" in "Text" Codea project.
local fnt
-- constrained size for the rendered text.
local size
-- a instance of the Text class.
local txt
-- the outputed bounding box
local box
-- parameter for the font fammily name.
font_name=""
-- parameter for the text to render.
text_str="Hello SDF!"
-- parameter for textMode
text_mode=0

local function setup()
  parameter.clear()
  parameter.action("⏮ Back",menu)
  parameter.integer("font_family",1,#listFont(),1,render)
  parameter.watch("font_name")
  parameter.number("font_scale",0.3,4.0,1.0,render)
  parameter.text("text_str",text_str,render)
  parameter.action("CENTER/CORNER",function()
    if text_mode==CENTER then
      text_mode=CORNER
    else
      text_mode=CENTER
    end
    render()
  end)
  parameter.color("fill_color",color(255),render)
  parameter.color("outline_color",color(0),render)
  parameter.integer("box_width",60,400,200,render)
  parameter.integer("box_height",60,400,100,render)
  parameter.number("letter_space",-0.5,0.5,0,render)
  render()
end

function render()
  font_name=listFont()[font_family]
  fnt=selectFont(font_family)
  size=vec2(box_width,box_height)
  
  -- CENTER or CORNER are supported, must be called before the Text() constructor.
  textMode(text_mode)
  -- render the text
  txt=Text(size,text_str,
    fnt,font_scale,
    fill_color,outline_color,
    letter_space,function(layout)
      box=layout.box
  end)
end

local function draw()
  background(40, 40, 50)
  
  -- center the origin
  translate(WIDTH/2,HEIGHT/2)
  if viewer.mode==FULLSCREEN then
    translate(-WIDTH*0.4,0)
  end
  
  -- draw a cross at origin
  stroke(255, 63, 127)
  strokeWidth(2)
  line(-100,0,100,0)
  line(0,-100,0,100)
  fill(255, 63, 127)
  font("Courier-Bold")
  fontSize(20)
  textMode(CORNER)
  text("origin 0,0",7,-25)
  
  -- draw the constrained box
  fill(127, 63, 255)
  local t=string.format("constraints %dx%s",
  math.floor(size.x),math.floor(size.y))
  if text_mode==CORNER then
    rectMode(CORNER)
    text(t,size.x-textSize(t),size.y+5)
  else
    rectMode(CENTER)
    text(t,size.x/2-textSize(t),size.y/2+5)
  end
  noFill()
  stroke(127, 63, 255)
  rect(0,0,size.x,size.y)
  
  -- draw the rendered text bounding box
  stroke(200, 196, 40)
  rectMode(CORNER)
  pushMatrix()
  translate(txt.pos:unpack())
  rect(box.min.x,box.min.y,box.size.x,box.size.y)
  popMatrix()

  -- draw the rendered text
  txt:draw()
end

function switchToTextFull()
  setup()
  _G.draw=draw
end
