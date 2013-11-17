iosFontOutput
=============

a simply code snip for output all font in ios

我是看了唐巧的博客：[动态下载苹果提供的多种中文字体](http://blog.devtang.com/blog/2013/08/11/ios-asian-font-download-introduction/)才写了这个例子

1. 先在mac里的字体册里找想使用的字体
2. 然后在字体册里查看该字体的PostScript
3. [点此](http://support.apple.com/kb/HT5878?viewlocale=zh_CN)（这个页面里有ios5，ios6系统对字体的支持情况链接，就在稍下面的点的地方）查看ios7系统是否支持该字体，
4. 支持的话就参考NetFontViewController中的实现去下载吧。


NetFontViewController是来源于官方的例子，

![image](http://c.hiphotos.bdimg.com/album/s%3D1600%3Bq%3D90/sign=98dbd4dbd5ca7bcb797bc3298e395012/9e3df8dcd100baa127c4aaa34510b912c8fc2e3a.jpg)

