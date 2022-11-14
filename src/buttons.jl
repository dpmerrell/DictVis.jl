
export @plottable

# The `is_plottable` function flags whether
# an object belongs to a visualizable leaf class. 

is_plottable(x) = false

# For every plottable type set `is_plottable` to true 
# for structs of that type. 
# Also define a function that generates a Plotly button for that struct. 

macro plottable(t)
    return :(is_plottable(leaf::$t) = true)
end

function leaf_button(leaf, leaf_idx, n_leaves, prefix)
    indicators = zeros(Bool, n_leaves)
    indicators[leaf_idx] = true
    return attr(label=prefix, method="update",
                args=[attr(visible=indicators),
                      attr(title=prefix,
                           annotations=[]
                          )
                     ]
               )
end

#function leaf_button(leaf::AbstractVector{<:Real}, leaf_idx, n_leaves, prefix)
#
#    indicators = zeros(Bool, n_leaves)
#    indicators[leaf_idx] = true
#
#    return attr(label=prefix, method="update",
#                args=[attr(visible=indicators),
#                      attr(title=prefix,
#                           annotations=[]
#                          )
#                     ]
#               )
#end
#
#
#function leaf_button(leaf::AbstractMatrix{<:Real}, leaf_idx, n_leaves, prefix)
#    
#    indicators = zeros(Bool, n_leaves)
#    indicators[leaf_idx] = true
#
#    return attr(label=prefix, method="update",
#                args=[attr(visible=indicators),
#                      attr(title=prefix,
#                           annotations=[]
#                          )
#                     ]
#               )
#
#end
