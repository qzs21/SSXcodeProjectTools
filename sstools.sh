#!/bin/sh
# Xcode project Command line tools.

set -e

CURRENT_DIR="`pwd`"
PROJECT_FRAMEWORKS_DIR="$CURRENT_DIR/Frameworks"
PROJECT_FRAMEWORKS_INI_FILE="$CURRENT_DIR/Frameworks.ini"


# 检测环境
check_environment()
{
echo_string "Check Environment configure..."

# 检测依赖工具，自动安装
if [ ! -x `which gem` ] || [ -z `which gem` ]; then
echo_string "Can not found gem Plase Install Xcode and Xcode Command line tool."
exit 0
fi

if [ ! -x `which pod` ] || [ -z `which pod` ]; then
echo_string "Install cocoapods..."
sudo gem install cocoapods
echo_string "Install cocoapods done."
fi

# 自动配置gem源，使用淘宝gem源
GEM_SOURCES=`gem sources -l`
GEM_DEFAULT_SOURCE="https://rubygems.org/"
GEM_TAOBAO_SOURCE="http://ruby.taobao.org/"
[[ $GEM_SOURCES =~ $GEM_DEFAULT_SOURCE ]] && gem sources --remove $GEM_DEFAULT_SOURCE
[[ $GEM_SOURCES =~ $GEM_TAOBAO_SOURCE ]] || gem sources -a $GEM_TAOBAO_SOURCE

echo_string "Environment configure is OK."
}


# option submodules
opt_submodules()
{
while (($#!=0))
do
case $1 in
init)
init_submodules
exit 1
;;
update)
update_submodules
exit 1
;;
?)
usage
exit 1
;;
esac
shift
done
}

init_submodules()
{
check_environment
update_submodules
pod install --no-repo-update
echo_string "Init submodules all done."
}

update_submodules()
{
if [ ! -d $PROJECT_FRAMEWORKS_DIR ]; then
mkdir -p $PROJECT_FRAMEWORKS_DIR
fi
# 解析模块配置
F_URLS=`awk -F '=' '/\[*\]/{}{ if($1~/url/){print $2;} }' $PROJECT_FRAMEWORKS_INI_FILE`
for arg in $F_URLS
do
url=$arg
path=$PROJECT_FRAMEWORKS_DIR/`basename $arg .git`
if [ -d $path ]; then
echo_string "git `basename $arg .git` pull"
cd $path && git pull origin master && cd -
else
git clone $url $path
fi
done
pod install --no-repo-update
echo_string "Update submodules done."
}

echo_string()
{
echo "\033[32m$1\033[0m"
}

usage()
{
cat << EOF

usage: $0 [-m [init] [update] [remove]] [-h] [-help]

OPTIONS
-m       Init submodules
-h       Guess
-help    Guess

EOF
}

# Check Podfile
if [ ! -f "$CURRENT_DIR/Podfile" ]; then
echo_string "Can not find \"$CURRENT_DIR/Podfile\"."
exit 0
fi

while getopts "m:h'help'" OPTION
do
case $OPTION in
m)
opt_submodules $@
exit 1
;;
?)
usage
exit 1
;;
esac
done