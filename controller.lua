local wsHost = 'ws://106.53.118.247:14000/ws'
local channel = '' -- 填写控制码
local menubar = hs.menubar.new()
local menuData = {}
local timer = nil
local currentMusic = nil
local status = nil

local msgCb = function(action,content)
   print("action = "..action) 
   if action=="open" then
      menubar:setTitle("已连接")
      math.randomseed(os.time())
      nickname="diaomao_mac_"..math.random(1,999)
      sendText("{\"cmd\":\"join\",\"channel\":\"diaomao163_"..channel.."\",\"nick\":\""..nickname.."\"}")
   elseif action=="received" then
      if currentMusic == nil then
         menubar:setTitle("已连接")
      end
   elseif status and status~="open" then
      menubar:setTitle("重连ing")
   end
   if content ~= nil then 
      print("content = "..content)
      msg = hs.json.decode(content)
      cmd = msg.cmd
      if cmd~="chat" then
         return
      end
      text = msg.text
      rawjson = hs.json.decode(text)
      action = rawjson.action
      if action == "music" then
         if currentMusic == nil or rawjson.musicName ~= currentMusic.musicName then
            currentMusic = rawjson
            musicName = rawjson.musicName
            singerName = rawjson.singerName
            -- menubar:setTitle("网抑云->"..musicName.."-"..singerName)
            menubar:setTitle(""..musicName.."-"..singerName)
         end
      elseif action == "lrc" then 
         text = ""
         if currentMusic~=nil then
            musicName = currentMusic.musicName
            text = musicName..":"
         end
         content = rawjson.content
         -- text = "网抑云-> "..text..content
         text = ""..text..content
         menubar:setTitle(text)
      end
   end
end
local ws = hs.websocket.new(wsHost, msgCb)


function sendText(text)
   ws:send(text)
end
function execute(action)
   text = "{\\\"action\\\":\\\""..action.."\\\"}"
   msg = "{\"cmd\":\"chat\",\"text\":\""..text.."\"}"
   print("msg="..msg)
   ws:send(msg,false)
end

function add2playList()
   -- ws:send("{\"action\":\"add2playList\",\"playListId\":1}",false)
end

local checkWs = function()
   if ws==nil or ws:status()~="open" then
      menubar:setTitle("重连ing")
      ws = hs.websocket.new(wsHost, msgCb)
   end
   status = ws:status()
end


menubar:setTitle('网抑云连接中...')

function reload()
   hs.reload()
end

-- 快捷键设置，可以任意修改为适合自己的
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "Space",  hs.fnutils.partial(execute, "playOrPause")) -- 暂停/播放
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "Left",  hs.fnutils.partial(execute, "playPre")) -- 播放上一首
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "Right",  hs.fnutils.partial(execute, "playNext")) -- 播放下一首
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "Up",  hs.fnutils.partial(execute, "volumeUp")) -- 增加音量
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "Down",  hs.fnutils.partial(execute, "volumeDown")) -- 减少音量
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "R",  hs.fnutils.partial(reload))  -- 重载当前文件
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "L",  hs.fnutils.partial(execute, "like")) -- 喜欢当前歌曲
hs.hotkey.bind({"ctrl","cmd","shift","alt"}, "K",  hs.fnutils.partial(execute, "dislike")) -- 不喜欢当前歌曲
-- hs.hotkey.bind({"ctrl","cmd","shift","alt"}, ";",  hs.fnutils.partial(add2playList, "add2playList"))

checkWs()
checkWsTimer = hs.timer.new(10, checkWs)
checkWsTimer:start()




