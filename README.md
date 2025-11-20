pip install conan
make rebuild
make run      # gera out.svg
make view     # abre o gráfico

PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig make init
PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig make config
PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig make build
