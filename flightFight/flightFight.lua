local step_fns = {}
local flight
local global_step_fn;

function setup()
    flight = Flight()

    function createMonster()
        local m = Monster()
    end

    global_step_fn = StepFn(5000)
    global_step_fn.add(createMonster)
    createMonster();

    pCtrl = UI_Control(
        "onClick",
        "onDrag"
    )
end

function execute(deltaT)
    for i = #step_fns, 1, -1 do
        step_fns[i].fn(deltaT)
    end
end

function leave()

end

function onClick(x, y)
    syslog(string.format("Click (%i,%i)", x, y))
    flight.updatePos(x)
end

function onDrag(x, y)
    syslog(string.format("onDrag (%i,%i)", x, y))
    -- flight.updatePos(y)
end

local stage_with = 1000
local stage_height = 750
local flight_width = 128
local flight_height = 128
local monster_width = 62
local monster_height = 86

-- 定义一个新的类
function Flight()
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

    self.destroy = function()
        prop = TASK_getProperty(node)
        prop.color = 0xFF00FF
        TASK_setProperty(pSimpleItem, prop)

        SetTimeout(function()

        end, 1000)
    end

    -- 返回实例对象
    return self
end

math.randomseed(os.time())
function Monster()
    local max_x = stage_with - monster_width
    local randomNum = math.random()
    local step_fn = StepFn(16)
    local x = math.floor(max_x * randomNum);

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

    local step_y = 5;
    self.updatePos = function(step_num)
        local new_y = self.y + step_y * step_num
        -- syslog(string.format("Monster new_y = %i", new_y))
        if self.y > stage_height + 20 then
            self.destroy()
            return
        end
        local props = TASK_getProperty(node)
        props.y     = new_y
        self.y      = new_y
        -- props.y = self.y;
        TASK_setProperty(node, props)
    end

    self.destroy = function()
        step_fn.remove(self.updatePos)
    end

    step_fn.add(self.updatePos)

    return self
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

function DetectCollision(monsterInfo)
    local x = flight.x;
    local y = flight.y;
    local width = flight.width;
    local height = flight.height;
end
