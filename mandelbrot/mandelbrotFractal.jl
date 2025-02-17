function fractal(x, y, iter::Int)
    # kernel 1
    c = complex(x, y)
    z = 0
    for i in 1:iter
        if abs(z) > 2
            return i
        end
        z = z * z + c
    end
    return 0
end

function pixel(k, iter, pixelsx::Tuple{Int64,Int64}, pixelsy, xoffset, yoffset, mySharedArray)
    # kernel 2 for single core
    for x in pixelsx[1]:pixelsx[end]
        for y in 1:pixelsy
            result = fractal((x - xoffset) / k, (y - yoffset) / k, iter)
            if result != 0
                mySharedArray[x, y] = cld(result, 1)
            end
        end
    end
end