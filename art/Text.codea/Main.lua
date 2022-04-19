--[[

"Text" Codea project
====================

Look at the "Demo" Codea project for a proper usage example, like "Text_short" and "Text_full".
This "Main.lua" file is my own developement and testing environement.

TODO
====

- scale the font height
- bake to image
- draw image
- center alignment

]]

local fnt
local cage
text_str="Hello SDF!"
local txt

function setup()
  fnt=setupFont(
    readImage(asset.documents.Dropbox.RecursiveSCR_png),
    json.decode(readText(asset.documents.Dropbox.RecursiveSCR_json)))
  
  parameter.text("text str",text_str,render)
  parameter.number("font scale",0.3,4.0,2.0,render)
  parameter.number("letter space",-0.2,0.2,0,render)
  
  parameter.integer("cage width",40,400,260,render)
  parameter.integer("cage height",40,400,260,render)
  
  parameter.action("text mode CORNER",function()
    textMode(CORNER)
    render()
  end)
  parameter.action("text mode CENTER",function()
    textMode(CENTER)
    render()
  end)
  
  render()
end

function render()
  cage=vec2(cage_width,cage_height)
  txt=Text(cage,text_str,fnt,font_scale)
end

function draw()
  background(40, 40, 50)

  translate(WIDTH/2,HEIGHT/2)
  stroke(127, 63, 63)
  strokeWidth(3)
  line(-400,0,400,0)
  line(0,-400,0,400)

  if textMode()==CENTER then
    rectMode(CENTER)
  else
    rectMode(CORNER)
  end
  noFill()
  rect(0,0,cage.x,cage.y)
  
  txt:draw()
end
