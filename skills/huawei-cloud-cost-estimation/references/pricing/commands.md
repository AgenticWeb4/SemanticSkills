# 命令合同（RFQ 询价）

每个 op：**contract** + **CLI 模板**。事实/维度看 `semantic/*.yml`。数组用 dot notation（`--product_infos.1.*`）；输出 `--cli-output=json`；字典分页默认 `--limit=10 --offset=0`，每命令 ≤3 页。

## Universal Traps（每次询价必看）

1. **数组仅 dot notation** — JSON 串 / `[...]` KooCLI 不识别。
2. **询价 API 无分页** — `ListRateOnPeriodDetail` / `ListOnDemandResourceRatings` 多项一次放进 `product_infos.N.*`。
3. **code 大小写敏感** — `cloud_service_type` / `resource_type` / `region` / spec 用维度查询原文，不小写化、不拼接。
4. **解析链** — `ListServiceResources` 定 `resource_type`（多候选则问）→ `ListResourceSpecs` 定 `resource_spec` → 按需再 `ListUsageTypes --resource_type_code=<resource_type>` 定 `usage_factor` → 询价。禁止默认 `Duration`/小时。
5. **Specs 有行 ≠ 可询价** — 取值只认当次 `ListResourceSpecs`；`CBC.6006`/`CBC.6050` 回退改 type / factor / measure，同度量类型只换一次，禁止矩阵穷举。
6. **容量≠线性盘** — `resource_size`+`size_measure_id` 仅下表三类；容量型（如对象存储）把量写进 `usage_value`，勿套 EVS 线性假设。`usage_measure_id`：`Duration`→时长类（常 `4`=小时）；`size*`/容量名→流量/容量类（常 `10`=GB），对齐 `ListMeasureUnits`。

---

## rfq_quote_execution

### `BSS/ListRateOnPeriodDetail` —— 包年/包月询价

> **method**: POST · **safety**: readonly · **entities**: `RFQ_Header`, `RFQ_Line` · **pagination**: n/a · **doc**: [bcloud_01002](https://support.huaweicloud.com/api-bpconsole/bcloud_01002.html)
> **required**: `project_id` + 每行 `id` / `cloud_service_type` / `resource_type` / `resource_spec` / `region` / `period_type` / `period_num` / `subscription_num`
> **conditional**: `linear_product` → `resource_size` + `size_measure_id`

混合产品（ECS + EVS + 带宽）：

```bash
hcloud BSS ListRateOnPeriodDetail \
  --project_id=<project_id> \
  --product_infos.1.id=1 \
  --product_infos.1.cloud_service_type=hws.service.type.ec2 \
  --product_infos.1.resource_type=hws.resource.type.vm \
  --product_infos.1.resource_spec=c6.2xlarge.2.linux \
  --product_infos.1.region=cn-north-1 \
  --product_infos.1.period_type=2 --product_infos.1.period_num=1 --product_infos.1.subscription_num=1 \
  --product_infos.2.id=2 \
  --product_infos.2.cloud_service_type=hws.service.type.ebs \
  --product_infos.2.resource_type=hws.resource.type.volume \
  --product_infos.2.resource_spec=GPSSD \
  --product_infos.2.region=cn-north-1 \
  --product_infos.2.resource_size=40 --product_infos.2.size_measure_id=17 \
  --product_infos.2.period_type=2 --product_infos.2.period_num=1 --product_infos.2.subscription_num=1 \
  --product_infos.3.id=3 \
  --product_infos.3.cloud_service_type=hws.service.type.vpc \
  --product_infos.3.resource_type=hws.resource.type.bandwidth \
  --product_infos.3.resource_spec=19_bgp \
  --product_infos.3.region=cn-north-1 \
  --product_infos.3.resource_size=40 --product_infos.3.size_measure_id=15 \
  --product_infos.3.period_type=2 --product_infos.3.period_num=1 --product_infos.3.subscription_num=1 \
  --cli-region=cn-north-1 --cli-output=json
```

| 字段 | 类型 | 取值 | 备注 |
| --- | --- | --- | --- |
| `period_type` | int | 0 天 / 2 月 / 3 年 / 4 小时 | 包年包月通常 2 或 3 |
| `period_num` | int | 1..214783647 | 与 `period_type` 配合 |
| `subscription_num` | int | 1..10000 | 询价数量 |
| `size_measure_id` | int | 仅线性三类，见表 | 见 linear 表 |
| `fee_installment_mode` | string | HALF_PAY / ZERO_PAY / NA | 暂仅 CloudPond |

### `BSS/ListOnDemandResourceRatings` —— 按需询价

> **method**: POST · **safety**: readonly · **entities**: `RFQ_OnDemand_Header`, `RFQ_OnDemand_Line` · **pagination**: n/a · **doc**: [bcloud_01001](https://support.huaweicloud.com/api-bpconsole/bcloud_01001.html)
> **required**: `project_id` + 每行 `id` / `cloud_service_type` / `resource_type` / `resource_spec` / `region` / `usage_factor` / `usage_value` / `usage_measure_id` / `subscription_num`
> **conditional**: `linear_product` → `resource_size` + `size_measure_id`
> **optional**: `inquiry_precision`（0 默认 6 位 / 1 全 10 位）

混合按需（ECS + EVS + 按流量带宽）：

```bash
hcloud BSS ListOnDemandResourceRatings \
  --project_id=<project_id> \
  --product_infos.1.id=1 \
  --product_infos.1.cloud_service_type=hws.service.type.ec2 \
  --product_infos.1.resource_type=hws.resource.type.vm \
  --product_infos.1.resource_spec=c3.3xlarge.2.linux \
  --product_infos.1.region=cn-north-1 \
  --product_infos.1.usage_factor=Duration --product_infos.1.usage_value=2 --product_infos.1.usage_measure_id=4 \
  --product_infos.1.subscription_num=1 \
  --product_infos.2.id=2 \
  --product_infos.2.cloud_service_type=hws.service.type.ebs \
  --product_infos.2.resource_type=hws.resource.type.volume \
  --product_infos.2.resource_spec=SSD \
  --product_infos.2.region=cn-north-1 \
  --product_infos.2.resource_size=10 --product_infos.2.size_measure_id=17 \
  --product_infos.2.usage_factor=Duration --product_infos.2.usage_value=2 --product_infos.2.usage_measure_id=4 \
  --product_infos.2.subscription_num=1 \
  --product_infos.3.id=3 \
  --product_infos.3.cloud_service_type=hws.service.type.vpc \
  --product_infos.3.resource_type=hws.resource.type.bandwidth \
  --product_infos.3.resource_spec=12_sbgp \
  --product_infos.3.region=cn-north-1 \
  --product_infos.3.resource_size=1 --product_infos.3.size_measure_id=15 \
  --product_infos.3.usage_factor=upflow --product_infos.3.usage_value=4 --product_infos.3.usage_measure_id=10 \
  --product_infos.3.subscription_num=1 \
  --cli-region=cn-north-1 --cli-output=json
```

| 字段 | 类型 | 取值 | 备注 |
| --- | --- | --- | --- |
| `usage_factor` | string | 当次 `ListUsageTypes` 的 `code` | 禁止默认 Duration |
| `usage_value` | number | - | 询价标量；容量型常为 GB·时长积或容量量 |
| `usage_measure_id` | int | 对齐 `ListMeasureUnits` | 见 Trap #6 |
| `inquiry_precision` | int | 0 默认 / 1 全 10 位 | 控制精度 |

---

## response_contract（报价怎么读）

只读当次响应，**不臆造折扣**。`measure_id=1`=元；`currency=CNY`（空=人民币）；`id` 回映射请求行。默认官网价；有折扣才附折后。分项 `official_website_amount` 之和 = 总额；on-demand 结果已含 `usage_value`，不再二次乘。

| API | 官网价 | 折后（有则报） |
| --- | --- | --- |
| `ListRateOnPeriodDetail` | `official_website_rating_result.official_website_amount`；分项同对象 `.product_rating_results[]` | `optional_discount_rating_results[]` 取 `best_offer==1` 的 `amount` / `discount_amount` / `discount_name` |
| `ListOnDemandResourceRatings` | 根级 `official_website_amount`；分项 `product_rating_results[]` | `discount_amount>0` 时读 `amount` / `discount_amount` |

---

## dimension_lookup

| 操作 | 用途 | 必填 | 分页 |
| --- | --- | --- | --- |
| `BSS/ListServiceTypes` | `cloud_service_type` | - | limit/offset |
| `BSS/ListServiceResources` | 服务→`resource_type` | `service_type_code` | limit/offset |
| `BSS/ListUsageTypes` | 按需 `usage_factor` | **`resource_type_code`** | limit/offset |
| `BSS/ListMeasureUnits` | `usage_measure_id` / size 单位 | - | none |
| `BSS/ListResourceTypes` | 翻译 resource_type | - | limit/offset |
| `BSS/ListConversions` | 度量进制 | - | none |

```bash
hcloud BSS ListServiceTypes --service_type_name=弹性云服务器 \
  --cli-region=cn-north-1 --cli-output=json --limit=10 --offset=0
hcloud BSS ListServiceResources --service_type_code=hws.service.type.ec2 \
  --cli-region=cn-north-1 --cli-output=json --limit=10 --offset=0
hcloud BSS ListUsageTypes --resource_type_code=hws.resource.type.vm \
  --cli-region=cn-north-1 --cli-output=json --limit=100 --offset=0
hcloud BSS ListMeasureUnits --cli-region=cn-north-1 --cli-output=json
```

---

## resource_spec_lookup

### `BSS/ListResourceSpecs` —— 规格解析唯一路径

> **method**: POST · **safety**: readonly · **entities**: `Dim_ResourceSpec` · **pagination**: marker/limit · **doc**: [qct_00008](https://support.huaweicloud.com/api-oce/qct_00008.html)
> **required**: `cloud_service_type` / `resource_type` / `region_code` / `charge_mode`（1 包年包月 / 3 按需）
> **optional**: `filters.[N].key=RESOURCE_SPEC` + `filters.[N].value`、`marker` + `limit`

- `marker`+`limit` 同用；首页无 `marker`；翻页用 `page_info.next_marker`。
- `charge_mode`/`region_code` 与询价 line 一致；返回值禁再拼 OS 后缀。
- 有规格线索必须带 `filters`；`limit=100`；3 页未收敛则停并让用户选；429 等 2s 重试一次。
- 候选取 `cloud_service_basics[].resource_spec`，复述用 `resource_spec_name`。

```bash
hcloud BSS ListResourceSpecs --charge_mode=1 \
  --cloud_service_type=hws.service.type.ec2 --resource_type=hws.resource.type.vm \
  --region_code=cn-north-4 \
  --filters.1.key=RESOURCE_SPEC --filters.1.value=c6.2xlarge \
  --limit=100 --cli-region=cn-north-1 --cli-output=json
```

### 线性产品配对（仅此三类可填 `resource_size`）

| `resource_type` | `size_measure_id` | 单位 |
| --- | --- | --- |
| `hws.resource.type.volume` | 17 | GB |
| `hws.resource.type.bandwidth` | 15 | Mbps |
| `hws.resource.type.share_bandwidth` | 15 | Mbps |

---

## scope_resolve

```bash
hcloud IAM KeystoneListAuthProjects --cli-region=cn-north-1 --cli-output=json
hcloud IAM KeystoneListProjects --domain_id=<domain_id> --cli-region=cn-north-1 --cli-output=json
```

伙伴代客户询价：伙伴 Token 置换客户 Token 后 `KeystoneListAuthProjects` 取 region 对应 `project_id`；见 `iam-policies.md`。
