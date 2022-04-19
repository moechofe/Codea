--[[
This tab will fill a mesh() with one rect per glyph.

It use a Layout table previously computes from the "Layout" tab.
]]

-- Compute bounding box and texture coords for each glyph and call a callback function
local function compute(str,data,scale,space,glyph)
  local ts=tostring
  local sb=string.byte
  local mx=math.max
  local mn=math.min
  -- cursor
  local x,y=0,0
  -- font height
  local height=data.o*scale
  -- each glyph
  for c in str:gmatch"." do
    local d=data[ts(sb(c))]
    if d then
      -- rect dimension
      local w,h=d.w*scale,d.h*scale
      -- left-bottom corner
      local l,b=x+d.l*height,y+d.b*height
      local box=vec4(l+w/2,b+h/2,w,h)
      -- texture coords
      local uv=vec4(d.x/data.w,d.y/data.h,d.w/data.w,d.h/data.h)
      -- glyph width
      width=d.a*height
      -- advance cursor
      x=x+width+space*height
      -- report one glyph
      glyph(box,uv)
    end
  end
end

-- Add one rect per glyph and place it from left to right
local function push(m,str,y,data,scale,space)
  local x=compute(str,data,scale,space,function(box,uv)
    box.y=box.y+y
    local i=m:addRect(box:unpack())
    m:setRectTex(i,uv:unpack())
    rect(box:unpack())
  end)
end

-- Render lines of text from a layout.
local function render(m,layout,data,space)
  local y=0
  for i,line in pairs(layout.lines) do
    push(m,line,y,data,layout.scale,space)
    y=y-layout.height
  end
end

-- Render a text using previously computed layout into a mesh().
-- (mesh) m: destination mesh() Codea object.
-- (tbl) layout: the Layout table from the "Layout" tab.
-- (tbl) data: JSON info on where to find the glyph frame in the texture, where to place the rect and what size is should take.
-- (num) space: additional space between each glyph.
function renderLayout(m,layout,data,space)
  render(m,layout,data,space)
end
