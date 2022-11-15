

function downsample(x::AbstractArray, shrinkage::Number)

    shrinkage = Int(round(shrinkage))

    shrunk = x[:,1:shrinkage:end]
    shrunk = shrunk[1:shrinkage:end, :]

    return shrunk 
end

