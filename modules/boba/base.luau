--!nonstrict
--!optimize 2

--[[

    ▄ █ ▀█▀ █ ▄  Welcome To Hell @ wthrblx.com
     █▀█ █ █▀█   (c) Team Fireworks 2024-2026.

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
       claim that you wrote the original software. If you use this software
       in a product, an acknowledgment in the product documentation would be
       appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be
       misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.

]]

local INDENT = "  "

local function quote(x: any)
	local xType = typeof(x)
	if xType == "string" then
		x = string.format("%q", x)
	end
	return `{x} ({xType})`
end

local function quoteGot(x: any)
	return `got {quote(x)}`
end

local Result = {}
Result.__index = Result

export type ResultOk = typeof(setmetatable({} :: { ok: true }, Result))
export type ResultFail = typeof(setmetatable(
	{} :: { ok: false, expectedType: string, message: string, children: { Result } },
	Result
))

export type Result = ResultOk | ResultFail

Result.ok = table.freeze(setmetatable({ ok = true :: true }, Result)) :: Result

function Result.fail(expectedType: string, message: string, children: { Result }?): Result
	return setmetatable({
		ok = false :: false,
		expectedType = expectedType,
		message = message,
		children = children or {},
	}, Result)
end

function Result.clone(self: Result)
	return if self.ok then self else Result.fail(self.expectedType, self.message, self.children)
end

function Result.because(self: Result, sub: Result)
	return if self.ok
		then sub:clone()
		elseif sub.ok then self:clone()
		else Result.fail(self.expectedType, self.message, table.move(self.children, 1, #self.children, 2, { sub }))
end

function Result.format(self: Result, maybeIndent: string?): string
	if self.ok then
		return ""
	end

	local indent = maybeIndent or ""
	local lines = {}

	table.insert(lines, indent .. `expected {self.expectedType}`)
	table.insert(lines, indent .. "> " .. self.message)
	indent ..= INDENT

	for _, sub in self.children do
		if not sub.ok then
			table.insert(lines, sub:format(indent))
		end
	end

	return table.concat(lines, "\n")
end

function Result.__tostring(self: Result)
	return self:format()
end

---

local Boba = {}
Boba.__index = Boba
Boba.Result = Result
Boba.quote = quote
Boba.quoteGot = quoteGot

export type BobaInner<T> = {
	expectedType: string,
	match: (self: Boba<T>, x: unknown) -> Result,
	T: T,
	inner: T,
}

export type Boba<T> = typeof(setmetatable({} :: BobaInner<T>, Boba))

function Boba.new<T>(expectedType: string, match: (self: Boba<T>, x: any) -> Result): Boba<T>
	local self = setmetatable({
		expectedType = expectedType,
		match = match,
	}, Boba)
	self.T = self :: any
	self.inner = self :: any
	return self
end

-- FIXME: Luau types are bad </3
-- function boba.__call<T>(self: Type<T>, x: any)
function Boba.__call(self: any, x: any): Result
	return self:match(x)
end

function Boba.__tostring(self: Boba<any>)
	return `Boba<{self.expectedType}>`
end

function Boba.isMatch<T>(self: Boba<T>, x: any): boolean
	return self:match(x).ok
end

function Boba.cast<T>(self: Boba<T>, x: any): T?
	return if self:match(x).ok then x else nil
end

function Boba.assert<T>(self: Boba<T>, x: any): T
	local result = self:match(x)
	return if result.ok then x else error(result:format())
end

function Boba.fail(self: Boba<any>, message: string)
	return Result.fail(self.expectedType, message)
end

function Boba.Nickname<T>(self: Boba<T>, name: string): Boba<T>
	return Boba.new(name, self.match)
end

function Boba.Retype<T>(self: Boba<any>): Boba<T>
	return self
end

function Boba.Untype<T>(self: Boba<T>): Boba<any>
	return self
end

function Boba.And<L, R>(left: Boba<L>, right: Boba<R>): Boba<L & R>
	return Boba.new(`({left.expectedType}) & ({right.expectedType})`, function(self, x)
		local leftResult = left:match(x)
		if leftResult.ok then
			local rightResult = right:match(x)
			return if rightResult.ok
				then Result.ok
				else self:fail("it didn't match the right type"):because(rightResult)
		end
		return self:fail("it didn't match the left type"):because(leftResult)
	end)
end

function Boba.Or<L, R>(left: Boba<L>, right: Boba<R>): Boba<L | R>
	return Boba.new(`{left.expectedType} | {right.expectedType}`, function(self, x)
		local leftResult = left:match(x)
		local rightResult = right:match(x)
		if leftResult.ok or rightResult.ok then
			return Result.ok
		end
		return self:fail(`did not match any of: {left.expectedType}, {right.expectedType}`)
			:because(leftResult)
			:because(rightResult)
	end)
end

function Boba.Optional<T>(inner: Boba<T>): Boba<T?>
	return Boba.new(`({inner.expectedType})?`, function(_, x)
		if x == nil then
			return Result.ok
		end
		return inner:match(x)
	end)
end

function Boba.Predicate<T>(inner: Boba<T>, predicate: (value: T) -> (boolean, string?)): Boba<T>
	return Boba.new(`Predicate<{inner.expectedType}>`, function(self, x)
		local innerResult = inner:match(x)

		if innerResult.ok then
			local predicateOk, predicateError = predicate(x)
			if predicateOk then
				return Result.ok
			end

			return self:fail(predicateError or "value did not satisfy the predicate")
		end

		return innerResult
	end)
end

function Boba.Literal<T>(literal: T, nickname: string?): Boba<T>
	return Boba.new(nickname or tostring(literal), function(self, x)
		return if rawequal(x, literal) then Result.ok else self:fail(`only {literal} is accepted, but {quoteGot(x)}`)
	end)
end

function Boba.Typeof<T>(expected: string)
	return Boba.new(expected, function(self, x)
		return if typeof(x) == expected then Result.ok else self:fail(quoteGot(x))
	end)
end

function Boba.Array<V>(values: Boba<V>): Boba<{ V }>
	return Boba.new(`\{ {values.expectedType} \}`, function(self, x)
		if typeof(x) ~= "table" then
			return self:fail(`expected a table, but {quoteGot(x)}`)
		end

		local expected = #x
		local encountered = 0

		for key, value in pairs(x) do
			encountered += 1

			if encountered > expected or typeof(key) ~= "number" then
				return self:fail(`because there's non-numeric indexes, such as key {quote(key)}`)
			end

			local valueResult = values:match(value)
			if not valueResult.ok then
				return self:fail(`value at index #{key} doesn't match`):because(valueResult)
			end
		end

		return Result.ok
	end)
end

function Boba.Map<K, V>(keys: Boba<K>, values: Boba<V>): Boba<{ [K]: V }>
	return Boba.new(`\{ [{keys.expectedType}]: {values.expectedType} \}`, function(self, x)
		if typeof(x) ~= "table" then
			return self:fail(`expected a table, but {quoteGot(x)}`)
		end

		for key, value in pairs(x) do
			local keyResult = keys:match(key)
			if not keyResult.ok then
				return self:fail(`quoteGot unexpected key {quote(key)}`):because(keyResult)
			end

			local valueResult = values:match(value)
			if not valueResult.ok then
				return self:fail(`at key {quote(key)}`):because(valueResult)
			end
		end

		return Result.ok
	end)
end

function Boba.Set<K>(keys: Boba<K>): Boba<{ [K]: true }>
	return Boba.new(`\{ [{keys.expectedType}]: true \}`, function(self, x)
		if typeof(x) ~= "table" then
			return self:fail(`expected a table, but {quoteGot(x)}`)
		end

		for key, value in pairs(x) do
			local keyResult = keys:match(key)
			if not keyResult.ok then
				return self:fail(`quoteGot unexpected key {quote(key)}`):because(keyResult)
			end

			if value ~= true then
				return self:fail(`expected literal \`true\`, but at key {quote(key)} quoteGot {quote(value)}`)
			end
		end

		return Result.ok
	end)
end

function Boba.Struct<T>(struct: T & { [string]: Boba<any> }): Boba<T>
	local expectedPairs = { "[any]: any" }
	for key, value in struct :: { [string]: Boba<any> } do
		-- TODO: key could be better formatted here
		table.insert(expectedPairs, `{key}: {value.expectedType}`)
	end

	return Boba.new(`\{ {table.concat(expectedPairs, ", ")} \}`, function(self, x)
		if typeof(x) ~= "table" then
			return self:fail(`expected a table, but {quoteGot(x)}`)
		end

		for key, valueType in pairs(struct) do
			local value = x[key]
			local valueResult = valueType:match(value)
			if not valueResult.ok then
				return self:fail(`value at key {quote(key)}`):because(valueResult)
			end
		end

		return Result.ok
	end)
end

function Boba.ExhaustiveStruct<T>(struct: T): Boba<T>
	local expectedPairs = {}
	for key, value in (struct :: any) :: { [string]: Boba<any> } do
		-- TODO: key could be better formatted here
		table.insert(expectedPairs, `{key}: {value.expectedType}`)
	end

	return Boba.new(`\{ {table.concat(expectedPairs, ", ")} \}`, function(self, x)
		if typeof(x) ~= "table" then
			return self:fail(`expected a table, but {quoteGot(x)}`)
		end

		for key, valueType: any in pairs(struct :: any) do
			local value = x[key]
			local valueResult = valueType:match(value)
			if not valueResult.ok then
				return self:fail(`value at key {quote(key)}`):because(valueResult)
			end
		end

		for key in pairs(x) do
			if (struct :: any)[key] == nil then
				return self:fail(`{quote(key)} isn't included in exhaustive struct`)
			end
		end

		return Result.ok
	end)
end

local function Function(...: Boba<any>)
	local arguments = table.pack(...)
	return function(...: Boba<any>)
		local returns = table.pack(...)

		local argumentsFormatted, returnsFormatted = {}, {}
		for index = 1, arguments.n do
			argumentsFormatted[index] = arguments[index].expectedType
		end

		for index = 1, returns.n do
			returnsFormatted[index] = returns[index].expectedType
		end

		local expectedReturns = table.concat(argumentsFormatted, ", ")
		if returns.n ~= 1 then
			expectedReturns = "(" .. expectedReturns .. ")"
		end

		return Boba.new(`({table.concat(argumentsFormatted, ", ")}) -> {expectedReturns}`, function(self, x)
			if typeof(x) == "function" then
				return Result.ok
			end

			return Result.fail(self.expectedType, quoteGot(x))
		end)
	end
end

-- What the fuck Luau

-- stylua: ignore
type FunctionReturnsConstructor<Args...> =
	& (() -> Boba<(Args...) -> ()>)
	& (<T1>(Boba<T1>) -> Boba<(Args...) -> T1>)
	& (<T1, T2>(Boba<T1>, Boba<T2>) -> Boba<(Args...) -> (T1, T2)>)
	& (<T1, T2, T3>(Boba<T1>, Boba<T2>, Boba<T3>) -> Boba<(Args...) -> (T1, T2, T3)>)
	& (<T1, T2, T3, T4>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>) -> Boba<(Args...) -> (T1, T2, T3, T4)>)
	& (<T1, T2, T3, T4, T5>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>) -> Boba<(Args...) -> (T1, T2, T3, T4, T5)>)
	& (<T1, T2, T3, T4, T5, T6>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>) -> Boba<(Args...) -> (T1, T2, T3, T4, T5, T6)>)
	& (<T1, T2, T3, T4, T5, T6, T7>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>, Boba<T7>) -> Boba<(Args...) -> (T1, T2, T3, T4, T5, T6, T7)>)
	& (<T1, T2, T3, T4, T5, T6, T7, T8>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>, Boba<T7>, Boba<T8>) -> Boba<(Args...) -> (T1, T2, T3, T4, T5, T6, T7, T8)>)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>, Boba<T7>, Boba<T8>, Boba<T9>) -> Boba<(Args...) -> (T1, T2, T3, T4, T5, T6, T7, T8, T9)>)
	& ((...Boba<any>) -> Boba<(Args...) -> ...any>)

-- stylua: ignore
type FunctionConstructor =
	& (() -> FunctionReturnsConstructor<>)
	& (<T1>(Boba<T1>) -> FunctionReturnsConstructor<T1>)
	& (<T1, T2>(Boba<T1>, Boba<T2>) -> FunctionReturnsConstructor<T1, T2>)
	& (<T1, T2, T3>(Boba<T1>, Boba<T2>, Boba<T3>) -> FunctionReturnsConstructor<T1, T2, T3>)
	& (<T1, T2, T3, T4>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>) -> FunctionReturnsConstructor<T1, T2, T3, T4>)
	& (<T1, T2, T3, T4, T5>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>) -> FunctionReturnsConstructor<T1, T2, T3, T4, T5>)
	& (<T1, T2, T3, T4, T5, T6>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>) -> FunctionReturnsConstructor<T1, T2, T3, T4, T5, T6>)
	& (<T1, T2, T3, T4, T5, T6, T7>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>, Boba<T7>) -> FunctionReturnsConstructor<T1, T2, T3, T4, T5, T6, T7>)
	& (<T1, T2, T3, T4, T5, T6, T7, T8>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>, Boba<T7>, Boba<T8>) -> FunctionReturnsConstructor<T1, T2, T3, T4, T5, T6, T7, T8>)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9>(Boba<T1>, Boba<T2>, Boba<T3>, Boba<T4>, Boba<T5>, Boba<T6>, Boba<T7>, Boba<T8>, Boba<T9>) -> FunctionReturnsConstructor<T1, T2, T3, T4, T5, T6, T7, T8, T9>)
	& ((...Boba<any>) -> FunctionReturnsConstructor<...any>)

Boba.Function = Function :: FunctionConstructor

Boba.Any = Boba.new("any", function()
	return Result.ok
end) :: Boba<any>

Boba.Unknown = Boba.new("unknown", function()
	return Result.ok
end) :: Boba<unknown>

Boba.Never = Boba.new("never", function(self)
	return self:fail("there are no valid values")
end) :: Boba<never>

Boba.Boolean = Boba.Typeof("boolean") :: Boba<boolean>
Boba.Buffer = Boba.Typeof("buffer") :: Boba<buffer>
Boba.AnyFunction = Boba.Typeof("function") :: Boba<(...any) -> ...any>
Boba.Number = Boba.Typeof("number") :: Boba<number>
Boba.String = Boba.Typeof("string") :: Boba<string>
Boba.Table = Boba.Typeof("table") :: Boba<{ [any]: any }>
Boba.Thread = Boba.Typeof("thread") :: Boba<thread>
Boba.Vector = Boba.Typeof("vector") :: Boba<vector>

Boba.True = Boba.Literal(true):Untype() :: Boba<true>
Boba.False = Boba.Literal(false):Untype() :: Boba<false>
Boba.Nil = Boba.Literal(nil) :: Boba<nil>

table.freeze(Boba)
return Boba
