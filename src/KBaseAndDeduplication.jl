module KBaseAndDeduplication

using Flux
using Mill
using HierarchicalUtils
using ChainRulesCore
using Setfield
using MLUtils

include("knowledge_base/kb.jl")#relational
include("knowledge_base/kb_model.jl")
export KBEntry, KnowledgeBase, append, atoms, KnowledgeModel

include("deduplication/deduplication.jl")
include("deduplication/dedu_matrix.jl")
export DeduplicatedMatrix, DeduplicatingNode, deduplicate, find_duplicates

MLUtils.batch(xs::AbstractVector{<:AbstractMillNode}) = reduce(catobs, xs)

end # module
