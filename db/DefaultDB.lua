local AddonName, mdhelper = ...
--  插件中部分代码来源 CN-无尽之海-简繁丶www.douyu.com/323075 的addui插件
mdhelper = mdhelper or {}
mdhelper.UI = {}
mdhelper.UI.Func = {}
mdhelper.UI.components = {}
mdhelper.UI.components.Func = {}
mdhelper.Core = {}
mdhelper.Spells = {}


mdhelper.Career = {
    ["deathknight"] = "死亡骑士",
    ["demonhunter"] = "恶魔猎手",
    ["druid"] = "德鲁伊",
    ["hunter"] = "猎人",
    ["mage"] = "法师",
    ["monk"] = "武僧",
    ["paladin"] = "圣骑士",
    ["priest"] = "牧师",
    ["rogue"] = "盗贼",
    ["shaman"] = "萨满",
    ["warlock"] = "术士",
    ["warrior"] = "战士",
    ["evoker"] = "唤魔师",
}

-- 需打断法术
mdhelper.interruptSpellArray = {
    -- test me 暴风雪
    -- "190356",
    --"11366",

    --塞兹迷雾仙林
    "322938", -- 收割灵魂
    "323057", -- 灵魂之箭
    "324776", -- 木棘外壳
    "324914", -- 滋养森林
    "326046", -- 模拟抗性
    "340544", -- 再生鼓舞

    --通灵战潮
    "334748", -- 排干体液
    "320462", -- 通灵箭
    "327127", -- 修复血肉
    "320822", -- 最终交易
    "324293", -- 刺耳尖啸
    "328667", -- 寒冰箭雨
    "338353", -- 淤液喷撒

    --围攻伯拉勒斯
    "256957", -- 防水甲壳
    "257063", -- 盐渍飞弹
    "454440", -- 恶臭喷吐
    "272581", -- 水箭
    "272571", -- 窒息之水

    --矶石宝库
    "426283", -- 弧形虚空
    "426308", -- 虚空感染
    "454440", -- 恶臭喷吐
    "449455", -- 咆哮恐惧
    "429109", -- 愈合金属
    "429110", -- 合金箭矢
    "429422", -- 岩石箭
    "445207", -- 穿透哀嚎
    "429545", -- 噤声齿轮

    --破晨号
    "450756", -- 深渊嚎叫
    "431303", -- 暗影箭
    "431309", -- 诱捕暗影
    "451113", -- 蛛网箭

    --格瑞姆巴托
    "451871", -- 大地震颤
    "451261", -- 大地之箭
    "76369",  -- 暗影烈焰箭
    "76711",  -- 灼烧心智
    "451224", -- 暗影烈焰笼罩

    --回响之城
    "434786", -- 蛛网箭
    "434793", -- 共振弹幕
    "434802", -- 惊惧尖鸣
    "436322", -- 毒液箭
    "448248", -- 恶臭齐射
    "433845", -- 爆发蛛网
    "433841", -- 毒液箭雨

    --千丝之城
    "443427", -- 蛛网箭
    "443430", -- 流丝缠缚
    "443433", -- 扭曲思绪
    "442536", -- 阴织冲击
    "452162", -- 愈合之网
    "446086", -- 虚空之波

    -- 迦拉克隆的陨落
    "412012", "412044",           --时光斩
    "411994",                     --时光融蚀
    "415435",                     --永恒之箭
    "415770",                     --永恒乱箭
    "412806", "412810",           --荒芜喷呕
    "411958", "416254", "412285", --砂石箭

    -- 迦拉克隆的崛起
    "413606", "413607", "400180", --侵蚀齐射
    "417481",                     --时序错位
    "418200",                     --永恒燃烧
    "418202",                     --时光冲击

    -- 阿塔达萨
    "253517",           --愈合真言
    "253583", "253654", --火焰附魔
    "253562",           --野火
    "256138",           --狂热打击
    "255041",           --惊骇尖啸
    "252923",           --剧毒冲击
    "250368", "259572", --恶毒臭气
    "250096",           --毁灭痛苦

    -- 潮汐王座
    "426731", "428263", --水箭
    "76820",            --妖术
    "76813",            --治疗波
    "426768",           --闪电箭

    -- 黑心林地
    "200630", "200631", --挫志尖啸
    "200642",           --绝望
    "204243",           --折磨之眼
    "201837",           --暗影箭
    "201839", "201842", --隔绝诅咒

    -- 庄园
    "267824", --灵魂创伤
    "263959", --灵魂箭雨
    "264024", --灵魂之箭
    "265368", --灵魂防御
    "264050", --被感染的荆棘
    "260698", --boss 灵魂之箭
    "260699", --boss 灵魂之箭
    "260696", --boss 毁灭箭
    "260700", --boss 毁灭箭
    "264520", --切裂蛇斩
    "265876", --毁灭箭雨
    "268278", --剧痛之弦
    "266225", --黑暗闪电

    -- 黑鸭堡垒
    "199663", --灵魂冲击
    "200256", --相位爆炸
}

-- 无法打断需要提醒开启减伤的法术
mdhelper.avoidanceSpellArray = {
    -- test me 暴风雪
    "190356",
    --"11366",

    -- 破晨号
    "451119", -- 深渊轰击
    "451222", -- 虚空奔袭

    -- 仙林
    "322486", -- 过度生长
    "463248", -- 排斥
    "324986", -- 纱雾噬咬
    "325223", -- 心能注入
    "451395", -- 心能注入

    -- 回响
    "434802", -- 感染

    -- 通灵
    "334747", -- 投掷血肉
    "323496", -- 切肉飞刀
}


mdhelper.defaults = {
    mdhUser = {
        interrupt = true,
        avoidance = true,
        interruptProgressBar = {
            show = false,
            width = 300,
            maxWidth = 400,
            height = 40,
            maxHeight = 60,
            text = "00:00",
            point = "CENTER",
            relativePoint = "CENTER",
            offx = 0,
            offy = 0,
            drag = false,
        }
    },
    playerInfo = {
        interruptSpellID = "",
    },
    addonData = {
        interruptSpellArray = mdhelper.interruptSpellArray,
        avoidanceSpellArray = mdhelper.avoidanceSpellArray
    }
}

mdhelper.mdMaps = {
    ["1"] = { name = "塞兹迷雾的仙林", enable = true },
    ["2"] = { name = "通灵战潮", enable = true },
    ["3"] = { name = "格瑞姆巴托", enable = true },
    ["4"] = { name = "围攻伯拉勒斯", enable = true },
    ["5"] = { name = "千丝之城", enable = true },
    ["6"] = { name = "回响之城", enable = true },
    ["7"] = { name = "矶石宝库", enable = true },
    ["8"] = { name = "破晨号", enable = true },
    ["9"] = { name = "阿塔达萨", enable = true },
}



----------------------------------------------------------------------------------------------------------------------
---初始化配置
----------------------------------------------------------------------------------------------------------------------
local function InitializeDB(defaultTables, globalDb)
    -- 如果插件的配置表不存在，则初始化
    if not globalDb then
        globalDb = {} -- 创建配置表
    end

    for key, value in pairs(defaultTables) do
        if type(value) == "table" then
            if not globalDb[key] then
                globalDb[key] = {}
            end
            InitializeDB(value, globalDb[key])
        else
            if globalDb[key] == nil then
                globalDb[key] = value
            end
        end
    end
end

-- 注册事件监听，确保在插件加载时初始化配置
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, addonName)
    if addonName == "MDHelperPlus" then
        mdhelperDB = mdhelperDB or {}
        InitializeDB(mdhelper.defaults, mdhelperDB) -- 加载配置
    end
end)
