# Claude Relay Service

模型价格和上下文窗口配置服务。

## 文件说明

### 模型价格配置文件

- `model_prices_and_context_window.json` - 主要的模型价格配置文件
- `xmo_model_prices_and_context_window.json` - 扩展模型价格配置文件
- `*.sha256` - 对应 JSON 文件的 SHA256 校验和文件

### 工具脚本

- `generate_sha256.sh` - 自动为目录下所有 JSON 文件生成 SHA256 校验和

## 价格配置说明

### 汇率设置

所有模型的价格配置统一使用 **美元（USD）** 作为基础货币单位。

对于非美元定价的模型（如智谱 AI 的 GLM 系列使用人民币定价），需要按照以下汇率标准进行转换：

#### 汇率转换标准

```
人民币 (CNY) → 美元 (USD)
汇率: 8:1
即 ¥1 = $0.125
```

#### 价格转换示例

以智谱 AI GLM-4.6 模型为例：

| 项目 | 官方价格(CNY) | 转换价格(USD) | 配置值 (per token) |
|-----|-------------|--------------|-------------------|
| 输入价格 | ¥2/1M tokens | $0.25/1M | `2.5e-07` |
| 输出价格 | ¥8/1M tokens | $1/1M | `1e-06` |
| 缓存价格 | ¥0.4/1M tokens | $0.05/1M | `5e-08` |

#### 转换公式

```
USD价格 = CNY价格 ÷ 8
配置值 (per token) = USD价格 ÷ 1,000,000
```

例如：
- 官方价格：¥2/百万 tokens
- 转换为美元：¥2 ÷ 8 = $0.25/百万 tokens
- 配置值：$0.25 ÷ 1,000,000 = 2.5e-07 per token

### 价格配置格式

#### 简单定价

```json
{
  "model-name": {
    "input_cost_per_token": 1e-06,
    "output_cost_per_token": 3e-06,
    "cache_read_input_token_cost": 1e-07,
    ...
  }
}
```

#### 分层定价 (Tiered Pricing)

用于根据输入/输出长度区间采用不同价格的模型：

```json
{
  "model-name": {
    "tiered_pricing": [
      {
        "input_cost_per_token": 2.5e-07,
        "output_cost_per_token": 1e-06,
        "cache_read_input_token_cost": 5e-08,
        "range": [0, 32000.0],
        "output_range": [0, 200.0]
      },
      {
        "input_cost_per_token": 3.75e-07,
        "output_cost_per_token": 1.75e-06,
        "cache_read_input_token_cost": 7.5e-08,
        "range": [0, 32000.0],
        "output_range": [200.0, null]
      }
    ]
  }
}
```

### 支持的模型提供商

当前配置包含以下提供商的模型：

- **Anthropic** - Claude 系列 (USD)
- **OpenAI** - GPT 系列 (USD)
- **Moonshot AI** - Kimi 系列 (USD)
- **阿里云/DashScope** - Qwen 系列 (CNY → USD)
- **智谱 AI/ZhipuAI** - GLM 系列 (CNY → USD)
- **DeepSeek** - DeepSeek 系列 (USD)
- 以及其他多个模型提供商...

## 使用 SHA256 工具

生成所有 JSON 文件的 SHA256 校验和：

```bash
# 为当前目录的所有 JSON 文件生成 .sha256 文件
./generate_sha256.sh

# 为指定目录的所有 JSON 文件生成 .sha256 文件
./generate_sha256.sh /path/to/directory
```

生成的 `.sha256` 文件可用于验证 JSON 文件的完整性和一致性。

## 验证 JSON 格式

使用 Python 验证 JSON 文件格式：

```bash
python3 -m json.tool model_prices_and_context_window.json > /dev/null && echo "✅ JSON 格式正确"
```

## 贡献指南

### 添加新模型

1. 确认模型的官方定价信息
2. 如果是非美元定价，按照汇率标准转换为美元
3. 在对应的 JSON 文件中按字母顺序添加模型配置
4. 验证 JSON 格式
5. 运行 `generate_sha256.sh` 更新校验和

### 更新模型价格

1. 确认新的官方定价
2. 按汇率标准转换（如需要）
3. 更新配置文件
4. 验证 JSON 格式
5. 更新 SHA256 校验和

## 注意事项

⚠️ **重要提醒**

1. **价格单位统一**：所有价格必须使用美元（USD）配置
2. **汇率一致性**：所有人民币转换必须使用 8:1 的固定汇率
3. **精度要求**：价格配置使用科学计数法（如 `2.5e-07`）确保精度
4. **JSON 格式**：提交前务必验证 JSON 格式正确性
5. **校验和更新**：修改 JSON 文件后必须重新生成 SHA256 校验和

## License

请查看项目许可证文件。
