
# Default trace generation for vectors and matrices
# of real numbers.
#
# This can be viewed as example usage of `@plottable`
# and `leaf_trace` when extending the module to new types.


@plottable AbstractVector{<:Real}
function leaf_trace(leaf::AbstractVector{<:Real})
    trace = scatter(y=float.(leaf))
    return trace
end

MAX_HEATMAP_SIZE = 10000


@plottable AbstractMatrix{<:Real}
function leaf_trace(leaf::AbstractMatrix{<:Real})

    M, N = size(leaf)
    total_size = M*N

    if total_size > MAX_HEATMAP_SIZE
        shrinkage = ceil(sqrt(total_size/MAX_HEATMAP_SIZE))
        leaf = downsample(leaf, shrinkage)
    end

    trace = heatmap(z=float.(leaf), type="heatmap", colorscale="Greys", reversescale=true)
    return trace
end


