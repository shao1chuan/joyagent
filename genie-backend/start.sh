#!/usr/bin/env bash
set -e

BASEDIR="./target/genie-backend"
APP_JAR_NAME="genie-backend-0.0.1-SNAPSHOT.jar"   # 如名字不同请改
MAIN_CLASS="com.jd.genie.GenieApplication"
LOGFILE="./genie-backend_startup.log"

# 确保项目 jar 在 lib 目录（有些 assembly.xml 不会自动放）
if [ ! -f "$BASEDIR/lib/$APP_JAR_NAME" ] && [ -f "target/$APP_JAR_NAME" ]; then
  echo "copying project jar into lib..."
  cp "target/$APP_JAR_NAME" "$BASEDIR/lib/"
fi

# Windows 下（即便在 Git Bash 调用 java.exe）classpath 分隔符要用 ';'
# 同时把 conf 也放到 classpath 里（若 conf 下有额外 properties/yaml）
CLASSPATH="$BASEDIR/conf/;$BASEDIR/lib/*"

echo "starting :)"
# 如需后台常驻，取消注释 nohup 那行并在末尾加 &
# nohup java -Dfile.encoding=UTF-8 -Dbasedir="$BASEDIR" -cp "$CLASSPATH" "$MAIN_CLASS" > "$LOGFILE" 2>&1 &
java -Dfile.encoding=UTF-8 -Dbasedir="$BASEDIR" -cp "$CLASSPATH" "$MAIN_CLASS" > "$LOGFILE" 2>&1
