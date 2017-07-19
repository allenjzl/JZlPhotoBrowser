# JZlPhotoBrowser
简单的封装图片浏览器,一句代码调用,简单易用

1.封装图片浏览器,调用的时候直接把JZLPhotoBrowser文件夹拖入到自己的项目,导入头文件即可

2.#import "JZLPhotoBrowser.h"

3.一句代码调用,对于自己项目中的图片用collectionView做的,在点击的代理方法中调用代码,如果是直接创建的imageView,在imageView的点击事件中调用代码

```
[JZLPhotoBrowser showPhotoBrowserWithUrlArr:urlArr currentIndex:indexPath.row originalImageViewArr:self.frameArr];
```


4.注意点:

  1. demo中导入了三个第三方库,其中masonry是demo布局用到的,SDWebImage和JGPProgressHUD是图片浏览器用到的,如果自己的项目缺少这两个库,注意一下(SDWebImage肯定不会缺少,HUD可能每个人用的不一样,可以把我的替换掉,用自己项目中集成的HUD)
  
  2.如果保存图片崩掉的话注意看一下自己的项目相册权限有没有添加
  
  3.图片的缩放效果必须传入原imageView才会有,不然就只有默认的效果
  
  4.没有仔细的测试,如果发现bug请提出来,继续改进
  
  5.图片选择器还没写,后期继续完成
  
  6.如果能帮助到你,请star一下,给我动力继续努力
  
  5.特别感谢:
  框架参考了JLPhotoBrowser这个图片浏览器,参考了下大体的思路,然后自己又进一步的封装,然后增加了一些新的功能,谢谢!




