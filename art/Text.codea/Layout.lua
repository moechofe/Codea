--[[
This tab will compute a Layout table that contains information on how to make sure, a text can fit inside a constrained box.

A Layout table have these properies:
- (num) scale= the scale to apply,
- (tbl) lines= an array of (str) lines,
- (num) height= the computed font height,
- (bounds) box= the computed bounding box.
]]

-- compute bounding box for a glyph
local function glyphBox(x,y,c,d,scale,height)
  -- bottom-left corner
  local b,l=y+d.b*height,x+d.l*height
  -- width and height
  local w,h=d.w*scale,d.h*scale
  -- return a CORNERS bounding box
  return vec4(l,b,l+w,b+h)
end

-- compute bounding box for a word
local function wordBox(x,y,word,data,scale,space,height)
  local ts=tostring
  local sb=string.byte
  local mx=math.max
  local mn=math.min
  -- left, bottom, right, top boundaries
  local l,b,r,t=10000,10000,-10000,-10000
  -- compute a box for each glyph
  for c in word:gmatch"." do
    -- print(json.encode(c),json.encode(sb(c)))
    local d=data[ts(sb(c))]
    if d then
      local box=glyphBox(x,y,c,d,scale,height)
      l=mn(l,box.x)
      b=mn(b,box.y)
      r=mx(r,box.z)
      t=mx(t,box.w)
      x=x+(d.a+space)*height
    end
  end
  -- return a bounds()
  return bounds(vec3(l,b),vec3(r,t)),x
end

-- split a text into word and new line char
local function worder(str)
  local sb=string.byte
  local su=string.sub
  local cy=coroutine.yield
  local l=#str
  return coroutine.wrap(function()
    local w=""
    for i=1,l do
      local c=sb(str,i,i)
      -- printable chars except space
      if c>=33 and c<=126 then
        w=w..su(str,i,i)
      -- space
      elseif c==32 then
        if #w>0 then cy(w) end
        w=""
      -- new line
      elseif c==10 then
        if #w>0 then cy(w) end
        w=""
        cy(false,c)
      end
    end
    if #w>0 then cy(w) end
  end)
end

-- Compute if a text can fit in a particular size
local function layout(str,size,data,scale,space)
  local ti=table.insert
  -- font height
  local height=data.o*scale
  -- list of validated lines
  local lines={}
  -- WIP line
  local line=""
  -- cursor and previous
  local x,y,prevX=0,0,0
  -- word bounding box
  local box
  -- WIP line bounding box and previous
  local lineBox,prevBox
  -- the whole text bounding box
  local wholeBox
  -- for each word
  for word,ctrl in worder(str) do
    -- insert a new line char
    if ctrl==10 then
      x=0
      y=y-height
      ti(lines,line)
      line=""
    else
      -- compute the bounding box
      box,x=wordBox(x,y,word,data,scale,space,height)
      -- and the current line one
      if not lineBox then
        lineBox=bounds(box.min,box.max)
      else
        lineBox:encapsulate(box.min)
        lineBox:encapsulate(box.max)
      end
      -- doesn't fit in x axis
      if lineBox.size.x>size.x then
        if not prevBox then
          return false
        end
        -- rollback and make it likes box was compute on the next line
        box:translate(vec3(-prevX,-height))
        lineBox:set(prevBox.min,prevBox.max)
        lineBox:encapsulate(box.min)
        lineBox:encapsulate(box.max)
        -- reset and update cursor
        x=x-prevX
        y=y-height
        -- add a new line
        ti(lines,line)
        line=""..word
      elseif #line>0 then
        line=line.." "..word
      else
        line=line..word
      end
      -- add a space in case there is still word to render after this one
      box,x=wordBox(x,y," ",data,scale,space,height) 
      lineBox:encapsulate(box.min)
      lineBox:encapsulate(box.max)
      -- used to rollbackifnext word doesn't fit
      prevBox=bounds(lineBox.min,lineBox.max)
      prevX=x
      -- compute the output bounding box
      if not wholeBox then
        wholeBox=bounds(lineBox.min,lineBox.max)
      else
        wholeBox:encapsulate(lineBox.min)
        wholeBox:encapsulate(lineBox.max)
      end
      -- detect if the render text will bit the box
      if wholeBox.size.y>size.y or lineBox.size.x>size.x then
        return false
      end
    end
  end
  -- add last line
  if #line>0 then ti(lines,line) end
  -- return layout information
  return true,lines,height,wholeBox
end

-- Compute a bounding box for a text to be rendered inside a constrained box. Will reduce the font size until the text fit.
-- ⚠️ 
-- This can take a lot of time, do not do this inside the draw() function or, inside a callback for a user input.
-- (str) str: the text to render ascii7 only.
-- (vec2) size: to constrains the rendered text.
-- (tbl) data: the data property of a Font table.
-- (num) maxScale: will start with this, and will reduce it by 20% if the text overflow the constrained size.
-- (num) additional space between glyph.
-- (tbl) return the computed Layout table with:
--   (num) scale= the scale to apply,
--   (tbl) lines= an array of (str) lines,
--   (num) height= the computed font height,
--   (bounds) box= the computed bounding box.
function computeLayout(str,size,data,maxScale,space)
  local scale=maxScale or 1.0
  local canFit,lines,height,box=layout(str,size,data,scale,space)
  while not canFit do
    scale=scale*0.8
    canFit,lines,height,box=layout(str,size,data,scale,space)
  end
  return {
    scale=scale,
    lines=lines,
    height=height,
    box=box,
  }
end
