# IOS_OC_BASIC
pod 'IOS_OC_BASIC'


使用注意：
1. containerApp需要定义   
   * prefixHeader中  #define IOS_MAIN_CONTAINER_FLAG
   * 或者 build settings 中 preproccessor Macros 中增加 IOS_MAIN_CONTAINER_FLAG
2. pod :
   * pod 'AFNetworking', '~> 3.0'
   * pod 'RealReachability'
   * pod 'Masonry'
   * pod 'MJRefresh'
