--[[
This project contains a small amount of already prepared assets to use with the "Text" Codea project and render SDF text.

1. Copy the assets to your project:

You can copy the assets to you own project by using this two functions below, tap on it, tap on "Edit", tap on the font you want, tap on "Add to", tap on "Document" or "Dropbox" folder.
readImage() <-- click here
readText() <-- click here

Then, open your project and do the same thing to copy from "Document" to your project.
  
  2. Use the project as dependency:
  
  You can use this project as dependency and use the already prepared Font table used by the "Text" Codea project.
  
  Call the functions defined below to get a Font table. 
  
]]

local list={
  "C059RR",
  "CourierPrimeR",
  "DejaVuSansR",
  "GiduguR",
  "KeraleeyamR",
  "LaksamanR",
  "LiberationSNR",
  "PurisaR",
  "RecursiveSCR",
  "RecursiveSLR",
  "SurumaM",
  "TimmanaR",
  "UroobR",
  "Z003MI"
}

-- can be overrided by user if the "Font" project is not in the Documents folder
FontAssetPath=asset.documents.Font

local function fnt(name)
  return {
    texture=readImage(FontAssetPath[name.."_png"]),
    data=json.decode(readText(FontAssetPath[name.."_json"])),
    scale=vec2(0.3,4.0),
    fillWidth=vec2(0.36,0.5),
    fillEdge=vec2(0.30,0.01),
    outlineWidth=vec2(0.70,0.7),
    outlineEdge=vec2(0.30,0.01),
  }
end

FontVersion="art Font 1.0"

-- List all font families from this project
function listFont()
  return list
end

-- Return a Font table from a family name or index from the list.
function selectFont(nameOrIndex)
  if type(nameOrIndex)=="number" then
    return fnt(list[nameOrIndex])
  else
    return fnt(nameOrIndex)
  end
end
