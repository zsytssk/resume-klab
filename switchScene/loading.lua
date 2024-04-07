function setup()
    local x = 0
    local y = 0
    pForm = UI_Form(nil,        -- arg[1]:	親となるUIタスクのポインタ
        7000,                   -- arg[2]:	基準表示プライオリティ
        x, y,                   -- arg[3,4]:	表示位置
        "asset://loading.json", -- arg[5]:	composit jsonのパス
        false                   -- arg[6]:	排他フラグ
    )

    local time = 3000;
    local start_time = 500;
    pProg = UI_ProgressBar(pForm,               -- 親UIタスクのポインタ。nilの場合は親の無い状態で生成されます。
        200,                                    -- 表示プライオリティ: 表示システム上のプライオリティ値
        190, 230,                               -- 表示座標: 親UIタスクの位置を基準として、相対座標で与えます。
        339, 100,                               -- 表示サイズ: 幅と高さ。表示素材のサイズです。0[%] 状態の画像と100[%]状態の画像は同じサイズである必要があります。
        "asset://assets/prog_h_full.png.imag",  -- 100[%]状態の画像asset名称
        "asset://assets/prog_h_empty.png.imag", -- 0[%]状態の画像asset名称
        16,                                     -- 始点pixel位置: テクスチャ画像上において、実際に表示が変わるバーの始点となる座標 (※1)
        325,                                    -- 終点pixel位置: テクスチャ画像上において、実際に表示が変わるバーの終点となる座標 (※1)
        time,                                   -- アニメーション時間 (※2)
        false                                   -- 縦方向フラグ: バーの成長方向が垂直方向であればtrue, 水平方向であれば false (※1)
    --"asset://barfilter.png.imag"
    )

    prop = TASK_getProperty(pProg)
    prop.value = 0.0
    TASK_setProperty(pProg, prop)


    TASK_StageOnly(pForm)

    pIT1 = UTIL_IntervalTimer(
        1,          --<timerID>
        "onStart",  --"<callback>"
        start_time, --<interval>
        false       --[ , <repeat> ]
    )

    pIT2 = UTIL_IntervalTimer(
        2,                 --<timerID>
        "onAniEnd",        --"<callback>"
        time + start_time, --<interval>
        false              --[ , <repeat> ]
    )

    pIT2 = UTIL_IntervalTimer(
        3,                     --<timerID>
        "onEnd",               --"<callback>"
        time + start_time * 2, --<interval>
        false                  --[ , <repeat> ]
    )
    count = 0
end

function execute(deltaT)
    count = count + 1;
end

function onLeave()
    TASK_StageClear()
end

function leave()
    TASK_StageClear()
end

function onStart()
    syslog("onStart")
    prop = TASK_getProperty(pProg)
    prop.value = 1.0
    TASK_setProperty(pProg, prop)
end

function onAniEnd()
    sysCommand(pForm, UI_FORM_UPDATE_NODE, 'label', FORM_TEXT_SET, 'completed')
end

function onEnd()
    syslog("onEnd")
    sysLoad("asset://home.lua")
end
