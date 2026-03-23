class AppStrings {
  // App Info
  static const String appName = 'StyleAI';
  static const String appSlogan = '你的智能穿搭顾问';

  // Navigation
  static const String wardrobe = '衣橱';
  static const String outfit = '穿搭';
  static const String profile = '我的';

  // Wardrobe
  static const String addItem = '添加衣物';
  static const String editItem = '编辑衣物';
  static const String deleteItem = '删除衣物';
  static const String emptyWardrobe = '还没有添加任何衣物\n点击下方按钮添加第一件吧';
  static const String itemName = '名称';
  static const String category = '分类';
  static const String color = '颜色';
  static const String brand = '品牌';
  static const String season = '季节';
  static const String occasion = '场合';

  // Categories
  static const List<String> categories = [
    '全部',
    '上衣',
    '裤子',
    '裙子',
    '外套',
    '配饰',
    '鞋',
    '包',
    '首饰',
    '口红',
  ];

  // Seasons
  static const List<String> seasons = ['春', '夏', '秋', '冬'];

  // Occasions
  static const List<String> occasions = [
    '通勤',
    '约会',
    '面试',
    '运动',
    '逛街',
    '居家',
    '旅行',
    '聚会',
  ];

  // Styles
  static const List<String> styles = [
    '简约',
    '甜美',
    '酷帅',
    '韩系',
    '法式',
    '复古',
    '运动',
    '优雅',
  ];

  // Outfit
  static const String todayOutfit = '今日穿搭';
  static const String startOutfit = '开始搭配';
  static const String selectScene = '选择场景';
  static const String selectStyle = '选择风格';
  static const String selectNeeds = '特殊需求';
  static const String recommend = '推荐';
  static const String favorite = '收藏';
  static const String retry = '重试';
  static const String noFavorite = '还没有收藏的穿搭';

  // Profile
  static const String styleTest = '风格测试';
  static const String bodyData = '身材数据';
  static const String preferences = '喜好设置';
  static const String help = '使用帮助';
  static const String settings = '设置';

  // Weather
  static const String weather = '天气';
  static const String location = '获取位置中...';

  // Actions
  static const String save = '保存';
  static const String cancel = '取消';
  static const String confirm = '确认';
  static const String delete = '删除';
  static const String edit = '编辑';
  static const String done = '完成';
  static const String next = '下一步';
  static const String skip = '跳过';

  // Camera
  static const String takePhoto = '拍照';
  static const String fromAlbum = '从相册选择';
  static const String analyzing = 'AI分析中...';

  // Style Test
  static const String startStyleTest = '开始风格测试';
  static const String styleTestTitle = '发现你的穿搭风格';
  static const String styleTestDesc = '回答几个问题，了解你的风格偏好';

  // Errors
  static const String networkError = '网络连接失败，请检查网络';
  static const String unknownError = '出错了，请稍后重试';
  static const String cameraError = '无法访问相机';
}
