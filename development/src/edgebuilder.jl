
function _start_ends(edges, num_vertices)
	id = edges[1]
	bounds = Vector{UnitRange{Int}}(undef, num_vertices)
	# fill empty when edges do not start by one
	fill!(view(bounds, 1:id-1), 0:-1)
	# fill the bulk
	start = 1
	for (stop, vid) in enumerate(edges)
		id > vid && error("the input sequence should be sorted")
		id == vid && continue # no change
		bounds[id] = start:(stop-1)
		id += 1
		while id < vid
			bounds[id] = 0:-1
			id += 1
		end
		start = stop
	end

	# add the unfinished edge 
	bounds[id] = start:length(edges)
	id +=1

	#add empty to the end
	fill!(view(bounds, id:num_vertices), 0:-1)
	bounds
end


function build_edge(src, dst, num_vertices, sid, did)
	ii = sortperm(src);
	src, dst = src[ii], dst[ii]
	BagNode(
		ProductNode((KBEntry(sid, src), KBEntry(did, dst))),
		CompressedBags(collect(1:length(src)), _start_ends(src, num_vertices), num_vertices)
	)
end


function add_messagepass(kb, edge_info)
	actor_id = filter(s -> contains("$(s)", "actor"), keys(kb))[end]
	movie_id = filter(s -> contains("$(s)", "movie"), keys(kb))[end]
	director_id = filter(s -> contains("$(s)", "director"), keys(kb))[end]
	n = length(keys(kb)) ÷ 3 + 1

	
	kb = append(kb, Symbol("actor_", n), build_edge(edge_info[:actor_to_movie]..., actor_id, movie_id))
	kb = append(kb, Symbol("director_", n), build_edge(edge_info[:director_to_movie]..., director_id, movie_id))
	kb = append(kb, Symbol("movie_", n),
	ProductNode((;movie_to_actor =  build_edge(edge_info[:movie_to_actor]..., movie_id, actor_id),
				movie_to_director = build_edge(edge_info[:movie_to_director]..., movie_id, director_id),
			)))
	kb
end


"""
@testset "_start_ends" begin
	edges = [1,1,1,2,2,2,3,4,4,4,7,8,8]
	@test _start_ends(edges, 8) == [1:3,4:6,7:7,8:10,0:-1,0:-1,11:11,12:13]
	@test _start_ends(edges, 10) == [1:3,4:6,7:7,8:10,0:-1,0:-1,11:11,12:13, 0:-1,0:-1]
	edges = [2,2,2,2,2,2,3,4,4,4,7,8,8]
	@test _start_ends(edges, 8) == [0:-1,1:6,7:7,8:10,0:-1,0:-1,11:11,12:13]
	@test _start_ends(edges, 10) == [0:-1,1:6,7:7,8:10,0:-1,0:-1,11:11,12:13, 0:-1, 0:-1]
end
"""


