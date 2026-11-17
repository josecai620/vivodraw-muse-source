# parts/ 分卷说明（给 Muse）

为什么拆：从我这台机器往 GitHub 单次上传超过约 2MB 就会在 30–80 秒后被中间层掐断（返回 401 Bad credentials，重试无效）。所以大文件切成 1.8MB 的分卷逐个上传。这是传输问题，文件本身是完整的。

## 对应关系与重组命令

| 分卷 | 重组后文件 | 大小 | SHA256（重组后应与此一致） |
|---|---|---|---|
| `p05.zip.part01` … `p05.zip.part12` | `05-后端PHP源码.zip` | 21,381,562 B（20.4MB） | `92EF769FC0CE15C6E443CEDE42F1BF1E114A9AB1D1E7ED6D45B6D6D4753B9BB3` |
| `s01.sql.part01` … `s01.sql.part04` | `一键-德国版最小.sql` | 5,651,704 B（5.4MB） | `58F864FFC3AB5CB32B9B1F76F2FDD2158B4A0C0ABF39507EA810CAE138D22990` |
| `s02.sql.part01` | `补全-crmeb缺的64张表结构.sql` | 72,223 B | `9CE3889E13CEE7CB8A9AEA53A27BAB6EB51DD8F0D5E39DF60056F4398DF0A825` |

```bash
cat p05.zip.part* > 05-后端PHP源码.zip
cat s01.sql.part* > 一键-德国版最小.sql
cp s02.sql.part01 补全-crmeb缺的64张表结构.sql

# 校验（三个都应返回相同哈希）
sha256sum 05-后端PHP源码.zip 一键-德国版最小.sql 补全-crmeb缺的64张表结构.sql
```

Windows 下没有 `cat` 就用：

```powershell
cmd /c copy /b p05.zip.part01+p05.zip.part02+...+p05.zip.part12 05-后端PHP源码.zip
```

分卷必须**按 part01、part02 的顺序**拼接，顺序错了 zip 会解压失败。

## 仓库里其它东西的位置

- `01-源码-不含素材.zip`、`02/03/04-素材-分卷*.zip`：前端代码与素材，解压到同一目录。
- `07-数据库-表结构与迁移SQL.zip`、`08-部署与文档.zip`：单文件，直接在根目录。
- `给MuseAI/`：00~11 共 11 份中文交接文档 + 补列 SQL + 一键导入 SQL。
- `README.md`：全部包的清单和 SHA256。

## 05 包里有什么 / 没有什么

有：`backend_src/app`（控制器/模型/监听器/服务层）、`config`、`route`、`public`（含 `install/crmeb.sql` 5.4MB）、`composer.json`、`composer.lock`、`.example.env`、`extend`、`runtime` 空目录。
没有（刻意剔除）：`vendor/`（跑 `composer install` 生成）、`view/admin`（Vue2 后台，你看走法 A 用不上，需要再说）、`public/uploads`、`public/admin-v2`、`public/agent-admin`、真实 `.env`。
