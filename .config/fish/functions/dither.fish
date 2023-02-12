# Dither image
# Inspired by https://flower.codes/2022/03/23/backwards-compatibility.html
#
# @usage
# dither image.png
# dither image.png -colorspace gray
function dither --wraps="convert"
    convert $image \
        -quantize transparent \
        -format GIF \
        -interlace GIF \
        -resize 640\> \
        -ordered-dither 8x8 \
        $argv \
        -set filename:f "%[t]-dither" "%[filename:f].gif"
end
