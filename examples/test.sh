#!/bin/sh

set -e
set -x

./alpha_gradation.rb
./binarization.rb
./enlarge.rb
./gradation.rb
./highcontrast.rb
./overlay.rb
./raw2gray.rb
./raw2png.rb
./shrink.rb
./tinypng.rb
