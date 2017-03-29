
local pq  = {}

local math_random, math_randomseed = math.random, math.randomseed
local string_left, string_explode, string_implode = string.Left, string.Explode, string.Implode
local os_time = os.time

pq.BaseT  = function ( ) return {           } end
pq.BaseMT = function (a) return {__index = a} end

pq.createobject = function (a, b)
	a = a or pq.BaseT ()
	setmetatable (a, b or pq.BaseMT (a))
	return a
end

pq.push = function (a, b) a:SetString (a:GetString ()..tostring (b)) return a end
pq.key  = function (a, b) a:SetKey (b) return a end

local encoding = {}
encoding.int = {
	t = {{"H", "h"}, {"O", "o"}, {"N", "n"}},
	b = "/", d = "|", l = {6, 9},
	m = "`1234567890-=qwertyuiop[]\\asdfghjkl;'zxcvbnm,./~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?	 "
}
encoding.ext = {}

pq.createstring = function(a, b, c)
	local d = ""

	for e = 1, b do
		for f = 1, #encoding.int.t do
			d = d..encoding.int.t[f][math_random (1, #encoding.int.t[f])]
		end
		d = d..encoding.int.b
	end

	d = string_left (d, #d-1)

	for d = 1, #encoding.ext do
		if encoding.ext[d][2] == d then
			return pq.createstring (a, b, c)
		end
	end

	encoding.ext[c and d or a] = c and a or d
end
pq.createconversion = function(a, b)
	math_randomseed (a:GetKey ())

	local c = string_explode ("", encoding.int.m)

	for d = 1, #c do
		pq.createstring (c[d], math_random (encoding.int.l[1], encoding.int.l[2]), b)
	end
end

pq.encode = function (a)
	if not a:GetString () or a:GetString () == "" then a:SetString(":(") return a end

	local b = string_explode ("", a:GetString ())

	if not a:GetKey () then
		math_randomseed (os_time())
		a:SetKey        (math_random (0, 2^1023))
	end

	pq.createconversion (a, false)

	for c = 1, #b do
		b[c] = encoding.ext[b[c]]
	end

	a:SetString (string_implode (encoding.int.d, b))
	return a
end
pq.decode = function (a)
	if not a:GetString () or a:GetString () == "" then a:SetString (":(") return a end
	if not a:GetKey    ()                         then a:SetString (":(") return a end

	local c = string_explode (encoding.int.d, a:GetString ())

	pq.createconversion(a, true)
	
	for e = 1, #c do
		c[e] = encoding.ext[c[e]]
	end

	a:SetString (string_implode ("", c))
	return a
end

pq.finish = function (a)
	local b = {a:GetString (), a:GetKey ()}
	a = nil
	return b
end

      _pq = _pq or pq.createobject ()
local _pq = _pq

function _pq:NewObfuscater (a, b)
	local c = pq.createobject (a or {string = "", key = false}, b)

	function c:GetString ( ) return self.string end
	function c:GetKey    ( ) return self.key    end
	function c:SetString (a) self.string = a    end
	function c:SetKey    (a) self.key    = a    end

	function c:Push   (a) return pq.push   (self, a) end
	function c:Key    (a) return pq.key    (self, a) end
	function c:Encode ( ) return pq.encode (self   ) end
	function c:Decode ( ) return pq.decode (self   ) end
	function c:Finish ( ) return pq.finish (self   ) end

	return c
end
