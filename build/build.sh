#!/bin/bash
if [ -z "$FLEXPATH" ]; then
  echo "Usage FLEXPATH=/path/to/flex/sdk sh ./build.sh"
  exit
fi

OPT_DEBUG="-use-network=false \
    -compiler.debug \
    -library-path+=../lib/blooddy_crypto.swc \
    -define=CONFIG::LOGGING,true \
    -define=CONFIG::FLASH_11_1,true"

OPT_RELEASE="-use-network=false \
    -optimize=true \
    -library-path+=../lib/blooddy_crypto.swc \
    -define=CONFIG::LOGGING,false \
    -define=CONFIG::FLASH_11_1,true"

OPT_DEBUG_10_1="-use-network=false \
    -optimize=true \
    -library-path+=../lib/blooddy_crypto.swc \
    -define=CONFIG::LOGGING,true \
    -define=CONFIG::FLASH_11_1,false"

OPT_RELEASE_10_1="-use-network=false \
    -library-path+=../lib/blooddy_crypto.swc \
    -optimize=true \
    -define=CONFIG::LOGGING,false \
    -define=CONFIG::FLASH_11_1,false"

echo "Compiling bin/debug/flashls.swc"
$FLEXPATH/bin/compc \
    $OPT_DEBUG_10_1 \
    -include-sources ../src/org/mangui/hls \
    -output ../bin/debug/flashls.swc \
    -target-player="10.1"

# echo "Compiling bin/release/flashls.swc"
# $FLEXPATH/bin/compc \
#     $OPT_RELEASE_10_1 \
#     -include-sources ../src/org/mangui/hls \
#     -output ../bin/release/flashls.swc \
#     -target-player="10.1"
