# 叼毛网易云模块远程控制MAC版

## 介绍
- 功能：状态栏显示歌词，快捷键切歌
- 服务端中转方案，mac 客户端作为 client 的实现版本
- 借助`hammerspoon`实现，需要先安装，参考：[https://sspai.com/post/53992](https://sspai.com/post/53992)

## 集成步骤
- 安装好`hammerspoon`后，`cd ~/.hammerspoon/`
- 拉代码`git clone https://github.com/Blankeer/diaomao163_mac`
- 修改或增加`init.lua`，加入`require "diaomao163_mac.controller"`
- 修改`controller.lua`文件顶部的`channel`控制码，修改适合自己的快捷键
- reload 即可生效

## 最佳实践
- 借助[Dozer](https://github.com/Mortennn/Dozer)，隐藏状态栏多余图标，固定显示歌词
- 借助[Karabiner](https://karabiner-elements.pqrs.org/)改键位，将键盘左侧大小写切换映射为`{"ctrl","cmd","shift","alt"}`这4种组合

## 快捷键
- 快捷键映射见`controller.lua`最下面的注释
- 具体快捷键可以任意修改，参见注释说明

