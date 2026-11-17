# VivoDraw 商城 APP 源码交接说明（给 Muse AI）

生成时间：2026-11-17　｜　交接人：本地开发窗口（Windows）

---

## 一、这是什么

- 线上产品：<https://vivodraw.com>（美国市场电商：商城 + 积分商城 + 盲盒 + 云购夺宝 + 小游戏）
- 本包是它的**用户端 APP 前端**，用 Expo React Native 一套代码同时输出 Web/H5、iOS、Android
- 后端是另一套 PHP 8.1 + ThinkPHP 6 服务（**不在本包内**）

## 二、版本基线（本次核对结果）

| 项目 | 值 |
|---|---|
| GitHub 仓库 | `https://github.com/josecai620/eccomall` 分支 `main` |
| GitHub 最新提交 | `99b24057`　2026-10-21 18:39:58 +0800　`feat: 搭建VivoDraw获客基础链路` |
| 本地工作副本 | 与 `origin/main` 完全一致（差异 0 / 0），没有任何分支比 `main` 更新 |
| 本包内容 | `mobile-app/` 工作副本 = 上述提交 + Git 未跟踪的图片素材（见第五节） |
| 权威口径 | 项目根 `AGENTS.md`：现役前台就是 `mobile-app/`（v4）；`mobile-app-v3/` 已停用 |

结论：**全项目最新的用户端源码 = `mobile-app/`，等于 GitHub `main` 的 `99b24057`。**

## 三、技术栈与工程配置

- Expo SDK 54 / React Native / **expo-router**（文件路由）/ TypeScript / NativeWind（Tailwind）
- 数据层：`@tanstack/react-query` v5 + `axios`
- 其他关键依赖：`expo-image`、`expo-video`、`expo-notifications`、`expo-secure-store`、`expo-image-picker`、`expo-haptics`
- 应用标识：`name/slug = points-mall-app`，版本 1.0.0，`scheme = points-mall`
- iOS `bundleIdentifier` = `com.eccomall.app`；Android `package` = `com.eccomall.app`；`newArchEnabled = true`

## 四、目录结构与页面地图

```
mobile-app/
  app/            路由页面，158 个 .tsx
  components/     通用组件，137 个 .tsx
  hooks/          16 个数据 Hook（usePoints / useBox / useProduct …）
  lib/            api 请求层 + i18n + 归因（73 个文件）
  constants/      api.ts 端点表、env.ts 环境出口、主题色
  contexts/ store/ 全局状态
  assets/         图片素材 382 个文件 / 61.3 MB
  public/         Web 端静态资源（47 个文件）
  templates/ scripts/ types/ diagnostics/
```

底部五个标签（`app/(tabs)/_layout.tsx`）：`index`（首页）、`categories`（分类）、`points`（积分/云购）、`cart`（购物车）、`profile`（我的）。

主要路由分组（子页面数）：

| 分组 | 用途 | tsx 数 |
|---|---|---|
| `app/points/` | 积分商城、夺宝、兑换 | 37 |
| `app/profile/` | 个人中心、会员、订单入口 | 31 |
| `app/box/` | 盲盒商城 | 27 |
| `app/marketing/` | 营销活动页 | 11 |
| `app/reveal/` | 开奖揭晓流程 | 9 |
| `app/orders/ checkout/ auth/ community/ group-lottery/ search/ articles/ agreement/ web/` | 订单、结算、登录注册、社区、拼团抽奖、搜索、图文、协议、内嵌页 | 1–6 每个 |

顶层单页：`pearl.tsx`（海底寻珠小游戏）、`farm1.tsx`、`pet-deck.tsx`（宠物）、`game-wallet.tsx`、`coin-exchange.tsx`、`point-purchase.tsx`、`wallet.tsx`、`play.tsx`、`pick-your-prize.tsx`、`support.tsx`。

## 五、怎么跑起来

```bash
cd mobile-app
npm install
npm run web        # 浏览器预览（http://localhost:8080）
npm start          # Metro，手机用 Expo Go / dev client 扫码
npm run typecheck  # tsc --noEmit
npm run export:web # 构建静态 Web 到 dist-root/
```

- 需要 Node 18+ 与 npm；依赖装好后 49149 个文件 / 474 MB
- **本包已剔除** `node_modules/`、`dist*/`、`.expo/`、构建日志、`v4-bundle.tar.gz` 等可再生成产物
- **图片素材**：Git 只跟踪了 `assets/` 里的 99 个文件（20.1 MB），其余 283 个（约 41 MB，主要是 `assets/海底寻珠/`、`assets/member/`、`assets/pets/`）不在 Git 里。本包**已经把完整的 382 个素材文件一起打进去了**，所以视觉是完整的；如果只从 GitHub 拉源码，这些页面会缺图
- **不含任何密钥**：目录里只有 `.env.example`，没有 `.env`

## 六、接口约定

- API 基址：`https://vivodraw.com`，位置 `app.json → expo.extra.ApiBaseUrl`
- 覆盖优先级（见 `constants/env.ts`）：运行时环境变量 `EXPO_PUBLIC_API_BASE_URL` > `app.json extra` > 硬编码兜底
- 每个请求带请求头 `X-Client: mobile-app`
- 端点全表在 `constants/api.ts`；可读文档：`API_CONTRACT_SNAPSHOT.md`、`M1_接口契约快照_v1.md`、`接口互通清单.md`、`API_CONNECTIVITY_AUDIT.md`
- **后端不在本包内**。要让 APP 独立跑通，需要 mock 数据（`EXPO_PUBLIC_USE_MOCK_DATA`）或自建同口径后端

## 七、和「晨祷 APP」结合时最相关的落点

1. **加新模块**：在 `app/` 下新建路由分组（例如 `app/prayer/`），再在 `app/(tabs)/_layout.tsx` 里加一个 `Tabs.Screen` 就出现在底部导航
2. **多语言**：目前只有 `lib/i18n/locales/en.json`、`zh-TW.json` 两套；新增语言按同结构加文件
3. **主题/色板/字体**：`constants/` + `tailwind.config.js` + `global.css`
4. **请求层复用**：`lib/api/*.ts` 定义函数 → `hooks/use*.ts` 包 react-query → 页面直接调用
5. **定时提醒**：`app.json` 已声明 `expo-notifications` 插件与 Android `POST_NOTIFICATIONS`、`RECEIVE_BOOT_COMPLETED` 权限，晨祷的每日提醒可以直接复用这套
6. **音频/视频播放**：已装 `expo-video`、`expo-audio` 系依赖，做祷词朗读/背景音现成

## 八、已知边界

- 后台管理系统（Vue2）与 PHP 后端不在本包，需要另行索取
- `mobile-app-v3/` 是停用旧版，不要参考
- `yunmall-hybrid/` 是云购玩法改造工作区（文档 + TypeScript 模块桩，不是可运行 APP）
- 包内 `*.bak-pre-*` 是历史备份文件，可忽略或删除
