function setup()
    local x = 100
    local y = 100
    pSimpleItem = UI_SimpleItem(nil,        -- arg[1]:		親となるUIタスクポインタ
        7000,                               -- arg[2]:		表示プライオリティ
        x, y,                               -- arg[3,4]:	表示位置
        "asset://assets/itemimage.png.imag" -- arg[5]:		表示assetのパス
    )

    TASK_StageOnly(pSimpleItem)
end

function execute(deltaT)

end

function onLeave()
    TASK_StageClear()
end

function leave()

end
