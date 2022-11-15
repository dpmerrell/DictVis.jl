
using DictVis, Test

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
        @test true
    end 
    
end


function main()
    basic_tests()
end

main()

