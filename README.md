# AI 构件预审 Agent

面向 BIM 到结构分析模型转换的构件预审原型。系统先用确定性规则处理明确墙体，再对语义与受力证据冲突的墙体进行 AI 仲裁，并输出可追溯证据和人工确认流程。

## 快速开始

1. 安装 Python 3.10+，并在项目目录执行：

   ```bat
   pip install -r requirements.txt
   ```

2. 复制 `.env.example` 为 `.env`，按需填写服务端 API 配置。不要把 `.env` 提交到 GitHub。

3. 双击 `start_demo.bat`，或执行 `python -m wall_agent.launch_demo`。

4. 浏览器打开本地服务地址，使用 `wall_agent/samples/` 中的样例 IFC 进行演示。

## 目录说明

- `wall_agent/`：预审 Agent、Web 接口、规则、测试和样例。
- `third_party/`：项目使用的转换相关代码。
- `requirements.txt`：Python 依赖。
- `.env.example`：仅含占位符的环境变量示例。
- `IMPLEMENTATION_REPORT.md`：实现、测试和限制说明。

本 GitHub 包不包含内置 Python 运行时、真实工程大 IFC、缓存、原始 LLM 响应、日志和编译缓存。完整本地运行环境仍保留在团队电脑上的原项目目录中。

## 数据边界

Schependomlaan 的 `Pset_WallCommon.LoadBearing` 只能作为原设计方自标的外部参照，不等于独立结构分析真值。项目输出的建议需要工程师确认后才能生成最终过滤模型。
