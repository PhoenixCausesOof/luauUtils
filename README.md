# luauUtils

A collection of tools that may or may never help developing a project. This was intended for use in Roblox, but some utilities may work in native Lua.

## Installation

It's as simple as requiring the module by its Id (Roblox):

```
local luauUtils = require(7267811043);
```

After that, it's up to you what to do!

## Usage

The module can, but is not limited to:

Trimming the ends of a string:

```lua
local luauUtils = require(7267811043);

local str = "\0\0\0hello world\0\0\0";
str = luauUtils.trim(str); -- removes spaces in the ends of the string, by default.
```

Joining two tables together:

```lua
local luauUtils = require(7267811043);
local t1, t2 = {1, 2, 3}, {4, 5, 6};

local t = luauUtils.join(t1, t2);

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
