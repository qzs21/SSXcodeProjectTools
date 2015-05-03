# SSXcodeProjectTools
Xcode project tools for libs.

### 功能
* 加速`CocoaPods`更新速度.

### 实现
* 自动安装`CocoaPods`, 自动配置淘宝源 <http://ruby.taobao.org/>
* pod引用本地缓存依赖库，加快依赖库更新

### Configure
* `$PODFILE_DIR/Frameworks.ini` to configuration the library dependencies cache.

eg.

```
[SSObject]
	url = https://github.com/qzs21/SSObject.git
[NSObject+extend]
	url = https://github.com/qzs21/NSObject_extend.git
```

### First Build
1. Open `Terminal`, `cd` to `Podfile` dir.
2. Run `sstools.sh -m init`
3. open `*.xcworkspace`, `command` + `R` (Build and run project.)

eg.

```
$ cd PODFILE_DIR
$ sstools.sh -m init
```


### Command Line Help
* `$ sstools.sh -m init` # Initialize library dependencies, initialization module will automatically check `CocoaPods` installation and configuration.
* `$ sstools.sh -m update` # Update library dependencies.
* `$ sstools.sh -h` # Help