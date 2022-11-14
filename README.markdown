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

