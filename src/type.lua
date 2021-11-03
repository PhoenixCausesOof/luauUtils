-- string / number to bool
local function tobool(v)
	if (v == 1 or v == "true") then
		return true;
	elseif (v == 0 or v == "false") then
		return false;
	end

	return v;
end

-- string to table
local function stot(s, p)
	local t = {};

	for sep in string.gmatch(s, p or "%S") do
		table.insert(t, sep);
	end

	return t;
end

-- table to string
local function ttos(t)
	local s = "";

	for _, c in ipairs(t) do
		s = s .. c;
	end

	return s;
end

-- bool to number
local function bton(b)
	b = tobool(b);

	if (b == true) then
		return 1;
	elseif (b == false) then
		return 0;
	end

	return b;
end

-- bool to string
local function btos(b)
	b = tobool(b);

	if (b == true) then
		return "true";
	elseif (b == false) then
		return "false";
	end

	return b;
end

-- number to table
local function ntot(n)
	if (n < 0) then
		n = -n; -- alternatively, n = n * -1;
	end

	local t = {};

	repeat
		table.insert(t, n % 10); -- n % 10 = n's last digit
		n = math.floor(n / 10);
	until n == 0;
	
	for i = 1, math.floor(#t/2) do -- reversing  algorithm
		local j = #t - i + 1
		t[i], t[j] = t[j], t[i]
	end
	
	return t;
end

return {
	ntot = ntot;
	ttos = ttos;
	stot = stot;
	bton = bton;
	btos = btos;
	tobool = tobool;
};