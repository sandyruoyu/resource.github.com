
--更新列表配置文件
local manifest = "Manifests/project.manifest"
--本地更新包存储目录
local storagePath = "upd"
local savepath = cc.FileUtils:getInstance():getWritablePath() .. storagePath


local gameWidth = 960
local gameHeight = 640
-- initialize director
local director = cc.Director:getInstance()
--turn on display FPS
--director:setDisplayStats(true)
--set FPS. the default value is 1.0/60 if you don't call this
director:setAnimationInterval(1.0 / 50)
director:getOpenGLView():setDesignResolutionSize(gameWidth, gameHeight, 3)
local size  = cc.Director:getInstance():getWinSize()
local scalex = size.width/gameWidth
local scaley = size.height/gameHeight

-------------------------------------
--  AssetsManagerEx1 Test
-------------------------------------
local AMTestScene1 = {}
AMTestScene1.__index = AMTestScene1

function AMTestScene1.create()

    local layer  = cc.Layer:create()

    local am = nil

    local function onEnter()
        local sprite = cc.Sprite:create("splash.png")
        layer:addChild(sprite)
        sprite:setScale(scalex,scaley)
        sprite:setPosition(cc.p(size.width/2, size.width/2))

        local ttfConfig = {}
        ttfConfig.fontFilePath = "fonts/Marker Felt.ttf"
        ttfConfig.fontSize = 40

        local  progress = cc.Label:createWithTTF(ttfConfig, "0%", cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
        progress:setPosition(cc.p(size.width/2, size.width/2 + 50))
        layer:addChild(progress)
        am = cc.AssetsManagerEx:create(manifest, savepath)
        am:retain()

        if not am:getLocalManifest():isLoaded() then
            print("Fail to update assets, step skipped.")
            updator_has_updated = true
--            AMTestScene1.reloadModule()
--            require("AppEntry")

        else
            local function onUpdateEvent(event)
                local eventCode = event:getEventCode()
                if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                    print("No local manifest file found, skip assets update.")
--                    AMTestScene1.reloadModule()
--                    require("AppEntry")

                elseif  eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                    local assetId = event:getAssetId()
                    local percent = event:getPercent()
                    local strInfo = ""

                    if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                        strInfo = string.format("Version file: %d%%", percent)
                    elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                        strInfo = string.format("Manifest file: %d%%", percent)
                    else
                        strInfo = string.format("%d%%", percent)
                    end
                    progress:setString(strInfo)
                elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                    eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                    print("Fail to download manifest file, update skipped.")
--                    AMTestScene1.reloadModule()
--                    require("AppEntry")

                elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                    eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                    print("Update finished.")

                    --目录显示标签
                    local strpath = ""
                    local tmp = ""
                    local spath = cc.FileUtils:getInstance():getSearchPaths()
                    for i=1, #spath do 
                        tmp = string.format("%d %s\n", i,spath[i])
                        strpath = strpath..tmp
                    end

                    print(strpath)
                    local  labPath = cc.Label:createWithTTF(ttfConfig, strpath, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
                    labPath:setPosition(cc.p(size.width/2, size.height/5))
                    labPath:setScale(0.5,0.5)
                    layer:addChild(labPath)
--                    AMTestScene1.reloadModule()
                    require(savepath.."/AppEntry")
--                    require("/data/data/org.cocos2dx.hotUpdateT01/files/upd/src/AppEntry")


                elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                    print("Asset ", event:getAssetId(), ", ", event:getMessage())
--                    AMTestScene1.reloadModule()
--                    require("AppEntry")

                end
            end
            local listener = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
            cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)

            am:update()
        end
    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        elseif "exit" == event then
            am:release()
        end
    end
    layer:registerScriptHandler(onNodeEvent)

    return layer
end

function AssetsManagerExTestMain()
    local scene = cc.Scene:create()

    scene:addChild(AMTestScene1.create())
    return scene
end


local function reloadModule( moduleName )

    package.loaded[moduleName] = nil

    return require(moduleName)
end

function AMTestScene1.reloadModule()
    updator_has_updated = true 
    reloadModule("launcherScene")   
end

--启动更新
function AMTestScene1.StartUpdate()

--    if not updator_has_updated then
--        if cc.Director:getInstance():getRunningScene() then
--            cc.Director:getInstance():replaceScene(AssetsManagerExTestMain())
--        else
--            cc.Director:getInstance():runWithScene(AssetsManagerExTestMain())
--        end
--    else
--        require("AppEntry")
--    end
--

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(AssetsManagerExTestMain())
    else
        cc.Director:getInstance():runWithScene(AssetsManagerExTestMain())
    end
end

--启动下载
AMTestScene1.StartUpdate()
