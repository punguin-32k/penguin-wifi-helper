-- start_helper.lua
-- Ϊ���WIFI�����������ṩ��ʼ������¼�����
--
-- ��Ȩ (C) 2025-2026 ����Punguin
--
-- ���������������������Ը��������������ᷢ����GNU Afferoͨ�ù������֤����������֤�ĵ�3�����ѡ��ģ��κκ����İ汾���·�������/���޸�������
-- ������ķ�����ϣ�����������á���û���κα�֤������û�������ı�֤��������ķַ���ϣ���������õģ���û���κα�֤������û��������������·���ʺ�ĳһ�ض�Ŀ�ĵı�֤�� �μ� GNU Afferoͨ�ù������֤�˽����ϸ�ڡ�
-- ��Ӧ���Ѿ��յ���һ��GNU Afferoͨ�ù������֤�ĸ����� ���û�У���μ�<https://www.gnu.org/licenses/>��
--
-- ��ϵ���ǣ�3618679658@qq.com
-- ChatGPTЭ��������д

-- ���ñ����ն��붨�崰�ڴ�С
os.execute("title ���WIFI���� ��ǰ�汾: 5.2 ,���ڼ��汾")
os.execute("mode con: cols=60 lines=15")

-- �����ⲿ��
local path = require("lua\\path") -- ����·��������
local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- ��ȡ��ǰ�ű�����Ŀ¼
local script_path = debug.getinfo(1, "S").source:sub(2)
local script_dir = script_path:match("(.*/)") or script_path:match("(.+\\)") or "./"

-- �����־�ļ�·��
local flag_file = script_dir .. "dyc"

-- �ж��Ƿ�Ϊ��һ������
local file = io.open(flag_file, "r")
if file then
    file:close()
    
    -- ʹ�ü��±��������ļ�
    print("��⵽���ֵ�һ������")
    print("���ڴ������ļ������ֶ��༭...")
	delay.sleep(4)
    os.execute('start notepad.exe helper.ini')
    -- ɾ����־�ļ��������ظ���ʾ
    os.remove(flag_file)
	delay.sleep(2)
end

local function print_tips()
   print(colors.green .."���ڼ�������ƶ˰汾,�����ĵȴ�����\n\n" .. colors.reset)
end

local function print_start()
   print()
   print()
   print(colors.green .."���ڴ���������������������,���Եȼ���......\n" .. colors.reset)
end

-- �ȴ��û����������
local function wait_for_user_input()
    print()
    print(colors.yellow .. "��⵽�°汾���������������..." .. colors.reset)
    os.execute("pause >nul")  -- Windows�µȴ��û����������
	print()
	delay.sleep(1)
	print()
	print(colors.red .. "ÿ�θ��¶����µĺù���,���ǽ�������������" .. colors.reset)
	delay.sleep(5)
end
-- ���������Build�汾ͨ��
local function get_version_path()
    local default_path = "helper"  -- Ĭ��·��
    local file = io.open("helper.ini", "r")
    if not file then
        return default_path  -- �����ļ������ڣ�ʹ��Ĭ��
    end
    for line in file:lines() do
        -- ���δע�͵�[Build version channel]
        if line:match("^%s*%[Build version channel%]%s*$") then
            file:close()
            return "helper-build"  -- ʹ��Buildͨ��·��
        -- ���ע�͵�#[Build version channel]
        elseif line:match("^%s*#%s*%[Build version channel%]%s*$") then
            file:close()
            return default_path  -- ʹ��Ĭ��·��
        end
    end
    file:close()
    return default_path  -- δ�ҵ�������ã�ʹ��Ĭ��
end

-- ��ȡ�ƶ˰汾��Ϣ
local function check_version()
-- ��ȡ helper.ini �е�ˢ�����ڣ��죩
local function read_refresh_cycle(file_path)
    local file = io.open(file_path, "r")
    if not file then
        print("δ�ҵ� helper.ini�����������а汾��⡣")
        return nil
    end
    for line in file:lines() do
        local cycle = line:match("refresh cycle%s*=%s*(%d+)")
        if cycle then
            file:close()
            return tonumber(cycle)
        end
    end
    file:close()
    print("δ�� helper.ini ���ҵ� refresh cycle ���������������а汾��⡣")
    return nil
end
-- �� version.ini �л�ȡ�ϴμ��ʱ�䣨��ʽ��review time: YYYY-MM-DD��
local function read_last_check_time(file_path)
    local file = io.open(file_path, "r")
    if not file then
        print("δ�ҵ� version.ini�����������а汾��⡣\n")
        return nil
    end
    for line in file:lines() do
        local y, m, d = line:match("review time:%s*(%d+)%-(%d+)%-(%d+)")
        if y then
            file:close()
            return os.time{year=tonumber(y), month=tonumber(m), day=tonumber(d), hour=0, min=0, sec=0}
        end
    end
    file:close()
    print("δ�� version.ini ���ҵ� review time ��¼�����������а汾��⡣")
    return nil
end
-- �ж��Ƿ���Ҫ������
local function should_check_update()
    local cycle = read_refresh_cycle("helper.ini") -- ����
    local last_time = read_last_check_time("version.ini")
    if not cycle or not last_time then
        return true -- ȱ�ļ�/����/ʱ����Ϣ��ǿ�Ƽ��
    end
    local now = os.time()
    local diff_days = os.difftime(now, last_time) / (60 * 60 * 24) -- ��ת��
    if diff_days >= cycle then
    return true
else
    if diff_days < 1 then
        print("�ϴμ���ǽ��죬�����汾��⡣")
    else
        print(string.format("�ϴμ���� %.1f ��ǰ��δ�ﵽ %d ��ĸ�������", diff_days, cycle))
		print(string.format("�����汾��⡣", diff_days, cycle))
    end
    -- �����´μ��ʱ��
    local next_time = last_time + cycle * 24 * 60 * 60
    local next_date = os.date("%Y-%m-%d", next_time)
    print("Ԥ�ƽ��� " .. next_date .. " ���ٴμ�⡣")
    return false
end
end
-- ������Ҫ��⣬����
if not should_check_update() then
    delay.sleep(2)
    return
end

    -- ������ͨ��get_version_path()��ȡʵ����ȡ·��
    local version_path = get_version_path()
    local version_urls = {
        "https://punguin.pages.dev/" .. version_path,      -- ƴ��·��
        --"http://47.239.84.169/" .. version_path,            -- ƴ��·��
		"http://127.0.0.1:0721/" .. version_path                   -- ƴ��·��
    } -- �������б�
    local local_version = "5.2" -- �滻Ϊ���صİ汾��
    local temp_version_file = "version.ini" -- ��ʱ�汾�ļ�
    local cloud_version = nil  -- ע��,�ڱ���ʱ��Ҫ��ip���е�������
    -- �Ӱ汾�ļ�����ȡ�ƶ˰汾��
    local function get_version_from_html(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return nil
        end
        for line in file:lines() do
            local version = line:match("%d+%.%d+[%w%-]*") -- "%d.%d"Ϊ�汾�Ÿ�ʽ,��Ӧ�İ汾ΪX.X(���ָ�ʽ)
            if version then
                file:close()
                return version
            end
        end
        file:close()
        return nil
    end
    -- ����ļ��Ƿ���Ч
    local function is_file_valid(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return false
        end
        local content = file:read("*a")
        file:close()
        return content and #content > 0 and not content:find("404") -- ��������Ƿ����404
    end
    -- ���Դ�ÿ�����������ذ汾�ļ�
    for _, url in ipairs(version_urls) do
        -- ʹ��curl���ذ汾�ļ�
		os.execute(string.format('"%s" -l -o %s %s >nul 2>nul', path.curl, temp_version_file, url))
        
        if is_file_valid(temp_version_file) then
            cloud_version = get_version_from_html(temp_version_file)
            if cloud_version then
                break -- �ɹ���ȡ�ƶ˰汾�ţ��˳�ѭ��
            end
        end
    end
    --os.remove(temp_version_file) -- ɾ����ʱ�汾�ļ�
    -- ����汾��Ϣ
    if cloud_version then
	-- ��ȡ��ǰʱ�䲢д��汾�ļ�
local function write_check_time(file_path)
    local time_str = os.date("\n\nreview time: %Y-%m-%d") -- ��ʽ�����ʱ�䣺��-��-��
    local file = io.open(file_path, "a") -- ʹ��׷��ģʽ
    if file then
        file:write(time_str)
        file:close()
    end
end
write_check_time(temp_version_file)
        print(colors.bright .. "���°汾: " .. cloud_version .. "  ��ǰ�汾: " .. local_version .. colors.reset .. "\n")
        print(colors.blue .. colors.bright .. "���ƶ����°汾,��������ֺ�����'new'����\n" .. colors.reset)
        print()
        print("Ц�����:���������������������1.2")
		print()
        -- �ж��Ƿ���Ҫ�ȴ��û�����
        if cloud_version > local_version then
            wait_for_user_input()  -- ����ƶ˰汾�ȱ��ذ汾�ߣ��ȴ��û�����
        else
        end
    else
        print(colors.bright .. "�޷���ȡ�ƶ˰汾\n" .. colors.reset)
    end
end
print_tips()
check_version()
print_start()
delay.sleep(2)
os.execute("bin\\lua54 lua\\helper.lua")