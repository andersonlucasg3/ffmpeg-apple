sh ./ffbuild/version.sh | Out-File ./libavutil/Sources/Public/ffversion.h

./configure --disable-nvenc --disable-vulkan --arch=aarch64

Copy-Item config.h ./libavutil/Sources/Public -Force
Move-Item ./libavutil/avconfig.h ./libavutil/Sources/Public -Force