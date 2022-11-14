
export generate_html

function generate_html(d, html_path::AbstractString; kwargs...)
    p = generate_plot(d)

    open(html_path, "w") do io
        PlotlyBase.to_html(io, p.plot; kwargs...)
    end
end


