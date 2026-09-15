# 订位例：多类型参数与组合边界

受 *Beyond Objects* §13 启发的教学片段，区分承诺与可用性；以下按 [统一规格](spec-format.md) 改写，非论文转录或完整餐厅产品。保留未决，不能据此生成完整实现。

## 两个概念

```text
# concept Reserving [U, S]
## purpose
为用户保留未来使用某资源时段的承诺。
## state
reservations: set Reservation
user: Reservation -> U
slot: Reservation -> S
status: Reservation -> Status
Reservation 是本概念创建的身份；Status = booked | canceled | granted。
初态 reservations 为空；每项预约恰有一个 user、slot、status。
每个 S 最多对应一个 booked 预约；S 无字段假设。
## actions
reserve [user: U; slot: S] => [reservation: Reservation]
  requires slot 无 booked 预约
  ensures 原子创建 booked 预约并返回其身份，其他预约不变
reserve [user: U; slot: S] => [error: Conflict]
  requires slot 已有 booked 预约
  ensures 返回 Conflict（时段已占用），状态不变
cancel [reservation: Reservation] => []
  requires 预约为 booked
  ensures 仅将该预约改为 canceled
grant [reservation: Reservation] => []
  requires 预约为 booked；到场条件待定义
  ensures 仅将该预约改为 granted
## operational principle
after reserve [user: u; slot: s] => [reservation: r]
then 在预约未取消、满足到场条件时 grant [reservation: r] => []，兑现承诺。
```

论证缺口：grant 的到场输入/时间契约尚未定义；cancel/grant 在前置不满足时的调用处理未确定，不能补造错误输出。专一：承诺；独立：只用身份；熟悉：预约。只有细化前提并检验兑现行为后才可判断完整性。

```text
# concept Availability [V]
## purpose
让使用者找到指定场所当前提供的资源时段。
## state
slots: set Slot
venue: Slot -> V
offered: set Slot
Slot 是本概念创建的身份；初态 slots/offered 为空。
每个 Slot 恰属于一个 V；offered 是 slots 的子集。
## actions
publish [venue: V] => [slot: Slot]
  requires true
  ensures 创建新 Slot，关联 venue 并加入 offered，其他状态不变
withdraw [slot: Slot] => []
  requires slot 属于 slots
  ensures 从 offered 移除 slot，其他状态不变
## operational principle
after publish [venue: v] => [slot: s]
then s 在 offered 中且 venue(s)=v；withdraw [slot: s] => [] 后不再被可用时段查询返回。
## queries
_find [venue: V] => [slot: Slot]
  returns 该 venue 下全部 offered 时段，每项一行；无结果为空集合
```

`_find` 是本例选择的 query API 映射，无完成事件；也可用公开 venue/offered 关系实现查询。是否隐藏已预约时段由应用决定，Availability 不读取 Reserving。不存在的 Slot 如何处理仍属本片段未决。

## 应用目的与预约片段

应用目的：对用户选定时段给出预约承诺或明确冲突结果；完整产品还需到场兑现等场景。应用边界提供不透明 UserId/VenueId；选择时段后的请求映射为以下外部契约（无需另建 CONCEPT）：

```text
Requesting/reserve: [user: UserId; slot: Availability.Slot] => [request: RequestId]
Requesting/respond: [request: RequestId; reservation: Reserving.Reservation] => []
Requesting/respond: [request: RequestId; error: Conflict] => []
```

RequestId 标识请求；Conflict 映射 Reserving 的同名结果。每个请求只选一个 slot，根 completion 创建新 flow，后续调用继承它。

```text
# app Reservations
include Availability [VenueId]
include Reserving [UserId, Availability.Slot]
include Requesting

// flow: reserve
sync reserve
when {
  Requesting/reserve: [user: ?user; slot: ?slot] => [request: ?request]
}
then {
  Reserving/reserve: [user: ?user; slot: ?slot]
}

sync accepted
when {
  Requesting/reserve: [user: ?user; slot: ?slot] => [request: ?request]
  Reserving/reserve: [user: ?user; slot: ?slot] => [reservation: ?reservation]
}
then {
  Requesting/respond: [request: ?request; reservation: ?reservation]
}

sync rejected
when {
  Requesting/reserve: [user: ?user; slot: ?slot] => [request: ?request]
  Reserving/reserve: [user: ?user; slot: ?slot] => [error: ?error]
}
then {
  Requesting/respond: [request: ?request; error: ?error]
}
```

accepted/rejected 以输出字段区别结果，并共同匹配同一 flow 下的用户/时段；本例不等待 Availability 的 query 完成。`_find` 空集不是 error，多候选也不能直接展开成多次预约。查询 offered 不保证写入时仍可用，撤下/预约竞态必须另定策略。

## 图、子集与未决

同步图：Requesting/reserve → reserve → Reserving/reserve；accepted/rejected 各有两个合取输入，输出 Requesting/respond；查询另标读取边。

只预约已知时段的产品可以单用 Reserving；要求发现时段才可预约时，产品可声明 Reserving → Availability。类型实例化不是产品依赖的充分证据。

未决：身份认证、时段/场所归属、撤下/预约竞态、预约显示、到场条件、取消/兑现入口及运行时故障策略。三条规则只覆盖选定时段的成功/冲突片段，不能宣称完整产品已通过验证。
