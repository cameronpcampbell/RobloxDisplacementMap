--!strict

local AssetService = game:GetService("AssetService")

return function(
    res: number, scale: number, amplitude: number, surfaceAppearance: SurfaceAppearance
)
    local resBounds = res + 1
    
    local eMesh = Instance.new("EditableMesh")
    local eImage = AssetService:CreateEditableImageAsync(surfaceAppearance:GetAttribute("HeightMap"))
    local eImageNewSize = Vector2.new(resBounds, resBounds)
    eImage:Resize(eImageNewSize)
    local eImagePixels = eImage:ReadPixels(Vector2.zero, eImage.Size)
    
    local verts = {}
    
    local i = 0
    for x = 1, resBounds do
        for z = 1, resBounds do
            i += 1
            
            local start = (z - 1) * resBounds * 4 + (x - 1) * 4 + 1
            local r, g, b = eImagePixels[start], eImagePixels[start + 1], eImagePixels[start + 2]
            local height = ((r + g + b) / 3) * amplitude
            
            local vertId = eMesh:AddVertex(Vector3.new(x, height, z))
            verts[i] = vertId
            eMesh:SetUV(vertId, Vector2.new(x / resBounds, z / resBounds))
        end
    end
    
    for x = 1, res do
        for z = 1, res do
            local vertA, vertB, vertC, vertD = nil, nil, nil, nil
            local colStart, colEnd = (z-1) * (res+1), z * (res+1)
            local vertA, vertB, vertC, vertD =  verts[colStart + x], verts[colStart + x + 1], verts[colEnd + x], verts[colEnd + x + 1]

            eMesh:AddTriangle(vertA, vertB, vertC)
            eMesh:AddTriangle(vertD, vertC, vertB)
        end
    end
    
    local mesh = Instance.new("MeshPart")
    mesh.Size = Vector3.one * scale
    mesh.Anchored = true
    eMesh.Parent = mesh
    surfaceAppearance:Clone().Parent = mesh
    mesh.Parent = workspace
    
    return mesh
end
