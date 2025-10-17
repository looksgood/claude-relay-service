#!/bin/bash

# 脚本：生成目录下所有 JSON 文件的 SHA256 校验和文件
# 用法：./generate_sha256.sh [目录路径]
# 如果不指定目录，默认使用当前目录

# 设置目录，如果没有参数则使用当前目录
DIR="${1:-.}"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}开始为目录 '$DIR' 中的 JSON 文件生成 SHA256 校验和...${NC}"
echo ""

# 计数器
count=0

# 查找所有 .json 文件
find "$DIR" -maxdepth 1 -type f -name "*.json" | while read -r json_file; do
    # 获取文件名（不含路径）
    filename=$(basename "$json_file")

    # 生成 .sha256 文件名
    sha256_file="${json_file%.json}.sha256"

    # 计算 SHA256
    sha256_value=$(shasum -a 256 "$json_file" | awk '{print $1}')

    # 写入 .sha256 文件
    echo "$sha256_value" > "$sha256_file"

    # 输出信息
    echo -e "${GREEN}✓${NC} $filename"
    echo "  SHA256: $sha256_value"
    echo "  输出文件: $(basename "$sha256_file")"
    echo ""

    ((count++))
done

echo -e "${BLUE}完成！共处理 $count 个 JSON 文件。${NC}"
