# VivoDraw 源码交付包（给 Muse AI）

基线：GitHub `josecai620/eccomall` 分支 `main`，提交 `99b24057`（2026-10-21）。
线上站点：https://vivodraw.com （v4 前台 = `mobile-app/`）。本仓库只做"下载分发"，不含任何密钥。

## 交付包一览（每个文件都小于 25MB，GitHub 单文件/单请求限制）

| 文件 | 大小 | 内容 | SHA256 |
|---|---|---|---|
| `01-源码-不含素材.zip` | 5.3MB | `mobile-app/` 全部代码（剔除 assets），解压出 `mobile-app/...` + `说明-给MuseAI.md` | `D3A09E34CD8151ECE57F931904FF7325E97082C7C765489266009AF7AD2BC523` |
| `02-素材-分卷1.zip` | 20.8MB | `mobile-app/assets` 图片分卷 1 | `7CBF44F6B0E0D2F56806338FCEB2F0A890BBAAB1CA99F883FC2B005CD419E9C0` |
| `03-素材-分卷2.zip` | 20.7MB | 分卷 2 | `89D61EE4423F6944E123A1A6EFE5F82A3DADD404812B3F38D9577BF9AB96C329` |
| `04-素材-分卷3.zip` | 18.7MB | 分卷 3 | `05CD672B0F33301B6A10417A798E6D4A9F700BB24D77289E27B6ECEEEB224DEC` |
| `05-后端PHP源码.zip` | 20.4MB | `backend_src/` PHP 源码（app/config/route/public/install/crmeb.sql/composer.json…），**不含 vendor** | `92EF769FC0CE15C6E443CEDE42F1BF1E114A9AB1D1E7ED6D45B6D6D4753B9BB3` |
| `06-后台管理Vue2源码.zip` | 23.5MB | `backend_src/view/admin`（Vue 2.6.10 + element-ui 2.15.5），不含 node_modules | `E8C1A6E4C725A54C2D666EE24A396F6E70870EE05D6105208B1CB5A9ED1D03B6` |
| `07-数据库-表结构与迁移SQL.zip` | 0.9MB | `base/crmeb.sql`(173 表) + `旧库-仅表结构-275表.sql` + `迁移SQL/`(22 个) + `说明-数据库.md` | `EB8C4E32CA7D00A436D311136173BC03C1BB8AFE4704916958188722733A3039` |
| `08-部署与文档.zip` | 1.0MB | `deploy/docker`、`deploy/nginx`、`deploy/sql`、`deploy/migrations`、`docs/`、`DEPLOY-WORKFLOW.md` | `3B94D8F3C0B9D13CED6A73F93138F0CBE7CD6281BEFA00C2127FCD6F6C426F0E` |

解压规则：**01 + 02 + 03 + 04 解压到同一个目录**（分卷是"不同文件"，不是同一文件切片，不需要 cat 合并）；
05/06/07/08 各自独立解压。

## 大文件走分卷（parts/ 目录）

从交付端单次上传超过约 2MB 会被掐断（401），所以 20MB 级的包被切成 1.8MB 分卷放在 `parts/`：

| 分卷 | 重组后 | 重组命令 |
|---|---|---|
| `parts/p05.zip.part01` … `part12` | `05-后端PHP源码.zip`（21,381,562 B） | `cat p05.zip.part* > 05-后端PHP源码.zip` |
| `parts/s01.sql.part01` … `part04` | `一键-德国版最小.sql`（5,651,704 B） | `cat s01.sql.part* > 一键-德国版最小.sql` |
| `parts/s02.sql.part01` | `补全-crmeb缺的64张表结构.sql`（72,223 B） | 直接改名 |

说明与 SHA256 见 `parts/README.md`。`06-后台管理Vue2源码.zip` 未上传（暂不需要）。

## 交接文档（`给MuseAI/`）

| 文件 | 一句话 |
|---|---|
| `00-阅读顺序.md` | 先读哪几个文件，五个关键文件清单 |
| `01-项目概览与业务.md` | VivoDraw 是什么、模块表、鉴权、交付边界 |
| `02-技术栈与本地运行.md` | 版本表、npm 脚本、API 基址三级优先级 |
| `03-代码结构与约定.md` | 目录树、`@/*` 别名、biome 规则、主题色、i18n、禁止重构清单 |
| `04-接口与鉴权.md` | `lib/http.ts` 行号级说明、返回包结构、加接口四步 |
| `05-晨祷功能接入方案.md` | `app/prayer/` 路由 + 底部 tab + 定时提醒 + 本地优先存储 |
| `06-打包发布与已知边界.md` | EAS profile、必改项、素材坑、已知问题、验收清单 |
| `07-后端与数据库.md` | PHP 后端目录、数据库来源、后台管理、部署要点 |
| `09-开盒与积分实现说明.md` | 盲盒权重抽奖算法、积分抵扣/回收、事务边界、代码行号 |
| `10-迁移顺序与部署域名现状.md` | 20 个迁移脚本顺序、最小种子数据、Compose 实测结论、正式域名 |
| `补列-盲盒概率与回收.sql` | 旧库缺的 `tag5/tag6`、`is_recovery/recovery_price/reference_price/recovery_discount` 补列 |

## 三个必须知道的结论

1. **正式域名是 `https://vivodraw.com`**；`eas.json` 里 `production` profile 的 `api.eccobuy.com / eccobuy.com` 是早期占位，实测 DNS 不解析，打包前必须换掉。
2. **旧备份比代码老约 16 个月**（2025-06-29，275 表）：缺 `eb_group_lottery*`、`eb_user_pet_*`、`eb_game_pearl_*`、`eb_game_mine_*`、`eb_user_box_checkin` 等，且 `eb_store_category` 缺 `tag5/tag6`、`eb_store_product` 缺 4 个回收列 —— 先跑 `补列-盲盒概率与回收.sql`。
3. **Docker Compose 没有做过干净 checkout 实测**（生产机已释放、本机无生产库）；compose 里 PHP 用 host 网络 + `127.0.0.1` 连库，在纯净机器上要改成服务名 `mysql`/`redis`。

## 没进包的东西

真实 `.env`、数据库账号密码、`public/uploads` 上传文件、`vendor/`（`composer install`）、后台 `node_modules`、运行态目录。
