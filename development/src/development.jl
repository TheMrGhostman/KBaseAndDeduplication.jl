module development

using Mill, Flux, MLUtils
using KBaseAndDeduplication
using DataStructures

import Mill: BagNode

import Base: *, ==

using Base: AbstractVecOrMat, AbstractVecOrTuple
const VecOrRange{T} = Union{UnitRange{T},AbstractVector{T}}
const VecOrTupOrNTup{T} = Union{Vector{<:T},Tuple{Vararg{T}},NamedTuple{K,<:Tuple{Vararg{T}}} where K}
const Maybe{T} = Union{T,Missing}
const Optional{T} = Union{T,Nothing}

include("edgebuilder.jl")
export add_messagepass

include("compressed_bags.jl")
export CompressedBags

include("utils.jl")
export CompressedBagNode

greet() = print("Hello World!")

end # module development
