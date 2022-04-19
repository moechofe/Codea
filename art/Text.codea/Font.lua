--[[
A Font is just a table with a bunch of defined properties:
- (image) texture: a Codea image that contains the SDF glyph for one font.
- (tbl) data: a JSON that contains the SDF glyph for one font.
- (vec2) scale: this two values of a scale applied to each glyphs is used as reference to compute the values for the following parameters. You can rely on the built-in default values.
- (vec2) fillWidth,fillEdge,outlineWidth,outlineEdge: are values used in the SDF shader, linearly computed with the scale of the rendered text and the scale property above. You can rely on the built-in default values.

The Font table didn't define the settings to render a text into a mesh but to define the source of the settings, parameters that will be used to setup the setting of a rendered text.

If a rendered font is using a scale of 4.0, then, the width of the outline will be 0.5. But if the scale is 0.3, so the width will be 0.36. Thoses values has been tested to ensure a clean and readable text even with big or small text.
]]

-- Helpher to create a Font table with default values.
-- (image) texture: a Codea image that contains the SDF glyph for one font.
-- (tbl) data: a JSON that contains the SDF glyph for one font.
function setupFont(texture,data)
  return {
    texture=texture,
    data=data,
    scale=vec2(0.3,4.0),
    fillWidth=vec2(0.36,0.5),
    fillEdge=vec2(0.30,0.01),
    outlineWidth=vec2(0.70,0.7),
    outlineEdge=vec2(0.30,0.01),
  }
end

-- can be overrided by user if the "Font" project is not in the Documents folder
TextAssetPath=asset.documents.Text

TextVersion="art Font 1.1"

--[[
v1.1 changelog
==============
Add an asset key variableto be overridden.
Update documentation.
Fix fill and outline color changing.

]]
