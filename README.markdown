# DictVis.jl

A simple interface for visualizing model parameters.

Model parameters are often vectors or matrices located in the leaves
of tree-like data structures.
The trees themselves are usually made of nested dictionary-like data structures.

We provide simple functions for finding all of the
parameters in such a tree, and generating a simple interactive visualization for them.
We rely on [Plotly](https://plotly.com/julia/) to do this.

The visualizations are intended for fast and convenient use during model prototyping.
We do not recommend using them in publications.

The most important functions are:

* `generate_html`; and
* `generate_plot`

By default "dictionary-like data structures" include
* `AbstractDict`
* `NamedTuple`
* `Tuple`

You can add new "dict-like" types via the `@traversable` macro.
E.g., `@traversable HDF5.File` would make an HDF5 file traversable for plotting.

By default the "plottable leaf" types include
* `AbstractVector{<:Real}`
* `AbstractMatrix{<:Real}`

You can add new "plottable leaf" types via the `@plottable` macro.
E.g., `@traversable HDF5.Dataset` would make an HDF5 dataset plottable.

You would also need to implement a `leaf_trace(leaf::HDF5.Dataset)` method
that defines how a Plotly trace is generated from the new leaf type.
See `src/traces.jl` for examples.
 
