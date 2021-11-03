-- search value in table
local function find(t, v)
    for ref, val in pairs(t) do
        if (val == v) then
            return ref;
        end
    end 

    return nil;
end

--[[ 
    split a string into a table, with a string pattern.
]]
local function split(s, p)
    local t = {};

    for sep in string.gmatch(s, p or "%S") do
        table.insert(t, s);
    end

    return t;
end

local function join(t1, t2)
    local t = {};

    for _, value in pairs(t1) do
        t[#t + 1] = value;
    end

    for _, value in pairs(t2) do
        t[#t + 1] = value;
    end
    
    return t;
end

local function join2(t1, t2)
    local t = {t1};

    for _, value in pairs(t2) do
        t[#t + 1] = value;
    end

    return t;
end

local function sort(t1, f)
    f = f or function(v) 
        return v, v; 
    end;

    local t = {};

    for k, v in pairs(t1) do
        k, v = f(v);

        t[k] = v;
    end

    return t;
end

local function import(from, lib)
    local genv = getfenv(0);

    if (from and lib) then
        genv[from] = lib[from];
    elseif (from) then
        for k, v in pairs(from) do
            if (genv[k]) then
                warn("Name collision: ", k);
            end

            genv[k] = v;
        end
    end
end

local function wrap(f, ...)
    return coroutine.resume(coroutine.create(f), ...);
end

local function unpack(t)
    local d = {};

    for _, v in pairs(t) do
        for k, v in pairs(v) do
            if (d[k]) then
                warn("Name collision: ", k);
            end

            d[k] = v;
        end
    end

    return d;
end

return {
    find = find;
    split = split;
    join = join;
    join2 = join2;
    sort = sort;
    import = import;
    wrap = wrap;
    unpack = unpack;
};