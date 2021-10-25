local M = {};

-- coroutine.wrap(f, ...) but with no error propagation 
function M.Wrap(Func, ...)
	return coroutine.resume(coroutine.create(Func), ...);
end

-- t[k] but with recursion i.e. allows to search deeper
function M.find(t, k, recursion)
	local r = t[k];
	
	if (r) then
		return r;
	end
	
	if (recursion) then
		for _, v in pairs(t) do
			if (typeof(v) == "table") then
				r = M.find(v, k, recursion);
				
				if (r) then
					return r;
				end
			end
		end
	end
	
	return nil;
end

-- convert value to boolean
function M.tobool(v)
	if (v == 1 or v == "true") then
		return true;
	elseif (v == 0 or v == "false") then
		return false;
	end

	return v;
end

-- Instance.new(className) but better
function M.new(className, properties)
	local obj = Instance.new(className);

	for p, v in pairs(properties or {}) do
		pcall(function()
			obj[p] = v;
		end)
	end

	return obj;
end

-- Set multiple properties at the same time
function M.Set(obj, properties)
	for p, v in pairs(properties or {}) do
		pcall(function()
			obj[p] = v;
		end)
	end

	return obj;
end

-- easily access all services
function M.GetServices()
	-- trick
	
	local services = setmetatable({}, {
		__index = function(t, className)
			local v = game:GetService(className);
			t[className] = v;
			
			return v;
		end;
		__metatable = nil;
	})

	return services;
end

-- find an instance by hierarchy E.g.: M.hierarchySearch(game, "Workspace.Baseplate")
function M.hierarchySearch(root, hierarchy, child)
	root, hierarchy, child = root or game, string.split(hierarchy, '.'), nil;
	
	for _, objectName in ipairs(hierarchy) do
		child = root:FindFirstChild(objectName);
		root = child;
		
		if (not child) then
			return nil;
		end
	end
	
	return child;
end

-- upgraded qPerfectionWeld!
function M.Weld(basePart, breakJoints, jointType, removeAnchor)
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
		local WeldConstraint = Part1:FindFirstChild("perfectWeld") or M.new(jointType, {
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
			warn('Perfect weld failed - PrimaryPart not found');
		end
		
		return Tool;
	end
	
	local Tool = perfectWeld();
	
	if (Tool and not game:GetService("RunService"):IsClient()) then
		basePart.AncestryChanged:Connect(perfectWeld);
	end
end

function M.import(a, b)
	local globalEnvironment = getfenv(0);
	
	if (not b) then
		for key, value in pairs(a) do
			globalEnvironment[key] = value;
		end
	else
		for _, key in pairs(a) do
			globalEnvironment[key] = b[key];  
		end
	end
end

-- sort arrays by key
function M.sortArray(t, key)
	key = key or "Name";
	local d = {};
	
	for _, c in ipairs(t) do
		d[c[key]] = c;
	end
	
	return d;
end

return M;
