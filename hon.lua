
local pq  = {}

local math_random     = math.random
local math_randomseed = math.randomseed
local string_left     = string.Left
local string_explode  = string.Explode
local string_implode  = string.Implode
local os_time         = os.time

pq.BaseT  = function () return {              } end
pq.BaseMT = function () return {__index = self} end

pq.createobject = function (a, b)
	a = a or pq.BaseT ()
	setmetatable (a, b or pq.BaseMT ())
	return a
end

pq.push = function (a, b) a.s = a.s..tostring (b) end
pq.key  = function (a, b) a.k = b                 end

local encoding = {}
encoding.int = {
	h = {"h", "H"}, o = {"o", "O"}, n   = {"n", "N"},
	b = "/",        d = "|",        hon = {6, 9},
	a = "`1234567890-=qwertyuiop[]\\asdfghjkl;'zxcvbnm,./~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?	 "
}
encoding.ext = {}

pq.createhon = function(a, b, c)
	local d = ""

	for e = 1, b do
		d = d                                 ..
			encoding.int.h[math_random (1, 2)]..
			encoding.int.o[math_random (1, 2)]..
			encoding.int.n[math_random (1, 2)]..
			encoding.int.b
	end

	d = string_left (d, #d-1)

	for d = 1, #encoding.ext do
		if encoding.ext[d][2] == d then
			return pq.createhon (a, b, c)
		end
	end

	encoding.ext[c and d or a] = c and a or d
end

pq.encode = function (a)
	if not a.s or a.s == "" then a.s = ":(" return end

	local b = string_explode ("", a.s)
	local c = string_explode ("", encoding.int.a)

	for d = 1, #b do
		local e = false
		for f = 1, #c do if b[d] == c[f] then e = true end end
		if not e then a.s = ":(" return end
	end

	if not a.k then
		math_randomseed   (os_time())
		a.k = math_random (0, 2^1023)
	end

	math_randomseed (a.k)

	for e = 1, #encoding.int.a do
		pq.createhon (c[e], math_random (encoding.int.hon[1], encoding.int.hon[2]))
	end
	for e = 1, #b do
		b[e] = encoding.ext[b[e]]
	end

	a.s = string_implode (encoding.int.d, b)
end
pq.decode = function (a)
	if not a.s or a.s == "" then a.s = ":(" return end
	if not a.k              then a.s = ":(" return end

	local c = string_explode (encoding.int.d, a.s)

	math_randomseed (a.k)

	for e = 1, #encoding.int.a do
		pq.createhon (encoding.int.a[e], math_random (encoding.int.hon[1], encoding.int.hon[2]), true)
	end
	for e = 1, #c do
		c[e] = encoding.ext[c[e]]
	end

	a.s = string_implode ("", c)
end

pq.finish = function (a)
	local b = {a.s, a.k}
	a = nil
	return b
end

hon = pq.createobject()

function hon:New (a)
	local b = pq.createobject ({s = "", k = false}, a)

	function b:Push   (a)        pq.push   (self, a) end
	function b:Key    (a)        pq.key    (self, a) end
	function b:Encode ( )        pq.encode (self   ) end
	function b:Decode ( )        pq.decode (self   ) end
	function b:Finish ( ) return pq.finish (self   ) end

	return b
end