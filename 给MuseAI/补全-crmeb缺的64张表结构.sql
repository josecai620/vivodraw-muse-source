-- 补全：crmeb.sql（173 表）里缺失、但代码确实要用的表结构
-- 来源：2025-06-29 生产库备份的结构（旧库-仅表结构-275表.sql），仅取 CREATE TABLE，无任何数据
-- 说明：这些表当初是直接在生产库建的，仓库里没有任何迁移脚本创建它们（全仓 23 个 SQL 全部 grep 过）
-- 共 64 张 eb_* 表；另有 38 张 fa_* 是更早期 Ecshop 遗留表，与本项目无关，未包含
-- 全部 CREATE TABLE IF NOT EXISTS，无外键，执行顺序无关；字符集统一 utf8mb4

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `eb_box_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(255) DEFAULT '' COMMENT '订单编号',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类ID',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '单价',
  `num` int NOT NULL DEFAULT '0' COMMENT '数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `pay_money` decimal(10,2) DEFAULT '0.00' COMMENT '支付金额',
  `pay_status` tinyint(1) DEFAULT '0' COMMENT '支付状态',
  `pay_time` int DEFAULT '0' COMMENT '支付时间',
  `createtime` int NOT NULL COMMENT '创建时间',
  `cate_image` varchar(255) DEFAULT NULL,
  `cate_name` varchar(255) DEFAULT NULL,
  `pay_type` varchar(255) DEFAULT '',
  `is_jiqiren` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是机器人下单',
  `user_coupon_id` int NOT NULL DEFAULT '0' COMMENT '用户优惠券ID',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券ID',
  `discounts_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '打折金额',
  `point_deduction_num` int NOT NULL DEFAULT '0' COMMENT '积分抵扣数量',
  `point_deduction_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '积分抵扣金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1922856 DEFAULT CHARSET=utf8mb3 COMMENT='盲盒订单表';

CREATE TABLE `eb_integral_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级id',
  `type` tinyint(1) DEFAULT '1' COMMENT '类型：1平台2:门店',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `owner_id` int NOT NULL DEFAULT '0' COMMENT '所属人，为全部',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `group` tinyint(1) NOT NULL DEFAULT '0' COMMENT '分类类型0=标签分类，1=快捷短语分类,2=商品标签分类，3=商品参数模版,4=企业渠道码',
  `other` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '其他参数',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `name` (`name`(191)),
  KEY `is_be` (`owner_id`,`type`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签分类';

CREATE TABLE `eb_out_interface` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级pid',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0菜单，1接口',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '接口名称',
  `describe` text COMMENT '功能描述',
  `method` varchar(255) NOT NULL DEFAULT '' COMMENT '接口类型',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '接口地址',
  `request_params` longtext COMMENT '请求参数',
  `return_params` longtext COMMENT '返回参数',
  `request_example` longtext COMMENT '请求示例',
  `return_example` longtext COMMENT '返回示例',
  `error_code` longtext COMMENT '错误返回',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对外接口';

CREATE TABLE `eb_store_activity` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1:秒杀',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `image` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '氛围图片',
  `start_day` int NOT NULL DEFAULT '0' COMMENT '开始日期',
  `end_day` int NOT NULL DEFAULT '0' COMMENT '结束日期',
  `start_time` int unsigned DEFAULT NULL COMMENT '开始时间',
  `end_time` int unsigned DEFAULT NULL COMMENT '结束时间',
  `time_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '时间段ID多个',
  `once_num` int unsigned DEFAULT '0' COMMENT '活动期间每人每日购买数量，0不限制',
  `num` int unsigned DEFAULT '0' COMMENT '全部活动期间，用户购买总数限制，0不限制',
  `discount` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠方式',
  `status` tinyint unsigned DEFAULT '0' COMMENT '是否显示',
  `is_recommend` tinyint unsigned DEFAULT '0' COMMENT '是否推荐',
  `link_id` int unsigned DEFAULT '0' COMMENT '关联ID',
  `applicable_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '适用门店：0：仅平台1：所有2：部分',
  `applicable_store_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '适用门店ids',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `start_day` (`start_day`,`end_day`) USING BTREE,
  KEY `start_time` (`start_time`,`end_time`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='活动表';

CREATE TABLE `eb_store_activity_relation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`activity_id`,`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='活动关联表中间表(多对多)';

CREATE TABLE `eb_store_delivery_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '商品所属：0：平台1:门店2:供应商',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联门店、供应商ID',
  `oid` int unsigned NOT NULL COMMENT '订单ID',
  `uid` int unsigned NOT NULL DEFAULT '0',
  `station_type` int unsigned NOT NULL COMMENT '平台类型',
  `order_id` varchar(32) NOT NULL DEFAULT '' COMMENT '订单ID',
  `delivery_no` varchar(255) NOT NULL DEFAULT '' COMMENT '配送方订单号',
  `city_code` varchar(20) NOT NULL DEFAULT '' COMMENT '所属城市',
  `cargo_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '配送订单价格',
  `finish_code` varchar(255) NOT NULL DEFAULT '' COMMENT '收货码',
  `user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `receiver_phone` varchar(11) NOT NULL DEFAULT '' COMMENT '收货人电话',
  `from_address` varchar(255) NOT NULL DEFAULT '' COMMENT '起始位置',
  `to_address` varchar(255) NOT NULL DEFAULT '' COMMENT '结束位置',
  `from_lat` varchar(255) NOT NULL DEFAULT '',
  `from_lng` varchar(255) NOT NULL DEFAULT '',
  `to_lat` varchar(255) NOT NULL DEFAULT '',
  `to_lng` varchar(255) NOT NULL DEFAULT '',
  `distance` float NOT NULL DEFAULT '0' COMMENT '配送距离',
  `fee` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '配送费',
  `deduct_fee` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '取消订单违约金',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '订单备注',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态 取消=-1, 待取货＝2,配送中＝3,已完成＝4,物品返回中=9,物品返回完成=10,骑士到店=100',
  `reason` varchar(255) NOT NULL DEFAULT '' COMMENT '取消原因',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='发货配送订单';

CREATE TABLE `eb_store_integral_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名称',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父ID',
  `fid` varchar(64) NOT NULL DEFAULT '' COMMENT '父ID集合 ',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示	',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='品牌表';

CREATE TABLE `eb_store_integral_cart` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `tourist_uid` varchar(50) NOT NULL DEFAULT '' COMMENT '游客uid',
  `type` smallint NOT NULL DEFAULT '0' COMMENT '类型 0:普通、1：秒杀、2:砍价、3:拼团、4:积分、5:套餐',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `activity_id` int NOT NULL DEFAULT '0' COMMENT '活动商品ID',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `staff_id` int NOT NULL DEFAULT '0' COMMENT '店员id',
  `product_attr_unique` varchar(16) NOT NULL DEFAULT '' COMMENT '商品属性',
  `cart_num` smallint unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_pay` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 未购买 1 = 已购买',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为立即购买',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '购物车商品状态',
  `bianhao` int DEFAULT '1' COMMENT '商品编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`product_id`) USING BTREE,
  KEY `uid` (`uid`,`is_pay`) USING BTREE,
  KEY `uid_2` (`uid`,`is_del`) USING BTREE,
  KEY `uid_3` (`uid`,`is_new`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPACT COMMENT='购物车表';

CREATE TABLE `eb_store_integral_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商品分类表ID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父id',
  `cate_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `pic` varchar(128) NOT NULL DEFAULT '' COMMENT '图标',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否推荐',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `big_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '分类大图',
  `type` int NOT NULL DEFAULT '1' COMMENT '是否是积分换购',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE,
  KEY `is_base` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';

CREATE TABLE `eb_store_integral_kaijiang_shaidan_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0',
  `praise` int NOT NULL DEFAULT '0' COMMENT '点赞数量',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '回复内容',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级回复id',
  `reply_id` int NOT NULL DEFAULT '0' COMMENT '评论id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `product_id` int DEFAULT '0' COMMENT '商品ID',
  PRIMARY KEY (`id`),
  KEY `reply_id` (`reply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品评价回复表';

CREATE TABLE `eb_store_integral_kaijiang_shaidan_praise` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0',
  `shaidan_id` int NOT NULL DEFAULT '0' COMMENT '晒单id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `product_id` int DEFAULT '0' COMMENT '商品ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品评价回复表';

CREATE TABLE `eb_store_integral_order_status_kaijiang` (
  `oid` int unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `change_type` varchar(32) NOT NULL DEFAULT '' COMMENT '操作类型',
  `change_message` varchar(256) NOT NULL DEFAULT '' COMMENT '操作备注',
  `change_time` int unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  KEY `oid` (`oid`) USING BTREE,
  KEY `change_type` (`change_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='积分订单操作记录表';

CREATE TABLE `eb_store_integral_product` (
  `id` mediumint NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `xiaci_jiqiren_time` int DEFAULT '0' COMMENT '下次机器人购买时间',
  `is_xinping` tinyint(1) DEFAULT '0' COMMENT '是否新品',
  `product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型0:普通商品，1：卡密，2：优惠券，3：虚拟商品',
  `supplier_id` int NOT NULL DEFAULT '0' COMMENT '供应商ID',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户Id(0为总后台管理员创建,不为0的时候是商户后台创建)',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `recommend_image` varchar(256) NOT NULL DEFAULT '' COMMENT '推荐图',
  `slider_image` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `store_info` varchar(256) NOT NULL DEFAULT '' COMMENT '商品简介',
  `keyword` varchar(256) NOT NULL DEFAULT '' COMMENT '关键字',
  `bar_code` varchar(15) NOT NULL DEFAULT '' COMMENT '商品条码（一维码）',
  `cate_id` varchar(64) NOT NULL DEFAULT '' COMMENT '分类id',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品价格',
  `vip_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '会员价格',
  `ot_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '市场价',
  `postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `delivery_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品配送方式',
  `freight` tinyint(1) NOT NULL DEFAULT '2' COMMENT '运费设置',
  `unit_name` varchar(32) NOT NULL DEFAULT '' COMMENT '单位名',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `sales` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `stock` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（0：未上架，1：上架）',
  `is_hot` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否热卖',
  `is_benefit` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否优惠',
  `is_best` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否精品',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否新品',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_postage` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否包邮',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `mer_use` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '商户是否代理 0不可代理1可代理',
  `give_integral` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '获得积分',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `is_seckill` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '秒杀状态 0 未开启 1已开启',
  `is_bargain` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '砍价状态 0未开启 1开启',
  `is_good` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否优品推荐',
  `is_sub` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否单独分佣',
  `is_vip` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启会员价格',
  `ficti` mediumint DEFAULT '100' COMMENT '虚拟销量',
  `browse` int NOT NULL DEFAULT '0' COMMENT '浏览量',
  `code_path` varchar(64) NOT NULL DEFAULT '' COMMENT '商品二维码地址(用户小程序海报)',
  `soure_link` varchar(255) NOT NULL DEFAULT '' COMMENT '淘宝京东1688类型',
  `video_link` varchar(500) NOT NULL DEFAULT '' COMMENT '主图视频链接',
  `temp_id` int NOT NULL DEFAULT '1' COMMENT '运费模板ID',
  `spec_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '规格 0单 1多',
  `activity` varchar(255) NOT NULL DEFAULT '' COMMENT '活动显示排序1=秒杀，2=砍价，3=拼团',
  `spu` char(13) NOT NULL DEFAULT '' COMMENT '商品SPU',
  `label_id` varchar(64) NOT NULL DEFAULT '' COMMENT '标签ID',
  `command_word` varchar(255) NOT NULL DEFAULT '' COMMENT '复制口令',
  `recommend_list` varchar(256) NOT NULL DEFAULT '' COMMENT '推荐产品',
  `brand_id` int NOT NULL DEFAULT '0' COMMENT '品牌id',
  `brand_com` varchar(64) NOT NULL DEFAULT '' COMMENT '品牌组合',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '编码',
  `is_vip_product` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否会员专属商品',
  `is_presale_product` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否预售商品',
  `presale_start_time` int NOT NULL DEFAULT '0' COMMENT '预售开始时间',
  `presale_end_time` int NOT NULL DEFAULT '0' COMMENT '预售结束时间',
  `presale_day` int NOT NULL DEFAULT '0' COMMENT '预售结束后几天内发货',
  `auto_on_time` int NOT NULL DEFAULT '0' COMMENT '自动上架时间',
  `auto_off_time` int NOT NULL DEFAULT '0' COMMENT '自动下架时间',
  `custom_form` longtext COMMENT '自定义表单',
  `is_support_refund` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否支持退款',
  `store_label_id` longtext COMMENT '商品标签iDS',
  `ensure_id` longtext COMMENT '商品保障服务ids',
  `specs` longtext COMMENT '商品参数',
  `specs_id` int NOT NULL DEFAULT '0' COMMENT '参数模版ID',
  `is_limit` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启限购',
  `limit_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '限购类型1单次限购2永久限购',
  `limit_num` int NOT NULL DEFAULT '0' COMMENT '限购数量',
  `bianhao` int DEFAULT '1' COMMENT '编号',
  `exchange_num` int DEFAULT '0' COMMENT '已兑换数量',
  `jindu_bili` decimal(10,2) DEFAULT '0.00',
  `kouchujifen` int DEFAULT '1' COMMENT '每次扣除积分',
  `is_jiqiren` int DEFAULT '0',
  `jiqiren_jiange_min` int DEFAULT '0',
  `jiqiren_jiange_max` int DEFAULT '0',
  `jiqiren_goods_min_1` int DEFAULT '0',
  `jiqiren_goods_max_1` int DEFAULT '0',
  `jiqiren_goods_min_2` int DEFAULT '0',
  `jiqiren_goods_max_2` int DEFAULT '0',
  `jiqiren_goods_min_3` int DEFAULT '0',
  `jiqiren_goods_max_3` int DEFAULT '0',
  `is_recovery` tinyint NOT NULL DEFAULT '0' COMMENT '是否回收',
  `recovery_price` decimal(10,2) DEFAULT '0.00' COMMENT '回收价格',
  `reference_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '参考价',
  `recovery_discount` int NOT NULL DEFAULT '0' COMMENT '回收价格折扣',
  `lucky_num` int NOT NULL DEFAULT '0' COMMENT '幸运值',
  `min_duihuan_num` int DEFAULT '0' COMMENT '开奖批次最低兑换次数',
  `zhongjiang_jiange_num` int NOT NULL DEFAULT '0' COMMENT '隔几次中一次',
  `zhongjiang_jiange_current` int DEFAULT '0' COMMENT '中间间隔当前间隔次数',
  `is_zhongjiang_gailv_open` tinyint(1) DEFAULT '0' COMMENT '中奖概率开关',
  `is_kami` tinyint(1) DEFAULT '0' COMMENT '是否卡密商品',
  `bizhong_num` int DEFAULT '0' COMMENT '必中抽奖次数',
  `jiqiren_goods_start_1` int DEFAULT '-1' COMMENT '下注1开始时间',
  `jiqiren_goods_start_2` int DEFAULT '-1' COMMENT '下注2开始时间',
  `jiqiren_goods_start_3` int DEFAULT '-1' COMMENT '下注3开始时间',
  `jiqiren_goods_end_1` int DEFAULT '-1' COMMENT '下注1结束时间',
  `jiqiren_goods_end_2` int DEFAULT '-1' COMMENT '下注2结束时间',
  `jiqiren_goods_end_3` int DEFAULT '-1' COMMENT '下注3结束时间',
  `is_box` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否盲盒',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE,
  KEY `is_hot` (`is_hot`) USING BTREE,
  KEY `is_benefit` (`is_benefit`) USING BTREE,
  KEY `is_best` (`is_best`) USING BTREE,
  KEY `is_new` (`is_new`) USING BTREE,
  KEY `toggle_on_sale, is_del` (`is_del`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `sales` (`sales`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `is_postage` (`is_postage`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=369 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';

CREATE TABLE `eb_store_integral_product_attr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `attr_name` varchar(32) NOT NULL DEFAULT '' COMMENT '属性名',
  `attr_values` longtext COMMENT '属性值',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  PRIMARY KEY (`id`),
  KEY `store_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=879 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品属性表';

CREATE TABLE `eb_store_integral_product_attr_result` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `result` longtext COMMENT '商品属性参数',
  `change_time` int unsigned NOT NULL DEFAULT '0' COMMENT '上次修改时间',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=364 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品属性详情表';

CREATE TABLE `eb_store_integral_product_attr_value` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `suk` varchar(128) NOT NULL DEFAULT '' COMMENT '商品属性索引值 (attr_value|attr_value[|....])',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '属性对应的库存',
  `sum_stock` int NOT NULL DEFAULT '0' COMMENT '平台库存+门店库存总和',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '属性金额',
  `image` varchar(128) DEFAULT '' COMMENT '图片',
  `unique` char(8) NOT NULL DEFAULT '' COMMENT '唯一值',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `bar_code` varchar(50) NOT NULL DEFAULT '' COMMENT '商品条码',
  `ot_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '原价',
  `vip_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '会员专享价',
  `weight` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `volume` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '体积',
  `brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '一级返佣',
  `brokerage_two` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '二级返佣',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  `quota` int NOT NULL DEFAULT '0' COMMENT '活动限购数量',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '活动限购数量显示',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '编码',
  `disk_info` longtext COMMENT '虚拟信息内容',
  PRIMARY KEY (`id`),
  KEY `unique` (`unique`,`suk`) USING BTREE,
  KEY `store_id` (`product_id`,`suk`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=364 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品属性值表';

CREATE TABLE `eb_store_integral_product_cate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `cate_pid` int NOT NULL DEFAULT '0' COMMENT '一级分类id',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类辅助表';

CREATE TABLE `eb_store_integral_product_coupon` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `issue_coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠劵id',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品关联优惠券表';

CREATE TABLE `eb_store_integral_product_description` (
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `description` text COMMENT '商品详情',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  KEY `product_id` (`product_id`,`type`),
  KEY `type` (`type`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品详情表';

CREATE TABLE `eb_store_integral_product_ensure` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '1' COMMENT '类型：1平台2:门店',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品保障服务表';

CREATE TABLE `eb_store_integral_product_huanqu_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `uid` int NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 进行中 1 已揭晓',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `bianhao` int DEFAULT '1' COMMENT '商品编号',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '管理员备注',
  `setuid` int NOT NULL DEFAULT '0' COMMENT '是否设置开奖用户',
  `lucky_num` int DEFAULT '0' COMMENT '幸运值',
  `min_duihuan_num` int DEFAULT '0' COMMENT '开奖批次最低兑换次数',
  `is_jiqiren` tinyint(1) DEFAULT '0' COMMENT '判断是否是机器人',
  `total_price` decimal(10,2) DEFAULT '0.00' COMMENT '总消费额',
  `ot_price` decimal(10,2) DEFAULT '0.00' COMMENT '兑换一次扣积分数',
  `is_kami` tinyint(1) DEFAULT '0' COMMENT '是否卡密商品',
  `haomiao` varchar(20) DEFAULT '0',
  `zhaunhuanshuju` int DEFAULT '0',
  `haomiao_num` int DEFAULT '0',
  `box_order_id` int DEFAULT '0' COMMENT '盲盒订单ID',
  `box_cate_id` int DEFAULT '0' COMMENT '盲盒分类ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `product_id` (`product_id`),
  KEY `bianhao` (`bianhao`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2565727 DEFAULT CHARSET=utf8mb3 COMMENT='积分订单表';

CREATE TABLE `eb_store_integral_product_huanqu_log_unique` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 进行中 1 已揭晓',
  `huanqu_id` int DEFAULT '0' COMMENT '换取记录表ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `bianhao` int DEFAULT '1' COMMENT '商品编号',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `unique` char(8) NOT NULL DEFAULT '' COMMENT '唯一值',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `isset` int NOT NULL DEFAULT '0',
  `is_jiqiren` tinyint(1) DEFAULT '0' COMMENT '是否是机器人',
  `haomiao` varchar(20) DEFAULT '0',
  `zhaunhuanshuju` int DEFAULT '0',
  `haomiao_num` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `huanqu_id` (`huanqu_id`),
  KEY `product_id` (`product_id`),
  KEY `bianhao` (`bianhao`)
) ENGINE=InnoDB AUTO_INCREMENT=12736848 DEFAULT CHARSET=utf8mb3 COMMENT='积分商品换取编码表';

CREATE TABLE `eb_store_integral_product_huanqu_set_price` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int DEFAULT '0',
  `min_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最新价格',
  `max_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最大价格',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型 1 随机 2 必中',
  `bili` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额占比',
  `zhongjiang_bili` int DEFAULT '0' COMMENT '随机中中奖比例',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COMMENT='中奖概率表';

CREATE TABLE `eb_store_integral_product_huanqu_set_zhong` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `uid` int NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 预设中 1 已设置',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='积分订单表';

CREATE TABLE `eb_store_integral_product_kaijiang_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(255) DEFAULT NULL COMMENT '订单编号',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 未开奖1 已开奖 2 待发货 3 待收货 4 已完成 5 已晒单 6 已回收',
  `uid` int NOT NULL DEFAULT '0',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL DEFAULT '' COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL DEFAULT '' COMMENT '详细地址',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `unique` char(8) NOT NULL DEFAULT '' COMMENT '唯一值',
  `cart_info` longtext COMMENT '积分商品信息',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `total_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总积分',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '管理员备注',
  `product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `bianhao` int DEFAULT '1' COMMENT '商品编号',
  `kaijiang_time` int NOT NULL DEFAULT '0' COMMENT '开奖时间',
  `huanqu_id` int DEFAULT '0' COMMENT '中奖者换取记录ID',
  `huanqu_num` int DEFAULT '0' COMMENT '中奖者获取数量',
  `zhongjiang_time` int DEFAULT '0' COMMENT '中奖时间',
  `log_unique_id` int DEFAULT '0' COMMENT '中奖编号ID',
  `cate_id` int DEFAULT '0' COMMENT '商品分类',
  `is_recovery` tinyint(1) DEFAULT '0' COMMENT '是否回收',
  `recovery_price` decimal(10,2) DEFAULT '0.00' COMMENT '回收价格',
  `recovery_discount` int DEFAULT '0' COMMENT '回收折扣',
  `is_jiqiren` tinyint(1) DEFAULT '0' COMMENT '是否是机器人中奖',
  `delivery_id` varchar(255) DEFAULT '' COMMENT '快递号',
  `delivery_name` varchar(255) DEFAULT '' COMMENT '快递公司',
  `delivery_type` varchar(255) DEFAULT '',
  `is_kami` tinyint(1) DEFAULT '0' COMMENT '是否是卡密商品',
  `kami_account` varchar(255) DEFAULT '' COMMENT '卡密账号',
  `kami_pass` varchar(255) DEFAULT '' COMMENT '卡密密码',
  `shijian_sum` varchar(255) DEFAULT '' COMMENT '时间和',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101716 DEFAULT CHARSET=utf8mb3 COMMENT='积分订单表';

CREATE TABLE `eb_store_integral_product_kaijiang_shaidan` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(255) DEFAULT NULL COMMENT '订单编号',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 未开奖1 已开奖 2 待发货 3 待收货 4 已完成 5 已晒单',
  `uid` int NOT NULL DEFAULT '0',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `unique` char(8) NOT NULL DEFAULT '' COMMENT '唯一值',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '管理员备注',
  `bianhao` int DEFAULT '1' COMMENT '商品编号',
  `kaijiang_time` int NOT NULL DEFAULT '0' COMMENT '开奖时间',
  `huanqu_id` int DEFAULT '0' COMMENT '中奖者换取记录ID',
  `huanqu_num` int DEFAULT '0' COMMENT '中奖者获取数量',
  `zhongjiang_time` int DEFAULT '0' COMMENT '中奖时间',
  `log_unique_id` int DEFAULT '0' COMMENT '中奖编号ID',
  `cate_id` int DEFAULT '0' COMMENT '商品分类',
  `shaidan_images` text COMMENT '晒单图片',
  `title` varchar(255) DEFAULT '' COMMENT '标题',
  `is_show` tinyint(1) DEFAULT '0' COMMENT '是否显示',
  `content` text,
  `views_num` int DEFAULT '0' COMMENT '浏览量',
  `praise` int DEFAULT '0' COMMENT '点赞数',
  `kaijiang_id` int DEFAULT '0' COMMENT '开奖记录ID',
  `shaidan_image` varchar(255) DEFAULT NULL COMMENT '晒单首图',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='积分订单表';

CREATE TABLE `eb_store_integral_product_label` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '1' COMMENT '类型：1平台2:门店',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `label_cate` int NOT NULL DEFAULT '0' COMMENT '标签分类',
  `label_name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `label_cate` (`label_cate`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品标签表';

CREATE TABLE `eb_store_integral_product_label_auxiliary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label_id` int NOT NULL DEFAULT '0',
  `product_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `label_id` (`label_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品标签辅助表';

CREATE TABLE `eb_store_integral_product_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` enum('visit','cart','order','pay','collect','refund') NOT NULL DEFAULT 'visit' COMMENT '类型',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `visit_num` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否浏览',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '下单数量',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '支付数量',
  `pay_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `cost_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品成本价',
  `pay_uid` int NOT NULL DEFAULT '0' COMMENT '支付用户ID',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款数量',
  `refund_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `collect_num` tinyint(1) NOT NULL DEFAULT '0' COMMENT '收藏',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `delete_time` timestamp NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `type` (`type`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `uid_type` (`uid`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品统计';

CREATE TABLE `eb_store_integral_product_recovery_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL COMMENT '用户ID',
  `order_no` varchar(255) DEFAULT NULL COMMENT '开奖订单号',
  `kaijiang_id` int NOT NULL,
  `store_name` varchar(255) DEFAULT '' COMMENT '商品名称',
  `image` varchar(255) DEFAULT '' COMMENT '图片',
  `unique` varchar(255) DEFAULT NULL COMMENT '中奖编号',
  `kaijiang_time` int DEFAULT NULL COMMENT '开奖时间',
  `recovery_price` decimal(10,2) DEFAULT '0.00' COMMENT '回收价',
  `recovery_discount` decimal(10,2) DEFAULT '0.00' COMMENT '回收折扣',
  `pay_money` decimal(10,2) DEFAULT '0.00' COMMENT '实际支付',
  `real_name` varchar(255) DEFAULT NULL COMMENT '真实姓名',
  `log_time` int NOT NULL DEFAULT '0',
  `product_id` int DEFAULT '0',
  `bianhao` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='积分商品回收记录';

CREATE TABLE `eb_store_integral_product_relation` (
  `uid` int DEFAULT NULL,
  `relation_id` int unsigned NOT NULL DEFAULT '0' COMMENT '关联ID',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '类型(收藏(collect）、点赞(like))',
  `category` varchar(32) NOT NULL DEFAULT '' COMMENT '某种类型的商品(普通商品、秒杀商品)',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `bianhao` int DEFAULT '1' COMMENT '商品编号',
  UNIQUE KEY `uid` (`relation_id`,`type`,`category`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `category` (`category`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品点赞和收藏表';

CREATE TABLE `eb_store_integral_product_reply` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `oid` int NOT NULL DEFAULT '0' COMMENT '订单ID',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型：1平台2:门店',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `unique` char(32) NOT NULL DEFAULT '' COMMENT '唯一id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `reply_type` varchar(32) NOT NULL DEFAULT 'product' COMMENT '某种商品类型(普通商品、秒杀商品）',
  `product_score` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品分数',
  `service_score` tinyint(1) NOT NULL DEFAULT '0' COMMENT '服务分数',
  `comment` varchar(512) NOT NULL DEFAULT '' COMMENT '评论内容',
  `pics` text COMMENT '评论图片',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '评论时间',
  `praise` int NOT NULL DEFAULT '0' COMMENT '点赞',
  `views_num` int NOT NULL DEFAULT '0' COMMENT '浏览量',
  `merchant_reply_content` varchar(300) NOT NULL DEFAULT '' COMMENT '管理员回复内容',
  `merchant_reply_time` int NOT NULL DEFAULT '0' COMMENT '管理员回复时间',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0未删除1已删除',
  `is_reply` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0未回复1已回复',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '用户名称',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '用户头像',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`oid`,`unique`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `parent_id` (`reply_type`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `product_score` (`product_score`) USING BTREE,
  KEY `service_score` (`service_score`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='评论表';

CREATE TABLE `eb_store_integral_product_reply_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0',
  `praise` int NOT NULL DEFAULT '0' COMMENT '点赞数量',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '回复内容',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级回复id',
  `reply_id` int NOT NULL DEFAULT '0' COMMENT '评论id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `reply_id` (`reply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品评价回复表';

CREATE TABLE `eb_store_integral_product_rule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(32) NOT NULL DEFAULT '' COMMENT '规格名称',
  `rule_value` text COMMENT '规格值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品规则值(规格)表';

CREATE TABLE `eb_store_integral_product_specs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '1' COMMENT '类型：1平台2:门店',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '模版ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '参数名称',
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT '参数值',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品参数表';

CREATE TABLE `eb_store_integral_product_stock_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `unique` varchar(32) NOT NULL DEFAULT '' COMMENT '规格唯一值',
  `cost_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `number` int NOT NULL DEFAULT '0' COMMENT '数量',
  `pm` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1:入库0:出库',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品库存记录';

CREATE TABLE `eb_store_integral_product_unit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '单位名称',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否上架',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品单位表';

CREATE TABLE `eb_store_integral_product_virtual` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `attr_unique` varchar(20) NOT NULL DEFAULT '' COMMENT '对应商品规格',
  `card_no` varchar(255) NOT NULL DEFAULT '' COMMENT '卡密卡号',
  `card_pwd` varchar(255) NOT NULL DEFAULT '' COMMENT '卡密密码',
  `card_unique` varchar(32) NOT NULL DEFAULT '' COMMENT '虚拟卡密唯一值',
  `order_id` varchar(255) NOT NULL DEFAULT '' COMMENT '购买订单id',
  `order_type` smallint NOT NULL DEFAULT '1' COMMENT '购买订单类型：1:order 2:积分订单',
  `uid` int NOT NULL DEFAULT '0' COMMENT '购买人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='虚拟商品卡密表';

CREATE TABLE `eb_store_integral_visit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_type` varchar(32) NOT NULL DEFAULT '' COMMENT '商品类型',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '商品分类ID',
  `type` char(50) NOT NULL DEFAULT '' COMMENT '商品类型',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `count` int NOT NULL DEFAULT '0' COMMENT '访问次数',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '备注描述',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品浏览分析表';

CREATE TABLE `eb_store_newcomer` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '商品所属：0：平台1:门店2:供应商',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型0:普通商品，1：卡密，2：优惠券，3：虚拟商品,4：次卡商品',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联门店、供应商ID',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品价格',
  `ot_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '市场价',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='新人专享商品';

CREATE TABLE `eb_store_order_writeoff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户UID',
  `oid` int NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_cart_id` int NOT NULL DEFAULT '0' COMMENT '订单商品ID',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品所属：0：平台1:门店2:供应商',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联门店、供应商ID',
  `staff_id` int NOT NULL DEFAULT '0' COMMENT '店员ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型0:普通商品，1：卡密，2：优惠券，3：虚拟商品,4：次卡商品',
  `writeoff_num` int NOT NULL DEFAULT '1' COMMENT '核销数量',
  `writeoff_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '核销金额',
  `writeoff_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '核销码',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '核销时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单核销记录';

CREATE TABLE `eb_store_product_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商品分类表ID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父id',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '商品所属：0：平台1:门店2:供应商',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联门店、供应商ID',
  `cate_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分类名称',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '路径',
  `level` tinyint(1) NOT NULL DEFAULT '0' COMMENT '等级',
  `pic` varchar(128) NOT NULL DEFAULT '' COMMENT '图标',
  `big_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '分类大图',
  `adv_pic` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告图片',
  `adv_link` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告链接',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否推荐',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE,
  KEY `is_base` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';

CREATE TABLE `eb_store_product_category_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类ID',
  `brand_id` int NOT NULL DEFAULT '0' COMMENT '品牌ID',
  `brand_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '品牌名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品分类品牌关联';

CREATE TABLE `eb_store_product_words` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型：0平台2:供应商',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '门店、供应商id',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '词',
  `color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '颜色',
  `bg_color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '背景颜色',
  `border_color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '边框颜色',
  `icon` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '图标',
  `is_show` tinyint(1) DEFAULT '0' COMMENT '是否显示',
  `sort` smallint DEFAULT '0' COMMENT '排序',
  `is_search` tinyint unsigned DEFAULT '0' COMMENT '大家都在搜',
  `is_hot` tinyint(1) DEFAULT '0' COMMENT '热词',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品搜索热词';

CREATE TABLE `eb_supplier_extract` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `supplier_id` int NOT NULL DEFAULT '0' COMMENT '供应商ID',
  `extract_type` varchar(32) NOT NULL DEFAULT 'bank' COMMENT 'bank = 银行卡 alipay = 支付宝wx=微信',
  `bank_code` varchar(32) NOT NULL DEFAULT '0' COMMENT '银行卡',
  `bank_address` varchar(256) NOT NULL DEFAULT '' COMMENT '开户地址',
  `alipay_account` varchar(64) NOT NULL DEFAULT '' COMMENT '支付宝账号',
  `wechat` varchar(15) NOT NULL DEFAULT '' COMMENT '微信号',
  `qrcode_url` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码地址',
  `extract_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '提现金额',
  `mark` varchar(512) NOT NULL DEFAULT '',
  `balance` decimal(8,2) unsigned NOT NULL DEFAULT '0.00',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '-1 未通过 0 审核中 1 已提现',
  `pay_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 未转账 1 已转账',
  `supplier_mark` varchar(255) NOT NULL DEFAULT '' COMMENT '供应商备注',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `fail_msg` varchar(128) NOT NULL DEFAULT '' COMMENT '无效原因',
  `fail_time` int unsigned NOT NULL DEFAULT '0',
  `voucher_image` varchar(256) NOT NULL DEFAULT '' COMMENT '转账凭证',
  `voucher_title` varchar(256) NOT NULL DEFAULT '' COMMENT '转账说明',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `extract_type` (`extract_type`),
  KEY `status` (`status`),
  KEY `add_time` (`add_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='供应商提现表';

CREATE TABLE `eb_supplier_flowing_water` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `supplier_id` int NOT NULL DEFAULT '0' COMMENT '供应商ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `order_id` varchar(20) NOT NULL DEFAULT '' COMMENT '交易单号',
  `link_id` varchar(50) NOT NULL DEFAULT '' COMMENT '关联订单',
  `pm` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `number` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '明细',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '交易类型(1:支付订单,2:退款订单)',
  `pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式',
  `pay_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `total_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '订单总金额',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '平台备注',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '供应商备注',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `trade_time` int NOT NULL DEFAULT '0' COMMENT '交易时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='供应商流水表';

CREATE TABLE `eb_supplier_transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `supplier_id` int NOT NULL DEFAULT '0' COMMENT '供应商ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `order_id` varchar(20) NOT NULL DEFAULT '' COMMENT '交易单号',
  `link_id` varchar(50) NOT NULL DEFAULT '' COMMENT '关联订单',
  `pm` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '交易类型(1:支付订单,2:退款订单)',
  `pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式',
  `pay_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `total_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '订单总金额',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '平台备注',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '供应商备注',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `trade_time` int NOT NULL DEFAULT '0' COMMENT '交易时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='供应商交易表';

CREATE TABLE `eb_system_form` (
  `id` int NOT NULL AUTO_INCREMENT,
  `version` varchar(255) NOT NULL DEFAULT '' COMMENT '版本号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '表单名称',
  `cover_image` varchar(255) NOT NULL DEFAULT '' COMMENT '封面图',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '表单数据',
  `default_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '默认数据',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否使用',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统表单数据表';

CREATE TABLE `eb_system_form_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户UID',
  `system_form_id` varchar(255) NOT NULL DEFAULT '' COMMENT '表单名称',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '收集数据来源：1订单',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联数据来源ID',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '收集数据',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='表单收集数据记录表';

CREATE TABLE `eb_system_sign_reward` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型，0连续签到奖励，1累计签到奖励',
  `days` int NOT NULL DEFAULT '0' COMMENT '天数',
  `point` int NOT NULL DEFAULT '0' COMMENT '赠送积分',
  `exp` int NOT NULL DEFAULT '0' COMMENT '赠送经验',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='系统签到奖励表';

CREATE TABLE `eb_system_timer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '定时器名称',
  `mark` varchar(50) NOT NULL COMMENT '标识',
  `type` tinyint(1) NOT NULL COMMENT '周期状态 1=N分钟 2=N小时 3=每小时 4=每天 5=N天 6=每星期 7=每月 8=每年',
  `title` varchar(255) DEFAULT NULL COMMENT '任务说明',
  `is_open` tinyint(1) DEFAULT '0' COMMENT '是否开启',
  `cycle` varchar(255) DEFAULT NULL COMMENT '执行周期',
  `last_execution_time` int DEFAULT '0' COMMENT '上次执行时间',
  `update_execution_time` int DEFAULT '0' COMMENT '修改时间',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COMMENT='定时器';

CREATE TABLE `eb_system_user_apply` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '申请类型1:门店2:供应商',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联商户',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `system_name` varchar(30) NOT NULL DEFAULT '' COMMENT '商户名称',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '多图',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '处理状态0未处理，1通过 ，2未通过',
  `fail_msg` varchar(255) NOT NULL DEFAULT '' COMMENT '未通过原因',
  `is_del` tinyint NOT NULL DEFAULT '0' COMMENT '删除状态 1删除 ，0未删除',
  `status_time` int NOT NULL DEFAULT '0' COMMENT '审核时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户申请表';

CREATE TABLE `eb_user_bank` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0',
  `real_name` varchar(255) NOT NULL DEFAULT '',
  `bank_card` varchar(255) NOT NULL DEFAULT '',
  `bank_address` varchar(255) NOT NULL DEFAULT '',
  `bank_name` varchar(255) NOT NULL DEFAULT '',
  `bank_mobile` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户银行卡表';

CREATE TABLE `eb_user_box` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(255) DEFAULT NULL,
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单表关联ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类ID',
  `cate_name` varchar(255) DEFAULT '' COMMENT '分类名称',
  `cate_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '盲盒价格',
  `product_id` int DEFAULT '0' COMMENT '商品ID',
  `product_name` varchar(255) DEFAULT '' COMMENT '商品名称',
  `product_image` varchar(255) DEFAULT NULL COMMENT '商品图片',
  `product_price` decimal(10,2) DEFAULT '0.00' COMMENT '商品价格',
  `brand_id` int DEFAULT '0' COMMENT '品牌ID',
  `freight_money` decimal(10,2) DEFAULT '0.00' COMMENT '运费金额',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=待操作,1=已回收,2=待发货,3=已发货',
  `pay_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=待支付,1=已支付',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '支付时间',
  `createtime` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updatetime` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `huanqu_id` int NOT NULL DEFAULT '0' COMMENT '换取表关联ID',
  `huanqu_unique` varchar(50) DEFAULT '' COMMENT '兑换码',
  `real_name` varchar(255) DEFAULT NULL,
  `user_phone` varchar(50) DEFAULT NULL,
  `user_address` varchar(255) DEFAULT NULL,
  `pay_type` varchar(255) DEFAULT '' COMMENT '支付类型',
  `is_tanchu` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已弹出',
  `is_jiqiren` tinyint(1) NOT NULL DEFAULT '0',
  `tag` int NOT NULL DEFAULT '0' COMMENT '商品标签',
  `rand_num` int NOT NULL DEFAULT '0' COMMENT '随机数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=972839 DEFAULT CHARSET=utf8mb3 COMMENT='用户盲盒表';

CREATE TABLE `eb_user_choujiang_set` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `cate_id` int NOT NULL DEFAULT '0',
  `pid` int NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_image` varchar(255) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `createtime` int NOT NULL DEFAULT '0',
  `updatetime` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='盲盒中奖设置表';

CREATE TABLE `eb_user_jiqiren` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nickname` varchar(255) DEFAULT NULL,
  `avatars` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `add_time` int DEFAULT NULL,
  `login_city` varchar(255) DEFAULT '' COMMENT '地址',
  `is_moren` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是默认头像',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2208 DEFAULT CHARSET=utf8mb3 COMMENT='机器人用户表';

CREATE TABLE `eb_user_jiqiren_touxiang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `images` varchar(255) DEFAULT NULL,
  `add_time` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=393 DEFAULT CHARSET=utf8mb3 COMMENT='机器人头像表';

CREATE TABLE `eb_user_manghe_set` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `cate_id` int NOT NULL DEFAULT '0',
  `pid` int NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_image` varchar(255) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `createtime` int NOT NULL DEFAULT '0',
  `updatetime` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='盲盒中奖设置表';

CREATE TABLE `eb_user_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `relation_id` int unsigned NOT NULL DEFAULT '0' COMMENT '关联ID',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '类型(收藏(collect）、点赞(like))',
  `category` varchar(32) NOT NULL DEFAULT '' COMMENT '某种类型的商品(普通商品、秒杀商品、文章)',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `type` (`type`) USING BTREE,
  KEY `category` (`category`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=900 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品点赞和收藏表';

CREATE TABLE `eb_video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型：0:平台1:门店2:用户',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联平台管理门店ID、用户UID',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '封面图',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '简介',
  `video_url` varchar(255) NOT NULL DEFAULT '' COMMENT '视频地址',
  `product_id` longtext COMMENT '关联商品ids',
  `like_num` int NOT NULL DEFAULT '0' COMMENT '点赞数量',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `play_num` int NOT NULL DEFAULT '0' COMMENT '浏览播放数量',
  `comment_num` int NOT NULL DEFAULT '0' COMMENT '评论数量',
  `share_num` int NOT NULL DEFAULT '0' COMMENT '分享数量',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `is_recommend` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否推荐',
  `is_verify` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否审核：-2强制下架-1未通过0未审核1:通过',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='短视频表';

CREATE TABLE `eb_video_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型：0:平台1:门店2:用户',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '发布视频门店ID、用户UID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级回复id',
  `video_id` int NOT NULL DEFAULT '0' COMMENT '视频id',
  `uid` int NOT NULL DEFAULT '0',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '用户名称',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '用户头像',
  `like_num` int NOT NULL DEFAULT '0' COMMENT '点赞数量',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '评论内容',
  `ip` varchar(32) NOT NULL DEFAULT '' COMMENT '评论ip',
  `city` varchar(255) NOT NULL DEFAULT '' COMMENT '城市',
  `is_reply` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否回复',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `video_id` (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='短视频评价回复表';

CREATE TABLE `eb_wechat_qrcode` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码名称',
  `image` varchar(500) NOT NULL DEFAULT '' COMMENT '二维码图片',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `label_id` varchar(32) NOT NULL DEFAULT '' COMMENT '标签id',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '回复类型',
  `content` text COMMENT '回复内容',
  `data` text COMMENT '发送数据',
  `follow` int NOT NULL DEFAULT '0' COMMENT '关注人数',
  `scan` int NOT NULL DEFAULT '0' COMMENT '扫码人数',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `continue_time` int NOT NULL DEFAULT '0' COMMENT '有效期',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '到期时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='二维码表';

CREATE TABLE `eb_wechat_qrcode_cate` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `cate_name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道码分类名称',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COMMENT='二维码类型表';

CREATE TABLE `eb_wechat_qrcode_record` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `qid` int NOT NULL DEFAULT '0' COMMENT '渠道码id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `is_follow` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否关注',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '扫码时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='渠道码扫码记录表';


-- 上面这些表当年是 utf8mb3，与 crmeb.sql 的 utf8mb4 混用会在联表/比较时报 Illegal mix of collations。
-- 新库都是空表，直接转码，秒级完成：



-- 下面这些表当年建在 utf8mb3 上，与 crmeb.sql 的 utf8mb4 混用，联表或字符串比较时会报 Illegal mix of collations。
-- 新库是空表，直接转码，秒级完成；如果你是从旧库整库迁过来，先备份再跑这段。
ALTER TABLE `eb_box_order` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_activity_relation` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_delivery_order` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_brand` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_order_status_kaijiang` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_huanqu_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_huanqu_log_unique` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_huanqu_set_price` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_huanqu_set_zhong` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_kaijiang_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_kaijiang_shaidan` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_product_recovery_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_store_integral_visit` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_supplier_extract` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_supplier_flowing_water` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_supplier_transactions` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_system_sign_reward` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_system_timer` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_system_user_apply` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_user_box` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_user_choujiang_set` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_user_jiqiren` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_user_jiqiren_touxiang` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_user_manghe_set` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_wechat_qrcode` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_wechat_qrcode_cate` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `eb_wechat_qrcode_record` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1;
