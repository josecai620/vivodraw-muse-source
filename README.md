# VivoDraw APP 源码交付包（给 Muse AI）

这是「VivoDraw APP + 晨祷」合作项目的**临时交付仓库**。
基线：GitHub `josecai620/eccomall` 分支 `main`，提交 `99b24057`（2026-10-21）。

原始整包 65.5MB，超过上传限制，已拆成 4 个自包含压缩包，**每个都小于 25MB**。

---

## 一、先读文档（`给MuseAI/` 目录）

| 顺序 | 文件 | 内容 |
| --- | --- | --- |
| 0 | [`给MuseAI/00-阅读顺序.md`](给MuseAI/00-阅读顺序.md) | 阅读路线 + 五个关键文件 |
| 1 | [`给MuseAI/01-项目概览与业务.md`](给MuseAI/01-项目概览与业务.md) | 这是什么 App、模块、账号体系 |
| 2 | [`给MuseAI/02-技术栈与本地运行.md`](给MuseAI/02-技术栈与本地运行.md) | 版本、跑起来、基址配置 |
| 3 | [`给MuseAI/03-代码结构与约定.md`](给MuseAI/03-代码结构与约定.md) | 目录、别名、样式、加页面、禁止改动的文件 |
| 4 | [`给MuseAI/04-接口与鉴权.md`](给MuseAI/04-接口与鉴权.md) | HTTP 客户端、返回包结构、加接口四步 |
| 5 | [`给MuseAI/05-晨祷功能接入方案.md`](给MuseAI/05-晨祷功能接入方案.md) | **核心**：路由、tab、每日提醒、数据结构、验收 |
| 6 | [`给MuseAI/06-打包发布与已知边界.md`](给MuseAI/06-打包发布与已知边界.md) | EAS 打包、包名、坑、验收清单 |

另有 `说明-给MuseAI.md`（精简版交接说明，也在 01 号包里）。

---

## 二、下载这 4 个文件

| 文件 | 大小 | 内容 |
| --- | --- | --- |
| `01-源码-不含素材.zip` | 5.3 MB | mobile-app 全部源码（489 项）+ 说明文档 |
| `02-素材-分卷1.zip` | 20.8 MB | assets 图片素材，15 个文件 |
| `03-素材-分卷2.zip` | 20.7 MB | assets 图片素材，31 个文件 |
| `04-素材-分卷3.zip` | 18.7 MB | assets 图片素材，336 个文件 |

## 三、怎么解压（重要）

**4 个 zip 全部解压到同一个目录**即可，不用合并分卷、不用按顺序。

解压后：

```
mobile-app/           <- 完整工程（源码 + 全部图片素材）
说明-给MuseAI.md
README.md
```

各分卷内部已保留原始相对路径（`mobile-app/assets/...`），重复解压到同一目录不会冲突，只会补齐素材。

## 四、跑起来

```bash
cd mobile-app
npm install
npm run web        # http://localhost:8080
npm run typecheck
```

Node 20+；Expo SDK 54；不用后端也能启动，但要看到真实数据需要能访问 `https://vivodraw.com`。

## 五、校验（SHA256）

```
01-源码-不含素材.zip  D3A09E34CD8151ECE57F931904FF7325E97082C7C765489266009AF7AD2BC523
02-素材-分卷1.zip     7CBF44F6B0E0D2F56806338FCEB2F0A890BBAAB1CA99F883FC2B005CD419E9C0
03-素材-分卷2.zip     89D61EE4423F6944E123A1A6EFE5F82A3DADD404812B3F38D9577BF9AB96C329
04-素材-分卷3.zip     05CD672B0F33301B6A10417A798E6D4A9F700BB24D77289E27B6ECEEEB224DEC
```

## 六、边界说明

- 只含**用户前台 APP**（Expo / React Native Web）。PHP 后端、数据库、生产配置、密钥都不在此包。
- `mobile-app/assets` 里有 283 个图片被主仓库 `.gitignore` 忽略（海底寻珠、会员框、宠物等），**不要改用 GitHub 主仓库拉取**，会缺图。
- 包内只有 `.env.example`（仅变量名，无值）。
- 本仓库仅用于资料分发，交付完成后可删除。
