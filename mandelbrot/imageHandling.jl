using ColorSchemes, Images, FileIO, QuartzImageIO, ImageMagick

function applyColormap(myArray, iter)
    imOutput = zeros(RGB{Float32}, size(myArray, 1), size(myArray, 2))
    for col = 1:size(myArray, 2)
        for row = 1:size(myArray, 1)
            imOutput[row, col] = get(ColorSchemes.vermeer, myArray[row, col] / iter)
        end
    end
    save("Colored.png", imOutput)
end

function saveGrey(myArray)
    img = colorview(Gray, myArray)
    save("Grey.png", img)
end