Weixin-Mac
==========

**普通用户请到这里 http://ialaddin.github.io/Weixin-Mac/index.html**

开发者小伙伴继续阅读吧：

微信网页版本的Mac Native的封装和扩展

多写两句吧，关于这个App本身的目的并不是那么的远大和雄伟，停止开发的时间也不一定什么时候就停止了。这要看腾讯自己什么时候出Mac的App，或者它什么时候考虑把这个封了。这个App本身的难度基本上说是0吧，这样放出来只是为了方便有需要的人而已，一直是开源的，您有兴趣看代码，就明白多么简单和安全。

##代码分支管理

使用的是git-flow (http://nvie.com/posts/a-successful-git-branching-model)

所以最新的代码在develop上面，稳定代码在master上，发布在release上就很好理解了哈...

##依赖管理

使用 [Cocoapods](https://github.com/CocoaPods/CocoaPods)进行管理，
目前使用外部依赖有:

```
pod 'CocoaHTTPServer',	'~> 2.3'
pod 'MASShortcut',      '~> 1.2.2'
```

##开发环境需求

我的开发环境是

```
10.9 Mavericks
Xcode5-DP5
ruby 1.9.3
Cocoapods 0.24.0

```

1. fork this repo
2. `git clone https://github.com/iAladdin/Weixin-Mac.git;cd Weixin-Mac`
3. `git checkout develop`
4. `pods install`
5. `open Weixin.xcworkspace`

##感谢

我虽然增加了捐赠按钮，但本身目的不是为了通过这个进行盈利的，妄下定论的小伙伴们，还是点击下看看，当故事看也好。最后，感谢捐赠的各位。

捐赠感谢名单(按捐赠时间顺序,如果需要删除的小伙伴可以在捐赠的时候附加上匿名=D )

1. lixiarong
2. fengdahui
3. huangyan
4. wujinchuan
5. linli
6. zhangyongxiang
7. zhenghao
8. zhangxin
9. zhangjunya
10. zhangshaozhi
11. panzicong
12. wukaifeng
 
Latest:
September Early
http://ialaddin.github.io/Weixin-Mac/Weixin-September-Early.zip