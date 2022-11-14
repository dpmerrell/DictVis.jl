

# Default trace generation for vectors and matrices
# of real numbers.
#
# This can be viewed as example usage of `@plottable`
# and `leaf_trace` when extending the module to new types.


@plottable AbstractVector{<:Real}
function leaf_trace(leaf::AbstractVector{<:Real})

    trace = scatter(y=leaf[:])
    return trace
end

@plottable AbstractMatrix{<:Real}
function leaf_trace(leaf::AbstractMatrix{<:Real})

    trace = heatmap(z=leaf[:,:], type="heatmap", colorscale="Greys", reversescale=true)
    return trace
end


