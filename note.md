```
-e "C:\Users\zsy\Desktop\Project\demo\flightFight\.publish\iphone" -i "C:\Users\zsy\Desktop\Project\demo\flightFight\.publish\iphone"
```

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
