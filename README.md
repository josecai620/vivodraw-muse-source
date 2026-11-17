# VivoDraw APP 源码交付包（给 Muse AI）

这是为「VivoDraw APP + 晨祷」合作项目准备的临时交付仓库。
**基线**：GitHub `josecai620/eccomall` 分支 `main`，提交 `99b24057`（2026-10-21）。

大包 65.5MB，超过上传限制，所以拆成 4 个自包含压缩包，**每个都小于 25MB**。

## 一、下载这 4 个文件

| 文件 | 大小 | 内容 |
| --- | --- | --- |
| `01-源码-不含素材.zip` | 5.3 MB | mobile-app 全部源码（489 个文件）+ 说明文档 |
| `02-素材-分卷1.zip` | 20.8 MB | assets 图片素材，15 个文件 |
| `03-素材-分卷2.zip` | 20.7 MB | assets 图片素材，31 个文件 |
| `04-素材-分卷3.zip` | 18.7 MB | assets 图片素材，336 个文件 |

## 二、怎么解压（重要）

**把 4 个 zip 全部解压到同一个目录**即可，不用合并分卷、不用按顺序。

解压后结构：

```
mobile-app/           <- 完整 APP 工程（源码 + 全部图片素材）
说明-给MuseAI.md      <- 先读这个
README.md
```

各分卷里已经保留了原始相对路径（`mobile-app/assets/...`），所以重复解压到同一目录不会冲突，只会补齐素材。

## 三、先读 `说明-给MuseAI.md`

里面写了：技术栈、怎么跑起来、接口基址配置在哪、以及「和晨祷 APP 结合在一起」的推荐落点（新建 `app/prayer/` 分组 + 在 `app/(tabs)/_layout.tsx` 挂一个 tab，复用 `lib/api` 与 `hooks`，通知直接用已集成的 expo-notifications）。

## 四、跑起来

```bash
cd mobile-app
npm install
npm run web      # 浏览器预览 http://localhost:8080
# 或 npm start   （Expo Go / 模拟器）
npm run typecheck
```

Node 20+；Expo SDK 54；无需后端即可启动，但要看到真实数据需要连 `https://vivodraw.com`。

## 五、校验（SHA256）

```
01-源码-不含素材.zip  1CE5537557A1A0B44DBAF083058D02DF568EA60A3CF0584BB83402B396C2C240
02-素材-分卷1.zip     EAD112A1435FDEABDE2A6355CBDDA60C28D3923D3306FB02B06D1609E7C19EB5
03-素材-分卷2.zip     FFB602E8BECA0466FBAE8E57734364ECE1D3BD080015CB2D3E782B77265CFA26
04-素材-分卷3.zip     8D09348438885A53A82E61F37D6A547FBE4F347F09412C5681612680312A7A09
```

## 六、边界说明

- 本包只含**用户前台 APP**（Expo/React Native Web）。PHP 后端、数据库、生产环境配置、密钥都不在此仓库。
- `mobile-app/assets` 里有 283 个图片被主仓库 .gitignore 忽略（海底寻珠、会员框、宠物等），所以**不要改用 GitHub 主仓库拉取**，会缺图。这里的 4 个包是完整版。
- 本仓库仅用于资料分发，交付完成后可删除。
