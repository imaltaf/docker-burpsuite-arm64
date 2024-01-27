#!/usr/bin/env bash
set -ex

# Set the Java executable path
java_path="/opt/openjdk-18/bin/java"

# Burp Suite JAR and loader path
burp_jar_path="/burpsuite/burpsuite_pro.jar"
loader_path="/burpsuite/burploader.jar"
burploader_agent="-javaagent:$loader_path"

# Run Burp Suite
$java_path \
  "--add-opens=java.desktop/javax.swing=ALL-UNNAMED" \
  "--add-opens=java.base/java.lang=ALL-UNNAMED" \
  "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED" \
  "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED" \
  "--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED" \
  "$burploader_agent" \
  "-noverify" \
  "-jar" \
  "$burp_jar_path"
