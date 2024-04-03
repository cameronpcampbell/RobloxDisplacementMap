# RobloxDisplacementMap

# Example Usage
Add a string attribute called `HeightMap` to a surface appearance. Set its value to a roblox asset id (e.g `"rbxassetid://12345"`). Add this SurfaceAppearance to the MeshPart that you want to displace.

```lua
local RobloxDisplacementMap = require(--[[path to module here]])

RobloxDisplacementMap(
  workspace.MeshPart, -- baseMesh [MeshPart]: The Mesh To Displace.
  8 -- amplitude [Number]: The strength of the displacement
)
```

example SurfaceAppearance:

![image](https://github.com/MightyPart/RobloxDisplacementMap/assets/66361859/4c89c6db-3cc1-4a4d-9c94-4c98967faff5)
