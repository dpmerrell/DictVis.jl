
using DictVis, Test

function basic_tests()

    d = Dict("cat" => [1,2,3,4,5],
             "dog" => (fish=randn(10,10),
                       bird="bird"),
             "lizard" => ["a", "b", "c"]
            )
    html_path = "basic_tests.html"

    @testset "Dictionary tests" begin

        p = generate_plot(d)
        generate_html(d, html_path) 

        @test true
    end 
    
end


function main()
    basic_tests()
end

main()

