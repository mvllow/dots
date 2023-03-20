# @usage
# dither image.png
# dither image.png -colorspace gray
function dither -w convert -d "Dither image"
    convert $image \
        -quantize transparent \
        -format GIF \
        -interlace GIF \
        -resize 640\> \
        -ordered-dither 8x8 \
        $argv \
        -set filename:f "%[t]-dither" "%[filename:f].gif"
end
