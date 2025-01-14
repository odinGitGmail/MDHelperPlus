local addonName, mdhelper = ...
local mcore = mdhelper.Core

--[[
mdhelper.Core  基础lua相关方法
]] --

----------------------------------------------------------------------------------------------------------------------
---private functions
---排序table
---获取table的key 仅获取当前第一层key 并不递归
---按照排序方式获得排序后的key集合
---循环排序后的key集合 在table中获取对应的value，即获取到排序后的value
-- 获取table所有的key （仅第一级 不递归）
local function getKeys(tb)
    local ks = {}
    for k, v in pairs(tb) do table.insert(ks, k) end
    return ks
end

----------------------------------------------------------------------------------------------------------------------
---desc排序表
function mcore.sortTableDescending(tb)
    local ks = getKeys(tb)
    table.sort(ks, function(a, b) return a > b end)
    return ks
end

----------------------------------------------------------------------------------------------------------------------
---asc排序表
function mcore.sortTable(tb)
    local ks = getKeys(tb)
    table.sort(ks, function(a, b) return a < b end)
    return ks
end

----------------------------------------------------------------------------------------------------------------------
---循环表结构
function mcore.loopTable(tb)
    for key, value in pairs(tb) do
        if type(value) == "table" then
            mcore.loopTable(value)
        else
            print("key", key, "value", value)
        end
    end
end

----------------------------------------------------------------------------------------------------------------------
---判断元素是否在数组中存在
function mcore.containsElement(array, element)
    for i, value in pairs(array) do
        if string.format(element) == string.format(value) then
            return true
        end
    end
    return false
end
