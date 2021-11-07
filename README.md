# luauUtils

A collection of tools that may or may never help developing a project. This was intended for use in Roblox, but some utilities may work in native Lua.

## Installation

It's as simple as requiring the module by its Id (Roblox):

```
local M = require(7267811043);
```

After that, it's up to you what to do!

## Usage

The module can and is not limited to the following functions:

Weld an object and its children, create an Instance while simultaneously setting its properties:

```
local M = require(7267811043);

M.Weld(M.new("Part", {Parent = workspace}))
```

Join two tables together:

```
local t1, t2 = {1, 2, 3}, {4, 5, 6}

local t = table.join(t1, t2);

for i, v in ipairs(t) do
    print(i, v); --> 1 1
                 --> 2 2
                 --> 3 3
                 --> 4 4
                 --> 5 5
                 --> 6 6
end
```

And more!

## Credits
PhoenixCausesOof - Author

## Contributing

Would you like to contribute to the module? Please open an issue on the GitHub repository.
