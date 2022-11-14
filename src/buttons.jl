

function leaf_button(leaf::AbstractVector{<:Real}, leaf_idx, n_leaves, prefix)

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


function leaf_button(leaf::AbstractMatrix{<:Real}, leaf_idx, n_leaves, prefix)
    
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
