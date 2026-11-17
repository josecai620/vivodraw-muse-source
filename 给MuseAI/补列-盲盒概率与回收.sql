-- 补列-盲盒概率与回收.sql
-- 用途：2025-06 备份（275 表）里缺这些列，而代码已经在用它们；
--       全仓 SQL 脚本没有任何一个建过这些列（当年在生产库上手工加的）。
-- 适用：MySQL 8.0，库前缀 eb_
-- 用法：在 crmeb.sql（或旧备份）之后执行一次；已存在的列会报 Duplicate column，可忽略该条。
-- 类型为依据代码用法推定的最小可用类型（精度需求更高请自行放大）。

-- 1. 盲盒分类（盒子）的稀有度权重：代码读 cate.tag1..tag6（MangheController.php:710）
--    旧库已有 tag1..tag4，缺 tag5 / tag6；tag5/tag6 都为 0 时 hasPublicOddsConfig() 判定"未启用公开概率"
ALTER TABLE `eb_store_category`
  ADD COLUMN `tag5` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '稀有度权重 Legendary',
  ADD COLUMN `tag6` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '稀有度权重 Secret';

-- 2. 商品（奖品）的回收字段：代码 SELECT is_recovery,recovery_price,reference_price,recovery_discount（MangheController.php:603）
--    回收价优先级：recovery_price > cost > price*recoveryRateByTag(tag)（:2580-2587）
ALTER TABLE `eb_store_product`
  ADD COLUMN `is_recovery` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可回收',
  ADD COLUMN `recovery_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '回收价（0 则按成本/比例算）',
  ADD COLUMN `reference_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '参考价（展示用）',
  ADD COLUMN `recovery_discount` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '回收折扣系数';

-- 3. 校验：确认列都在
-- SELECT COLUMN_NAME FROM information_schema.COLUMNS
--  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME='eb_store_category' AND COLUMN_NAME LIKE 'tag%';
-- SELECT COLUMN_NAME FROM information_schema.COLUMNS
--  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME='eb_store_product'
--    AND COLUMN_NAME IN ('is_recovery','recovery_price','reference_price','recovery_discount');
