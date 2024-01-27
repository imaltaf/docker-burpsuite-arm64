#!/usr/bin/env bash
set -ex

# Install Java 18
apt-get update
apt-get install -y wget
wget https://download.oracle.com/java/18/archive/jdk-18.0.2.1_linux-aarch64_bin.tar.gz -O /tmp/openjdk.tar.gz
mkdir -p /opt/openjdk-18
tar xzf /tmp/openjdk.tar.gz --directory /opt/openjdk-18 --strip-components=1
rm /tmp/openjdk.tar.gz

# Set environment variables for Java 18
export JAVA_HOME=/opt/openjdk-18
export PATH=$PATH:$JAVA_HOME/bin


# Desktop icon
cat <<EOF > $HOME/Desktop/burpsuite.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Burp Suite
Icon=/apps/burp_icon.png
Exec=/burpsuite/run_burp.sh
Terminal=false
Categories=Security;
EOF

chmod +x $HOME/Desktop/burpsuite.desktop
chown 1000:1000 $HOME/Desktop/burpsuite.desktop

# Cleanup for the app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
fi
