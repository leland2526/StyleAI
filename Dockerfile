# StyleAI Flutter 开发环境

FROM cirrusci/flutter:stable

# 设置工作目录
WORKDIR /app

# 安装必要工具
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# 预配置 Flutter
RUN flutter config --no-analytics \
    && flutter config --enable-web \
    && flutter doctor

# 设置环境变量
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}"

# 暴露端口用于热重载
EXPOSE 8080

# 默认命令
CMD ["flutter", "doctor"]
