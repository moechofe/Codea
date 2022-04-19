--[[
SDF (Signed Distance Field), is a technic that allow to draw text from a texture by keeping a relatively good quality even when drawing big letters. Also, it allows to draw colored outline at no cost.
]]

local mi=math.min
local ma=math.max

local function interpolate(p1,p2,v)
  return p1.y+((p2.y-p1.y)/(p2.x-p1.x))*(v-p1.x)
end

local function clamp(i,a,v)
  return ma(i,mi(a,v))
end

local function compute(fnt,range,value)
  return interpolate(
  vec2(fnt.scale.x,range.x),
  vec2(fnt.scale.y,range.y),
  value)
end

-- Apply the shader and it's uniforms.
local function apply(m,fnt,scale,fill,outline)
  m.texture=fnt.texture
  local s=shader(asset.documents.Text.SDF_Outline)
  s.fill=fill
  s.outline=outline
  s.fillWidth=compute(fnt,fnt.fillWidth,scale)
  s.fillEdge=s.fillWidth+compute(fnt,fnt.fillEdge,scale)
  s.outlineWidth=compute(fnt,fnt.outlineWidth,scale)
  s.outlineEdge=s.outlineWidth+compute(fnt,fnt.outlineEdge,scale)
  m.shader=s
end

-- Apply a SDF shader with the correct uniform parameter according to the desired font scale.
-- (mesh) m: a Codea mesh() object
-- (tbl) fnt: a Font table
-- (num) scale: the scale relative to the font baked into the texture.
-- (color) fill: of the glyph body.
-- (color) outline: of the glyph outline.
function applySdf(m,fnt,scale,fill,outline)
  apply(m,fnt,scale or 1.0,fill or color(255),outline or color(0))
end
