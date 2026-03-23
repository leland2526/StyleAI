# StyleAI - 智能穿搭助手

基于AI的个人衣橱管理和穿搭推荐应用。

## 功能特性

- 📸 **智能衣橱管理** - 拍照添加、AI自动识别分类
- 🎨 **个性化风格测试** - 发现你的穿搭风格
- 🤖 **AI穿搭推荐** - 根据场合、天气智能推荐搭配
- ❤️ **收藏管理** - 保存喜欢的穿搭方案
- 🌤️ **天气集成** - 自动获取当地天气

## 技术栈

- **框架**: Flutter 3.x
- **状态管理**: flutter_bloc (Cubit)
- **本地存储**: Hive
- **路由**: go_router
- **依赖注入**: get_it
- **AI服务**: OpenAI GPT-4 Vision (可选)

## 项目结构

```
lib/
├── core/               # 核心配置
│   ├── constants/      # 常量定义
│   └── di/            # 依赖注入
├── data/               # 数据层
│   ├── models/        # 数据模型
│   └── repositories/  # 数据仓库
├── presentation/       # 表现层
│   ├── bloc/          # 状态管理
│   ├── pages/         # 页面
│   └── widgets/       # 组件
└── services/          # 服务层
```

## 开始开发

### 环境要求

- Flutter SDK 3.0+
- Dart 3.0+

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
# Debug模式
flutter run

# Release模式
flutter run --release
```

### 构建

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## 配置说明

### 天气API (可选)

在 `.env` 或命令行中设置:

```bash
flutter run --dart-define=OPENWEATHER_API_KEY=your_api_key
```

### OpenAI API (可选，用于AI识别)

```bash
flutter run --dart-define=OPENAI_API_KEY=your_api_key
```

## License

MIT License
