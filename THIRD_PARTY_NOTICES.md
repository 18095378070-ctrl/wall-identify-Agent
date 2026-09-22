# 第三方组件声明 / Third-Party Notices

本文件夹中的原创部分（`wall_agent/` 下的全部代码）由本项目编写。
以下第三方组件按各自许可证使用。

---

## 1. idaholab/bim2fem（`third_party/bim2fem/`）

- 来源：https://github.com/idaholab/bim2fem
- 版权：Copyright 2025, Battelle Energy Alliance, LLC
  （美国爱达荷国家实验室 Idaho National Laboratory）
- 许可证：**GNU Lesser General Public License v3.0（LGPL-3.0）**
- 作用：把 IFC 从建筑设计域转换到结构分析域（升 MVD 到 StructuralAnalysisView）。
  本文件夹自带的这一份，是为了让网页 Demo 能独立运行、不依赖外部包。
- 使用方式：**原样包含，未做任何修改**。调用入口见
  `wall_agent/engine/pipeline.py` 的 `_load_bim2fem()`。

对外分发时需满足：

1. 随附许可证全文（见 `LICENSE-LGPL-3.0.txt`）；
2. 保留 `third_party/bim2fem/` 内各源文件头部的版权声明，不得删除或改写；
3. 若你修改了该库，必须标注修改内容与日期（本项目未修改）；
4. 保证该库可被替换（本文件夹通过目录导入实现，满足这一条）；
5. 不要在该目录内加入本项目的版权声明或授权条款。

---

## 2. Python 运行依赖

| 组件 | 用途 | 许可证 |
|---|---|---|
| IfcOpenShell | 读写 IFC、提取几何 | LGPL-3.0 |
| Flask | 网页服务端 | BSD-3-Clause |
| NumPy | 数值计算 | BSD-3-Clause |
| Shapely | 二维几何 | BSD-3-Clause |
| requests | 调用大模型接口 | Apache-2.0 |

---

## 3. 样例模型

`wall_agent/samples/` 下的两个 IFC 中，`clean_core_wall.ifc` 取自
原交付包；`stress_semantic_conflict.ifc` 由
`wall_agent/samples/make_stress_case.py` 在它基础上生成（仅改动命名与材料标注）。
仅用于演示。
