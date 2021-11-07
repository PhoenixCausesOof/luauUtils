local function new(className, properties, protected)
	local object = Instance.new(className);

	local function set(propertyName, propertyValue) 
		object[propertyName] = propertyValue;
	end

	for propertyName, propertyValue in pairs(properties) do
		if (protected) then
			pcall(set, propertyName, propertyValue);
		else
			set(propertyName, propertyValue);
		end
	end

	return object;
end

local function Set(object, properties, protected)
	local function set(propertyName, propertyValue) 
		object[propertyName] = propertyValue;
	end

	for propertyName, propertyValue in pairs(properties) do
		if (protected) then
			pcall(set, propertyName, propertyValue);
		else
			set(propertyName, propertyValue);
		end
	end

	return object;
end

local function GetServices()
	local services = setmetatable({}, {
		__index = function(self, serviceName)
			local service = game:GetService(serviceName);
			self[serviceName] = service;
			return service;
		end
	});

	local shortcuts = {
		["UIS"] = "UserInputService";
		["HTTP"] = "HttpService";
		["Sound"] = "SoundService";
		["SSS"] = "ServerScriptService";
		["SGui"] = "StarterGui";
		["SPlayer"] = "StarterPlayer";
		["SPack"] = "StarterPack";
	};

	for shortcut, serviceName in pairs(shortcuts) do
		services[shortcut] = services[serviceName];
	end

	return services;
end

local function hierarchySearch(hierarchy, root, retrieve)
	hierarchy, root, retrieve = string.split(hierarchy, "."), root or game, retrieve or function(t, k)
		return t[k];
	end
	
	local child;
	
	for _, k in ipairs(hierarchy) do
		child = retrieve(root, k);
		
		if (not child) then
			return nil;
		end
		
		root = child;
	end
	
	return child;
end

local function Weld(basePart, breakJoints, jointType, removeAnchor)
	jointType = jointType or "WeldConstraint";

	local function hasWheelJoint(part)
		for _, surface in ipairs({"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}) do
			for _, hingeSurface in ipairs({"Hinge", "Motor", "SteppingMotor"}) do
				if (part[surface].Name == hingeSurface) then
					return true;
				end
			end
		end

		return false
	end

	local function canBreakJoints(part)
		if (not breakJoints or hasWheelJoint(part)) then
			return false;
		end

		local connectedParts = part:GetConnectedParts();

		if (#connectedParts == 1) then
			return false;
		end

		for _, connectedPart in ipairs(connectedParts) do
			if (hasWheelJoint(connectedPart) or not connectedPart:IsDescendantOf(basePart)) then
				return false;
			end
		end

		return true;
	end

	local function weld(Part0, Part1, weldParent)
		local WeldConstraint = Part1:FindFirstChild("perfectWeld") or new(jointType, {
			Name = "perfectWeld";
			Part0  = Part0;
			Part1  = Part1;
			Parent = Part1;
		})

		return WeldConstraint;
	end

	local function weldParts(parts, primaryPart)
		for _, part in ipairs(parts) do
			if (canBreakJoints(part)) then
				part:BreakJoints();
			end
		end

		for _, part in ipairs(parts) do
			if (part ~= primaryPart) then
				weld(primaryPart, part, primaryPart);
			end
		end

		if (removeAnchor) then
			for _, part in ipairs(parts) do
				part.Anchored = false;
			end

			primaryPart.Anchored = false;
		end
	end

	local function perfectWeld()
		local Tool = basePart:FindFirstAncestorOfClass("Tool");
		local Parts = {};

		if (basePart:IsA("BasePart")) then
			table.insert(Parts, basePart);
		end

		for _, Instance in ipairs(basePart:GetDescendants()) do
			if Instance:IsA("BasePart") then
				table.insert(Parts, Instance);
			end
		end 

		local PrimaryPart = Tool and Tool:FindFirstChild("Handle") and Tool.Handle:IsA("BasePart") and Tool.Handle or
			basePart:IsA("Model") and basePart.PrimaryPart or Parts[1];

		if (PrimaryPart) then
			weldParts(Parts, PrimaryPart);
		else
			warn("Weld failed - PrimaryPart not found");
		end

		return Tool;
	end

	local Tool = perfectWeld();

	if (Tool and not game:GetService("RunService"):IsClient()) then
		basePart.AncestryChanged:Connect(perfectWeld);
	end
end

return {
	new = new;
	Set = Set;
	GetServices = GetServices;
	hierarchySearch = hierarchySearch;
	Weld = Weld;
};