# RobloxDisplacementMap

# Example Usage
Add a string attribute called `HeightMap` to a surface appearance. Set its value to a roblox asset id (e.g `"rbxassetid://12345"`).

```lua
local RobloxDisplacementMap = require(--[[path to module here]])

RobloxDisplacementMap(
  100 -- resolution: higher number == more tris
  .5 -- scale: the scale of the displaced geometry.
  5 -- amplitude: higher number == stronger/higher displacement.
  workspace.MySurfaceAppearance -- surfaceAppearance: the surface appearance to displace.
)
```

example SurfaceAppearance:
![image](https://github.com/MightyPart/RobloxDisplacementMap/assets/66361859/4c89c6db-3cc1-4a4d-9c94-4c98967faff5)
