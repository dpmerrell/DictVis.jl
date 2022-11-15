

export generate_plot, @traversable, @traversable_fields


##############################################
# Keep track of which types count as 
# traversable (dictionary-like) structures.
##############################################

is_traversable(x) = false

"""
    traversable(t)

    Indicate that type `t` counts as an
    internal node for DictVis. I.e., it is
    dictionary-like and may have plottable descendants.
"""
macro traversable(t)
    return :(is_traversable(x::$(esc(t))) = true) 
end

# Make some important types traversable by default
@traversable AbstractDict
@traversable NamedTuple
@traversable Tuple


################################################
# Provide a convenience macro for 
# making arbitrary structs traversable
################################################

"""
    traversable_fields(t)

    Given the type `t` for an arbitrary struct,
    define the necessary interface for making it
    traversable like a dictionary.

    A convenience macro that defines the functions 
    `is_traversable(::t)`,
    `keys(::t)`, and `getindex(::t)`
    for type `t`, under the assumption that the `t`'s 
    fieldnames serve as keys and fields serve as values.

    This is of practical interest since models are
    often represented as (possibly nested) Julia structs.
"""
macro traversable_fields(t)

    code = quote
        function Base.keys(d::$(esc(t)))
            return collect(fieldnames($(esc(t))))
        end
        function Base.getindex(d::$(esc(t)), k)
            return getfield(d, k)
        end
        function DictVis.is_traversable(d::$(esc(t)))
            return true
        end
    end

    return code
end

#####################################################
# Traverse & operate on the leaves of the tree via DFS
##################################################### 

function rec_count_leaves(d)

    # Base case: this is a plottable leaf
    if is_plottable(d) 
        return 1
    end

    # Check whether this node is traversable
    ks = nothing
    if is_traversable(d)
        ks = keys(d)
    else
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
    if is_plottable(d) 
        leaf_idx += 1

        new_trace = leaf_trace(d)
        push!(traces, new_trace)

        new_button = leaf_button(d, leaf_idx, total_leaves, prefix)
        push!(buttons, new_button)
        return leaf_idx
    end

    # Check whether this node is dict-like
    ks = nothing
    if is_traversable(d)
        ks = keys(d)
    else
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
                         active=-1,
                         buttons=buttons
                         )
                             ]
                   )
    
    p = plot(traces, layout)

    return p
end


