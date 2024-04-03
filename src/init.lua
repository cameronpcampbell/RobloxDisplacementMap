--!strict

local AssetService = game:GetService("AssetService")

local function GetRgbaFromPixelsArray(pixelsArray: { number }, startIdx: number)
	return pixelsArray[startIdx], pixelsArray[startIdx + 1], pixelsArray[startIdx + 2], pixelsArray[startIdx + 3]
end

return function(baseMesh: MeshPart, amplitude: number)
	local surfaceAppearance = baseMesh:FindFirstChildOfClass("SurfaceAppearance")
	assert(surfaceAppearance, "RobloxDisplacementMap: The MeshPart Doesn't Have A SurfaceAppearance!")
	
	local heightMapId = surfaceAppearance:GetAttribute("HeightMap")
	assert(heightMapId and type(heightMapId) == "string", "RobloxDisplacementMap: The SurfaceAppearance needs a string attribute called \"HeightMap\"!")
	
	local heightMap = AssetService:CreateEditableImageAsync(heightMapId)
	local heightMapSize = heightMap.Size
	local heightMapSizeX, heightMapSizeY = heightMapSize.X, heightMapSize.Y
	local heightMapPixelsArray = heightMap:ReadPixels(Vector2.zero, heightMapSize)

	local mesh = baseMesh:Clone()
	mesh.Parent = baseMesh.Parent
	mesh.Name = "DisplacedMesh"
	mesh.Transparency = 0
	mesh.Parent = workspace

	baseMesh.Transparency = 1
	baseMesh.Locked = true

	local eMesh = AssetService:CreateEditableMeshFromPartAsync(baseMesh)
	eMesh.Parent = mesh
	
	local verts = eMesh:GetVertices() :: { number }
	
	local savedNewPositions: { [Vector3]: Vector3 } = {}
	for iter, vertId in verts do
		local vertPos = eMesh:GetPosition(vertId) :: Vector3
		
		local vertNewPos = savedNewPositions[vertPos]
		if vertNewPos then
			eMesh:SetPosition(vertId, vertNewPos)
			continue
		end
		
		local vertNormal, vertUv = eMesh:GetVertexNormal(vertId), eMesh:GetUV(vertId) :: Vector2
		
		local vertUvToImageX, vertUvToImageY =
			math.floor(math.abs(vertUv.X % 1) * heightMapSizeX), math.floor(math.abs(vertUv.Y % 1) * heightMapSizeY)
		
		local startIdx = (vertUvToImageY - 1) * heightMapSizeX * 4 + (vertUvToImageX - 1) * 4 + 1
		local r, g, b = GetRgbaFromPixelsArray(heightMapPixelsArray, startIdx)
		if r == nil or g == nil or b == nil then continue end
		local vertHeightColor = ((r + g + b) / 3)

		local cf = CFrame.new(vertPos, vertNormal.Unit)
		cf += (-cf.LookVector) * (vertHeightColor * amplitude)
		local vertNewPos = cf.Position

		eMesh:SetPosition(vertId, vertNewPos)
		
		savedNewPositions[vertPos] = vertNewPos
	end
	savedNewPositions = nil :: any
	
	return mesh
end
