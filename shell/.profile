# Added by Toolbox App
export PATH="$PATH:/home/zinis/.local/share/JetBrains/Toolbox/scripts"

# vscode slow delete operation fix
export ELECTRON_TRASH=gio

# openJDK 11
# export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
# export JDK_HOME=${JAVA_HOME}

# flutter depends on (android command line tools) for android builds
# export PATH="$PATH:/home/zinis/.local/override/flutter/bin"

# local bin
export PATH="$PATH:$HOME/.local/bin:$HOME/.npm-global/bin"
. "$HOME/.cargo/env"

export QT_QPA_PLATFORMTHEME="qt5ct"

export SSL_CERT_DIR=$HOME/.aspnet/dev-certs/trust:/usr/lib/ssl/certs
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
