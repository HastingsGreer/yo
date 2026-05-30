
# builtins specified by the compiler.
primitive type MyRef{T} 64 end
primitive type MyInt64 64 end

struct Nil{T}
end

function MyInt64(x::Union{Int64, UInt64}) 
	reinterpret(MyInt64, x)
end
M = MyInt64(1)
Base.:*(a::Union{Int64, UInt64}, b::MyInt64)::MyInt64 = MyInt64(a * reinterpret(Int64, b))
add(a::MyInt64, b::MyInt64)::MyInt64 = MyInt64(reinterpret(Int64, a) + reinterpret(Int64, b))
sub(a::MyInt64, b::MyInt64)::MyInt64 = MyInt64(reinterpret(Int64, a) - reinterpret(Int64, b))


function MyRef(c::Ptr{T}) where T 
	reinterpret(MyRef{T}, c)
end

function MyRef{T}() where T
	return reinterpret(MyRef{T}, 0)
end

function heapify(val::T)::MyRef{T} where T
	ret = reinterpret(Ptr{T}, Base.Libc.malloc(sizeof(val)))
	unsafe_store!(ret, val)
	return MyRef(ret)
end

function read(loc::MyRef{T})::T where T
	return unsafe_load(reinterpret(Ptr{T}, loc))
end

function isnil(e::MyRef{T})::Bool where T
	return reinterpret(Int64, e) == 0
end

#end builtins
#from here, no builtin types


# prelude (nasty types, but written in language)

struct List{T} 
    car :: T
    cdr :: MyRef{List{T}}
end

function List(e::T, l::List{T}) where T
	return List(e, heapify(l))
end

function cons(e::T, l::List{T}) where T
    return List(e, l)
end

function cons(e::T, l::Nil{T}) where T
	return List(e, MyRef{List{T}}())
end

function sing(e::T) where T
	return List(e, MyRef{List{T}}())
end

# user code

val = MyInt64(0 + 0x00deadbeef)

read(heapify(val))


cons(val, Nil{MyInt64}())



function range(N)
	if N == 0M
		return sing(N)
	else 
		return cons(N, range(sub(N, 1M)))
	end
end

function show(x) 
	print(x, " ")
end


function show(l::List{T}) where T
	
	show(l.car)
	if !isnil(l.cdr)
		show(read(l.cdr))
	end
end

function map(f::F, l::List{T}) where F where T
	if isnil(l.cdr)
	    return sing(call(f, l.car))
	else
		return cons(call(f, l.car), map(f, read(l.cdr)))
	end
end

show(range(12M))

struct Double end

call(::Double, x) = add(x, x)

map(Double(), range(12M))

function broadcast(f::F, a::T, b::U) where F where T where U
	call(f, a, b)
end
function broadcast(f::F, a::List{T}, b::U) where F where T where U
	if isnil(a.cdr)
	    return sing(call(f, a.car, b))
	else
		return cons(call(f, a.car, b), broadcast(f, read(a.cdr), b))
	end
end
function broadcast(f::F, b::U, a::List{T}) where F where T where U
	if isnil(a.cdr)
	    return sing(call(f, b, a.car))
	else
		return cons(call(f, b, a.car), broadcast(f, b, read(a.cdr)))
	end
end
function broadcast(f::F, a::List{T}, b::List{U}) where F where T where U
	if isnil(a.cdr)
	    if isnil(b.cdr)
	        return sing(broadcast(f, a.car, b.car))
	    else
		return cons(broadcast(f, a.car, b.car), broadcast(f, a, read(b.cdr)))

	    end
	else
	    if isnil(b.cdr)
		    return cons(broadcast(f, a.car, b.car), broadcast(f, read(a.cdr), b))
	    else
		return cons(broadcast(f, a.car, b.car), broadcast(f, read(a.cdr), read(b.cdr)))
	end
	end
end

struct Add end

call(::Add, a, b) = add(a, b)

struct Sing end
call(::Sing, x) = sing(x)

function pair(a, b)
	return cons(a, sing(b))
end
struct Pair end
call(::Pair, a, b) = pair(a, b)

struct Show end
call(::Show, x) = show(x)

struct Print end
call(::Print, x) = print(x, " ")

two_arr = broadcast(Pair(), sing( range(10M)), range(10M))

show(two_arr)


