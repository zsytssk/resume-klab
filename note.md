```
-e "D:\github\resume-klab\flightFight\.publish\iphone" -i "D:\github\resume-klab\flightFight\.publish\iphone"
```

```
242x132
282x153
```

## 2024-04-07 15:57:19

- @ques gameObj start end(fail|success) update pause | monsters + flight
- @ques 飞机失败动画 改变 color 闪

- @ques 计算碰撞 -> 矩形碰撞

- @ques 如何加当前时间

- @ques 如何销毁对象
- @ques 如何 pause game

- @ques 如何销毁其他创建的 monster

- @ques 如何重新开始游戏

  - 重新开始 + 开始游戏
  - 提示失败

- @ques game_over + game_success 动画

- @ques 放一个视频在文件中

### bug

- SetInterval 被意外清理了

### end

- @ques tip = "用鼠标点击屏幕移动飞机躲避怪物"
- @ques 如何刷怪 | 移动
- @ques 如何加音乐
- @ques 如何渲染飞机
- @ques 如何切换飞机皮肤
- @ques 子弹如何创建 | 如何判断 子弹击中（难）

- @ques 不用分数，直接计算时间吧

## 2024-04-06 14:03:41

- @ques 如何创建一个 loading 页面（form）

  - 怎么创建
  - 又怎么去修改

- @ques 如何获取 children

- @ques 怎么销毁元素

```
sysCommand(pForm, UI_FORM_UPDATE_NODE, "task_list1", FORM_NODE_TASK);
sysCommand(pList, UI_LIST_UPDATE_NODE, index, "label", FORM_LBL_SET_TEXT, string.format("item<%d> id<%d>", index, itemId))
sysCommand(pForm, UI_FORM_UPDATE_NODE, <node identifier>, FORM_NODE_ORDER, <priority> )
```

### end

- @ques 如何创建 button

## 2024-04-05 15:19:09

- @ques api

  - UI
    - UI_SimpleItem
    - UI_Control
    - UI_Score
  - 周期
    - setup
    - execute -> 可能是运行的周期
    - leave -> 离开
  - sysCommand
  - TASK_getProperty | TASK_setProperty
  - prop
    - scaleX
    - scaleY
    - alpha
    - color
    - rot
    - x | y
    - visible
    - order
    - asset
  - event
    - UI_CONTROL_ON_PINCH
    - UI_CONTROL_ON_DBLCLICK
    - UI_CONTROL_ON_LONGTAP
    - UI_CONTROL_SET_GROUP
    - UI_CONTROL_SET_MASK

- @ques UI_Control 是干嘛的
- @ques asset 是干嘛的
- @ques leave 是干嘛的
- @ques prop 是干嘛的
  - prop.cols
  - countclip
- bitOR ？
- ANM_X_COORD_0 ANM_SCALE_COORD_2 ANM_A_COLOR_6

- @ques 数字是怎么变化的

```
syslog(string.format("ON_PINCH"))
sysCommand(pCtrl, UI_CONTROL_ON_DBLCLICK, "onDblClick")
```

## 结构

- Libraries
- Modules
- Tasks
- Engine

## api

Doc/SysCommandList.xls

## 2024-04-04 13:38:11

- Compile the assets.

- @ques 可以在 Toboggan 直接运行项目？(没有找到 exe)

```
D:\github\resume-klab\PlaygroundOSS\Tutorial\01.SimpleItem\.publish\iphone
-e "D:\github\resume-klab\PlaygroundOSS\Tutorial\01.SimpleItem\.publish\iphone" -i "D:\github\resume-klab\PlaygroundOSS\Tutorial\01.SimpleItem\.publish\iphone"
```

## 2024-04-04 13:38:11

- @ques 如何运行项目 ？

  - 能不能在 linux 下运行 -> 好像只能 在 windows 上运行
  - Republish
  - demo 项目如何运行
    - 难道好要安装 Visual Studio solution | Visual 2010 Express 又是什么？
    - How to start a LUA Game

- @ques 要不要问问公司的人

- @ques Microsoft Visual Studio solution 是不是就是 Microsoft Visual Studio

  - Visual 2010 Express
  - GameLibraryWin32.sln
  - 。。。

- @ques 用什么语言编写

  - lua + c++ ？

- @ques 要做什么项目
  - 参照 demo 改一改就行了
  - font
