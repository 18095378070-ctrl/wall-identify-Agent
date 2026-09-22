# AI 构件预审 Agent v3 模型切换实施报告

## 1. 实现摘要

- 在不修改特征、规则、护栏和工程师确认逻辑的前提下，新增服务端模型白名单。
- 网页默认选择 `DeepSeek V4 Flash`，可手动切换到 `DeepSeek V4 Pro`。
- 每个分析任务只固定使用一个模型；切换下拉框不会自动重新分析。
- 模型调用失败不会改用另一个模型，只允许读取所选模型自身的已验证缓存。
- 结果记录 `model_profile`、实际模型名以及 `live/cache/unavailable` 状态。
- 保留 32K 输出预算、600 秒超时、代理处理、原始响应留存和三态护栏。

## 2. 白名单与配置

服务端唯一允许的配置：

| Profile | 显示名称 | 实际模型 |
|---|---|---|
| `deepseek-v4-flash` | DeepSeek V4 Flash | `deepseek-v4-flash` |
| `deepseek-v4-pro` | DeepSeek V4 Pro | `deepseek-v4-pro` |

环境变量：

```text
WALLAGENT_API_BASE_URL=https://api.deepseek.com/chat/completions
WALLAGENT_API_KEY=服务端密钥
WALLAGENT_DEFAULT_MODEL_PROFILE=deepseek-v4-flash
WALLAGENT_ENABLED_MODEL_PROFILES=deepseek-v4-flash,deepseek-v4-pro
```

两个模型共用 `WALLAGENT_API_KEY`。旧 `WALLAGENT_MODEL` 在设置为上述已知模型时保留单模型兼容；新的 profile 配置优先。未知模型和停用模型不能由浏览器提交。

## 3. API 变更

- 新增 `GET /api/models`，只返回配置编号、显示名称、说明、启用状态和默认值。
- `POST /api/analyze` 接受可选 `model_profile`；省略时使用服务端默认 Flash。
- `api_key`、`base_url`、`model`、`provider` 继续被拒绝。
- `/api/status` 不再返回异常堆栈；供应商异常转换为稳定错误码和简短说明。
- 缓存键新增 `model_profile`，并继续包含 IFC SHA-256、墙编号、Prompt 版本、实际模型和批次号。

## 4. 密钥保护

- 密钥只从 Flask 服务端环境变量读取，不进入 HTML、JavaScript、公开 API、任务日志、缓存元数据、报告或 manifest。
- 浏览器只访问本项目相对路径接口，不直接请求 DeepSeek。
- 新增 `.env.example`，仅含占位符；`.env`、密钥文件、缓存、日志和运行输出被忽略并排除发布。
- Flask 继续使用 `debug=False` 和 `use_reloader=False`。
- Agent 不记录 Authorization 头，供应商原始错误内容不会返回浏览器或写入报告。
- 建议比赛结束后轮换密钥，并在供应商控制台设置额度和调用限制。

## 5. 测试与验收

命令：

```text
python -m compileall -q wall_agent
node --check wall_agent\web\static\app.js
python -X utf8 -m wall_agent.tests.test_engine
```

结果：Python 编译通过、JavaScript 语法通过、自动测试 **57/57 通过**。

新增覆盖包括：

- `/api/models` 默认值、白名单、禁用状态和信息最小化。
- 默认 Flash 与显式 Pro 的 OpenAI-compatible 请求体模型名。
- 未知、未启用配置拒绝，以及四类客户端配置注入拦截。
- Flash/Pro 缓存隔离，模型失败不跨模型切换，无自身缓存转人工复核。
- `llm-live`、`llm-cache`、`unavailable` 状态和结果模型字段。
- 前端无密钥输入框，无 localStorage、sessionStorage 或 Cookie 密钥持久化。
- 测试密钥递归扫描公开响应、日志、缓存、报告和静态文件为零匹配。
- 原有 IFC 上传、三态护栏、工程师确认、最终 IFC 和指标测试继续通过。

## 6. 联调结论

使用本地 mock OpenAI-compatible HTTP 服务完成联调：

- 未指定模型时请求体为 `deepseek-v4-flash`。
- 选择 Pro 时请求体只出现 `deepseek-v4-pro`。
- 两次任务均经过真实 HTTP 请求、Bearer 鉴权、证据校验和原始响应留存。
- 测试密钥未出现在公开响应或生成产物。

**本次仅完成 mock 联调，未完成真实 LLM 调用。** Mock 与缓存结果不作为真实 DeepSeek 效果证明。

## 7. 当前限制

- 真正的 DeepSeek 可用性、时延、配额和效果仍需部署方配置服务端密钥后验证。
- 外部 `Pset_WallCommon.LoadBearing` 仍只是设计方自标参照，不是独立结构分析真值。
- 工程师确认后的 IFC 是预审过滤结果，不代表完成结构求解或规范校核。

## 8. 发布校验

新的模型切换发布包、manifest 和 ZIP SHA-256 记录在新交付目录中。此前冻结的 `AI构件预审Agent_v3_release.zip` 保持不变；新包不包含 `.env`、真实密钥、日志、运行输出、缓存、原始响应、`__pycache__` 或 `.pyc`。
