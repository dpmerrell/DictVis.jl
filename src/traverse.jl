

export generate_plot


function rec_count_leaves(d)

    # Base case: this is a plottable leaf
    if has_leaf_type(d) 
        return 1
    end

    # Check whether this node
    # is dict-like
    ks = nothing
    try
        ks = keys(d)
    catch
        # This node is neither a plottable leaf
        # nor a dict-like interior node
        return 0
    end

    # Recursive case
    n = 0
    for k in sort(collect(ks))
        child = d[k]
        n += rec_count_leaves(child)
    end

    return n
end


"""
    Traverse a dictionary-like object via DFS
    and accumulate Plotly traces and buttons from
    the leaves.

    The "dictionary-like" object can be any struct
    that has a corresponding `keys` function.
"""
function generate_traces_buttons(d, leaf_idx, total_leaves; 
                                 traces=[], buttons=[], prefix="")

    # Base case -- this is a plottable leaf.
    # Increment leaf index; generate trace, button
    if has_leaf_type(d) 
        leaf_idx += 1

        new_trace = leaf_trace(d)
        push!(traces, new_trace)

        new_button = leaf_button(d, leaf_idx, total_leaves, prefix)
        push!(buttons, new_button)
        return leaf_idx
    end

    # Check whether this node is dict-like
    ks = nothing
    try
        ks = keys(d)
    catch
        # This node is neither a plottable leaf
        # nor a dict-like interior node
        return leaf_idx 
    end

    for k in sort(collect(ks))
        child = d[k]
        leaf_idx = generate_traces_buttons(child, leaf_idx, total_leaves;
                                           traces=traces,
                                           buttons=buttons,
                                           prefix=string(prefix,"/",k))

    end

    return leaf_idx
end


"""
    Given a dictionary-like object, generate a Plotly trace
    button for each plottable leaf. Then create a plot
    with a dropdown menu that allows each leaf to be viewed
    as desired. 
"""
function generate_plot(d)

    traces = GenericTrace[]
    buttons = []

    total_leaves = rec_count_leaves(d)

    generate_traces_buttons(d, 0, total_leaves;
                            traces=traces,
                            buttons=buttons,
                            prefix="")

    layout = Layout(
                 updatemenus=[
                     attr(
                         active=0,
                         buttons=buttons
                         )
                             ]
                   )
    
    p = plot(traces, layout)

    return p
end


