-- start_helper.lua
-- Ϊ���WIFI�����������ṩ��ʼ������¼�����
-- 
-- ��Ȩ (C) 2025 ����Punguin
--
-- ���������������������Ը��������������ᷢ����GNU Afferoͨ�ù������֤����������֤�ĵ�3�����ѡ��ģ��κκ����İ汾���·�������/���޸�������
-- ������ķ�����ϣ�����������á���û���κα�֤������û�������ı�֤��������ķַ���ϣ���������õģ���û���κα�֤������û��������������·���ʺ�ĳһ�ض�Ŀ�ĵı�֤�� �μ� GNU Afferoͨ�ù������֤�˽����ϸ�ڡ�
-- ��Ӧ���Ѿ��յ���һ��GNU Afferoͨ�ù������֤�ĸ����� ���û�У���μ�<https://www.gnu.org/licenses/>��
--
-- ��ϵ���ǣ�3618679658@qq.com
-- ChatGPTЭ��������д

-- ���ñ����ն��붨�崰�ڴ�С
os.execute("title ���WIFI����__��ǰ�汾: 4.9 ,���ڼ��汾")
os.execute("mode con: cols=53 lines=15")

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
    
    -- �����һ��������ʾ
    print("�������ڳ�ʼ��....")
    delay.sleep(6)
    print ()
    -- ��ȡ Windows �汾
    local handle = io.popen("wmic os get Caption")
    local result = handle:read("*a")
    handle:close()

   -- �ж� Windows �汾
   if result:find("Windows 10") then
       print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
       print(colors.cyan .. colors.bright .. "�T�T�T  " .. colors.green .."��⵽ Windows 10".. colors.reset .. colors.cyan .. colors.bright .. "  �T�T" .. colors.reset)
       print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
   elseif result:find("Windows 11") then
       print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
       print(colors.cyan .. colors.bright .. "�T�T�T  " .. colors.green .."��⵽ Windows 11".. colors.reset .. colors.cyan .. colors.bright .. "  �T�T" .. colors.reset)
       print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
       print()
       delay.sleep(1)
       print(colors.red .. colors.bright .."��ǰϵͳ����̨���ܻᱻ�ն����".. colors.reset)
       print()
       print(colors.red .. colors.bright .."�Ƽ�ǰ�����á�������ѡ���޸�Ϊ����̨".. colors.reset)
       delay.sleep(2)
   elseif result:find("Windows 7") then
       print("�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T")
       print("�T�T�T  ".."��⵽ Windows 7".."  �T�T")
       print("�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T")
       print()
       print("��ǰ���ֲ�֧�� Windows 7 ϵͳ��")
       print("������������ Windows 7 ��ר�ù����䡣")
       print()
       print("����������˳�...")
       os.execute("pause >nul")  -- �ȴ��û����������
       os.exit()  -- �˳��ű�
   else
       print("�޷�ȷ�� Windows �汾")
   end
    print()
    print()
    print("���Ժ����������Ż����л���")
    delay.sleep(6)
	print()
	--��ǰ�汾ʡ��һЩע������
    print(colors.green .."ע���༭��:�����ѱ���!".. colors.reset)
    delay.sleep(6)
    -- ɾ�� dyc �ļ�
    os.remove(flag_file)
    print ()
    print (colors.green .."���".. colors.reset)
    delay.sleep(3)
    os.execute("cls")
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
    local version_urls = {
        "https://punguin.pages.dev/helper",      --����Cloudflare�ṩ����ѷ���
        --"http://47.239.84.169/helper"            --������
    } -- �������б�
    local local_version = "4.9" -- �滻Ϊ���صİ汾��
    local temp_version_file = "version.ini" -- ��ʱ�汾�ļ�
    local cloud_version = nil  -- ע��,�ڱ���ʱ��Ҫ��ip���е�������

    -- �Ӱ汾�ļ�����ȡ�ƶ˰汾��
    local function get_version_from_html(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return nil
        end
        for line in file:lines() do
            local version = line:match("%d.%d") -- "%d.%d"Ϊ�汾�Ÿ�ʽ,��Ӧ�İ汾ΪX.X(���ָ�ʽ)
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
        --os.execute(string.format('bin\\curl -l -o %s %s >nul 2>nul', temp_version_file, url))
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