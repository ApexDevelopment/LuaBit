-- test.lua - Unit tests for LuaBit

local bit = require("luabit")

local function to_u32(n)
	return n % 2^32
end

local function random_u32()
	local hi = math.random(0, 0xFFFF)
	local lo = math.random(0, 0xFFFF)
	return hi * 0x10000 + lo
end

local function assert_eq(actual, expected, msg, quiet_on_success)
	if actual ~= expected then
		error(string.format("[FAIL] %s: got 0x%X, expected 0x%X", msg, actual, expected))
	else
		if not quiet_on_success then
			print(string.format("[PASS] %s: 0x%X", msg, actual))
		end
	end
end

-- Test cases
local function run_tests()
	local a = 0xF0F0F0F0
	local b = 0x0F0F0F0F

	assert_eq(bit.band(a, b), 0x00000000, "band")
	assert_eq(bit.bor(a, b),  0xFFFFFFFF, "bor")
	assert_eq(bit.bxor(a, b), 0xFFFFFFFF, "bxor")
	assert_eq(bit.bnot(a),    0x0F0F0F0F, "bnot")
	assert_eq(bit.lshift(0x00000001, 4), 0x00000010, "lshift")
	assert_eq(bit.rshift(0x00000010, 4), 0x00000001, "rshift")

	-- Rotates
	assert_eq(bit.rol(0x12345678, 8),  0x34567812, "rol")
	assert_eq(bit.ror(0x12345678, 8),  0x78123456, "ror")

	-- Edge cases
	assert_eq(bit.band(0xFFFFFFFF, 0x0), 0x0, "band zero")
	assert_eq(bit.bnot(0x0), 0xFFFFFFFF, "bnot zero")
	assert_eq(bit.lshift(0x1, 31), 0x80000000, "lshift 31")
	assert_eq(bit.rshift(0x80000000, 31), 0x1, "rshift 31")
end

local function fuzz_inverse_tests(n)
	print(string.format("[INFO] Running %d inverse fuzz tests...", n))
	for i = 1, n do
		local a = random_u32()
		local b = random_u32()
		local s = math.random(0, 31)

		assert_eq(bit.bnot(bit.bnot(a)), a, "fuzz bnot inverse", true)
		assert_eq(bit.bxor(bit.bxor(a, b), b), a, "fuzz bxor inverse", true)
		assert_eq(bit.band(a, 0xFFFFFFFF), a, "fuzz band identity", true)
		assert_eq(bit.bor(a, 0), a, "fuzz bor identity", true)
		assert_eq(bit.ror(bit.rol(a, s), s), a, "fuzz rol-ror inverse", true)
		assert_eq(bit.rol(bit.ror(a, s), s), a, "fuzz ror-rol inverse", true)
	end
	print("[INFO] Inverse fuzz tests complete.")
end

run_tests()
math.randomseed(os.time())
fuzz_inverse_tests(1000)