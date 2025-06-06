# LuaBit

LuaBit provides 32-bit bitwise operations for Lua. It is portable and works across different Lua versions, adapting to the available bitwise operation support in the environment. If native bitwise operators or libraries are unavailable, it falls back to a pure Lua implementation.

## Features

- Bitwise AND (`band`)
- Bitwise OR (`bor`)
- Bitwise XOR (`bxor`)
- Bitwise NOT (`bnot`)
- Left shift (`lshift`)
- Right shift (`rshift`)
- Rotate left (`rol`)
- Rotate right (`ror`)

## Installation

Copy the `luabit.lua` and `native.lua` files into your project directory.

## Usage

To use LuaBit in your Lua project, simply import it:

```lua
local bit = require("luabit")

-- Example usage
local a, b = 0xF0F0F0F0, 0x0F0F0F0F
print(bit.band(a, b))  -- Output: 0
print(bit.bor(a, b))   -- Output: 4294967295
print(bit.bxor(a, b))  -- Output: 4294967295
print(bit.bnot(a))     -- Output: 252645135
```
