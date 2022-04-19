--[[
The Text class can render a paragraph of ascii7 outlines text into a constrained box using a Signed Distance Field technic that provides clean redability at small or large scale.

Check the "Demo" project to discovers the features.

For a small example:
---
function setup()
  txt=Text(vec2(100,50),"Hello Textbox")
end

function draw()
  txt:draw(vec2(WIDTH/2),HEIGHT/2))
end
]]
Text=class()

function Text:init(size,str,font,scale,fill,outline,space,cb)
  font=font or selectFont"RecursiveSCR"
  scale=scale or 1.0
  fill=fill or color(255)
  outline=outline or color(0)
  space=space or 0
  self.m=mesh()
  applySdf(self.m,font,scale)
  local layout=computeLayout(str,vec2(size.x,size.y),font.data,scale,space)
  renderLayout(self.m,layout,font.data,space)
  local b=layout.box
  if textMode()==CENTER then
    self.pos=vec2(-b.min.x-b.size.x/2,-b.min.y-b.size.y/2)
  else
    self.pos=vec2(-b.min.x,-b.min.y)
  end
  if cb then cb(layout) end
end

function Text:draw(pos)
  pushMatrix()
  if pos then translate(pos:unpack()) end
  translate(self.pos:unpack())
  self.m:draw()
  popMatrix()
end
