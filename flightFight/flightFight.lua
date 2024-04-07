local step_fns = {}
local game
local pTip

function setup()
    game = Game()
    pCtrl = UI_Control(
        "onClick",
        "onDrag"
    )
    StartTip()

    -- SetInterval(function()

    -- end, 1000)
end

function StartTip()
    pTip = UI_Form(nil,           -- arg[1]:	親となるUIタスクのポインタ
        7000,                     -- arg[2]:	基準表示プライオリティ
        0, 0,                     -- arg[3,4]:	表示位置
        "asset://StartGame.json", -- arg[5]:	composit jsonのパス
        false                     -- arg[6]:	排他フラグ
    )
end

function StartGame()
    TASK_kill(pTip)
    game.startGame()
end

function execute(deltaT)
    for i = #step_fns, 1, -1 do
        if step_fns[i] then
            step_fns[i].fn(deltaT)
        end
    end
end

function leave()

end

function onClick(x, y)
    syslog(string.format("Click (%i,%i)", x, y))
    game.updateFlightPos(x)
end

function onDrag(x, y)
    -- flight.updatePos(y)
end

local stage_with = 1000
local stage_height = 750
local flight_width = 128
local flight_height = 128
local monster_width = 62
local monster_height = 86
function Game()
    local self = {}
    local step_fn = StepFn(16)
    local createMonInterval = nil
    local timeout = nil

    local flight = nil
    local monster_list = {}
    local pause = false
    self.startGame = function()
        flight = Flight(self)
        local createMonster = function()
            syslog("createMonster")
            local m = Monster(self)
            table.insert(monster_list, m)
        end

        createMonster();
        createMonInterval = SetInterval(createMonster, 5000)

        step_fn.add(self.update)
    end

    self.update = function(deltaT)
        if pause then
            return
        end

        if flight then
            flight.update(deltaT)
        end

        for i = #monster_list, 1, -1 do
            monster_list[i].update(deltaT)
        end
    end

    self.pauseGame = function()
        pause = true
    end

    self.finishGame = function(status)
        self.pauseGame()
        if createMonInterval ~= nil then
            createMonInterval()
            createMonInterval = nil
        end

        if status == 'fail' then
            if flight then
                flight.broke()
            end
        end

        timeout = SetTimeout(function()
            StatusAni(status)
        end, 2000)

        timeout = SetTimeout(function()
            self.endGame()
        end, 4000)
    end

    self.endGame = function()
        step_fn.remove(self.update)
        if flight ~= nil then
            flight.destroy();
        end

        for i = #monster_list, 1, -1 do
            monster_list[i].destroy()
        end

        flight = nil
        pause = false
        StartTip()
    end

    self.updateFlightPos = function(x)
        if pause then
            return
        end
        if flight then
            flight.updatePos(x)
        end
    end

    self.detectCollision = function(monster)
        if not flight then
            return false
        end
        local collision = flight.x <= monster.x + monster.width and
            flight.x + flight.width >= monster.x and
            flight.y <= monster.y + monster.height and
            flight.y + flight.height >= monster.y;

        if collision then
            self.finishGame('fail')
        end

        return collision
    end

    self.destroy = function()
        step_fn.clear()
        step_fn = nil

        if timeout ~= nil then
            timeout()
            timeout = nil
        end
        if createMonInterval ~= nil then
            createMonInterval()
            createMonInterval = nil
        end
    end

    self.removeMonster = function(monster)
        for i = #monster_list, 1, -1 do
            if monster == monster_list[i] then
                table.remove(step_fns, i)
            end
        end
    end

    return self
end

-- 定义一个新的类
function Flight(game)
    -- 创建实例对象
    local ani = Ani()
    local self = {
        x = (stage_with - flight_width) / 2,
        y = stage_height - flight_height,
        width = flight_width,
        height = flight_height,
    }
    local node = UI_SimpleItem(nil,       -- arg[1]:		親となるUIタスクポインタ
        7000,                             -- arg[2]:		表示プライオリティ
        self.x, self.y,                   -- arg[3,4]:	表示位置
        "asset://assets/flight1.png.imag" -- arg[5]:		表示assetのパス
    )

    self.node = node
    -- 定义方法
    self.update = function(deltaT)
    end
    self.updatePos = function(x)
        local new_x = x - flight_width / 2;
        if new_x < 0 then
            new_x = 0
        elseif new_x > stage_with - flight_width then
            new_x = stage_with - flight_width
        end

        local old_x = self.x
        if old_x == new_x then
            return
        end

        -- self.y = y;
        ani.clear()
        ani.add(300, function(radio)
            local cur_x = old_x + (new_x - old_x) * radio;
            self.x      = cur_x
            local props = TASK_getProperty(node)
            props.x     = cur_x
            -- props.y = self.y;
            TASK_setProperty(node, props)
        end)
    end

    self.broke = function()
        syslog("flight broke")
        local flag = false;
        local removeInterval = SetInterval(function()
            flag = not flag
            prop = TASK_getProperty(node)
            if flag then
                prop.color = 0xFF00FF
            else
                prop.color = 0xFFffFF
            end
            TASK_setProperty(node, prop)
        end, 200)

        SetTimeout(function()
            removeInterval()
        end, 2000)
    end

    self.destroy = function()
        ani.clear()
        TASK_kill(node)
        ani = nil

        syslog("flight destroy")
    end

    -- 返回实例对象
    return self
end

math.randomseed(os.time())
function Monster(game)
    local max_x = stage_with - monster_width
    local randomNum = math.random()
    local self = {
        x = math.floor(max_x * randomNum),
        y = -monster_height,
        width = monster_width,
        height = monster_height,
    }
    local node = UI_SimpleItem(nil,       -- arg[1]:		親となるUIタスクポインタ
        7001,                             -- arg[2]:		表示プライオリティ
        self.x, self.y,                   -- arg[3,4]:	表示位置
        "asset://assets/monster.png.imag" -- arg[5]:		表示assetのパス
    )

    self.node = node

    self.update = function(deltaT)
        self.updatePos(deltaT)
    end

    self.updatePos = function(step_num)
        local step_y = 5;
        if game.detectCollision(self) then
            return
        end

        local new_y = self.y + step_y * step_num
        -- syslog(string.format("Monster new_y = %i", new_y))
        if self.y > stage_height + 20 then
            return
        end
        local props = TASK_getProperty(node)
        props.y     = new_y
        self.y      = new_y
        -- props.y = self.y;
        TASK_setProperty(node, props)
    end

    self.destroy = function()
        game.removeMonster(self)
        TASK_kill(node)
        syslog("monster destroy")
    end

    return self
end

local fail_size = { width = 242, height = 132 }
local suc_size = { width = 282, height = 153 }
function StatusAni(status)
    local img
    local pos
    if status == 'fail' then
        img = "asset://assets/status_fail.png.imag"
        pos = { x = (stage_with - fail_size.width) / 2, y = (stage_height - fail_size.height) / 2 }
    else
        img = "asset://assets/status_succ.png.imag"
        pos = { x = (stage_with - suc_size.width) / 2, y = (stage_height - suc_size.height) / 2 }
    end

    local node = UI_SimpleItem(nil, -- arg[1]:		親となるUIタスクポインタ
        7001,                       -- arg[2]:		表示プライオリティ
        pos.x, pos.y,               -- arg[3,4]:	表示位置
        img                         -- arg[5]:		表示assetのパス
    )


    syslog(string.format("StatusAni (%i,%i)", pos.x, pos.y))
    SetTimeout(function()
        TASK_kill(node)
    end, 2000)
end

function Ani()
    local self = {};

    self.add = function(time, step_fun)
        local cur_time = 0;
        local re_fn = function(deltaT)
            cur_time = cur_time + deltaT;
            local radio = cur_time / time;
            if radio >= 1 then
                step_fun(1)
                remove_step()
            else
                step_fun(radio)
            end
        end

        table.insert(step_fns, { fn = re_fn, bindObj = self })
        function remove_step()
            for i = #step_fns, 1, -1 do
                if step_fns[i].fn == re_fn then
                    table.remove(step_fns, i)
                    return
                end
            end
        end

        return remove_step
    end

    self.clear = function()
        for i = #step_fns, 1, -1 do
            if step_fns[i].bindObj == self then
                table.remove(step_fns, i)
            end
        end
    end

    return self
end

function StepFn(step_time)
    local self = {};

    self.add = function(fn)
        local temp_delta = 0;
        local temp_fn = function(delta)
            temp_delta = temp_delta + delta
            local step_num = math.floor(temp_delta / step_time);
            if step_num < 1 then
                return
            end
            temp_delta = temp_delta - step_time * step_num
            fn(step_num)
        end
        table.insert(step_fns, { fn = temp_fn, bindFn = fn, bindObj = self })
        return function()
            for i = #step_fns, 1, -1 do
                if step_fns[i].fn == temp_fn then
                    table.remove(step_fns, i)
                    return
                end
            end
        end
    end

    self.remove = function(fn)
        for i = #step_fns, 1, -1 do
            if step_fns[i].bindFn == fn then
                table.remove(step_fns, i)
                return
            end
        end
    end

    self.clear = function()
        for i = #step_fns, 1, -1 do
            if step_fns[i].bindObj == self then
                table.remove(step_fns, i)
            end
        end
    end

    return self
end

function SetTimeout(fn, time)
    local temp_delta = 0;
    local clear_fn;
    local temp_fn = function(delta)
        temp_delta = temp_delta + delta
        if temp_delta < time then
            return
        end
        fn()
        clear_fn()
    end
    table.insert(step_fns, { fn = temp_fn })
    clear_fn = function()
        for i = #step_fns, 1, -1 do
            if step_fns[i].fn == temp_fn then
                table.remove(step_fns, i)
                return
            end
        end
    end

    return clear_fn
end

function SetInterval(fn, time)
    local temp_delta = 0;
    local temp_fn = function(delta)
        temp_delta = temp_delta + delta
        if temp_delta < time then
            return
        end
        temp_delta = temp_delta - time
        fn()
    end
    table.insert(step_fns, { fn = temp_fn })

    local clear_fn = function()
        for i = #step_fns, 1, -1 do
            if step_fns[i].fn == temp_fn then
                table.remove(step_fns, i)
                return
            end
        end
    end

    return clear_fn
end
