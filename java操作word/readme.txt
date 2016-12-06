使用方式
①下载Jacob.jar（有64位有32位自己分清楚）、java2word.jar两个，我下载的Jacob.jar是jacob-1.17-M2.rar版本，这个里面有64位的也有32位的
②解压 jacob-1.17-M2.rar后，将Jacob.jar添加至项目的lib目录下，将jacob-1.17-M2-x64.dll分别复制到jdk的bin目录、jre的bin目录，以及Windows\SysWoW64目录下（如果是32位的就应该是WINDOWS\SYSTEM32目录下）
③找个测试类试下，网上比较靠谱的也就是（GF_JacobUtil）http://hoopy1987.iteye.com/blog/1545601 
④网上自己找个转义工具（class转java）将 java2word.jar中的Document、StyleWarning、TableStyleWarning三个类复制出来，粘贴到项目中的工具包中
⑤接下来就是根据你自己的需求到 java2word.jar包中documentation包（解压java2word.jar后有个com文件夹，点进去下移级目录中就有）中看中文帮助文档，里面有各种的案例 

java2word的组成十分的简单：
①com.heavenlake.wordapi包中作者自己封装了一个Document工具类
②com.heavenlake.wordapi包中两个自定义继承于Exception异常类(StyleWarning,TableStyleWarning)
③documentation包中的是开发帮助文档，包括案例
④com.jacob包下面都是Jacob.jar的源码