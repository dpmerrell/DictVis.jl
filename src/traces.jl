

has_leaf_type(x) = false


function leaf_trace(leaf::AbstractVector{<:Real})

    trace = scatter(y=leaf[:])
    return trace
end
has_leaf_type(v::AbstractVector{<:Real}) = true


function leaf_trace(leaf::AbstractMatrix{<:Real})

    trace = heatmap(z=leaf[:,:], type="heatmap", colorscale="Greys", reversescale=true)
    return trace
end
has_leaf_type(v::AbstractMatrix{<:Real}) = true


