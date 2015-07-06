-- 游戏启动模块
game = {}

--游戏启动
function game.startup()
  
--    local storagePath = "luaTests"
--    local cachepath = cc.FileUtils:getInstance():getWritablePath() .. storagePath
--    
--    cc.FileUtils:getInstance():addSearchPath(cachepath)
--    cc.FileUtils:getInstance():addSearchPath(cachepath .. "src")
--    cc.FileUtils:getInstance():addSearchPath(cachepath .. "res")
    

    --进入游戏主场景
    game.enterMainScene()
end

--预加载处理:耗时操作
function game.preload()

end

function game.exit()
    os.exit()
end

--进入游戏主场景
function game.enterMainScene()
    --create scene 
    
    local scene = require("GameScene")
    local gameScene = scene.create()
    gameScene:playBgMusic()
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
end
