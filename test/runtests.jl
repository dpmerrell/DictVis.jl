
using DictVis, Test, HDF5

function basic_tests()

    d = Dict("cat" => [1,2,3,4,5],
             "dog" => (fish=randn(10,10),
                       bird="bird"),
             "lizard" => ["a", "b", "c"]
            )
    html_path = "basic_tests.html"

    @testset "Basic tests" begin

        # Just test that they run to completion
        p = generate_plot(d)
        @test true

        generate_html(d, html_path) 
        @test isfile(html_path)
        rm(html_path)
    end 
    
end

# Extend the API to HDF5 Files, Groups, and Datasets.
# Make HDF5 Files and Groups traversable
@traversable HDF5.File
@traversable HDF5.Group

# Make (some) Datasets plottable
function DictVis.is_plottable(x::HDF5.Dataset)
    return DictVis.is_plottable(getindex(x))
end
function DictVis.leaf_trace(x::HDF5.Dataset)
    return DictVis.leaf_trace(getindex(x))
end

function extension_tests()

    hdf_path = "test.hdf"
    html_path = "test_plot_hdf5.html"

    @testset "Extension test: HDF5" begin
        f = h5open(hdf_path, "r")
        # We'll just test that this runs to completion
        p = generate_html(f, html_path)
        @test isfile(html_path)
        
        rm(html_path)
    end 
    
end

mutable struct MyStruct2
    X::Vector{<:Real}
    y::Vector{Bool}
    name::String
end
@traversable_fields MyStruct2

mutable struct MyStruct
    X::Matrix{<:Real}
    name::String
    children::MyStruct2
end
@traversable_fields MyStruct


function traversable_fields_tests()

    ms2 = MyStruct2(randn(10), rand(Bool, 20), "mystruct2")
    ms1 = MyStruct(randn(10,10), "mystruct", ms2)

    html_path = "test_traversable_fields.html"

    @testset "Extension test: HDF5" begin

        # We'll just test that this runs to completion
        p = generate_html(ms1, html_path)
        @test isfile(html_path)
        rm(html_path)
    end 
    
end


function main()
    basic_tests()
    extension_tests()
    traversable_fields_tests()
end

main()

