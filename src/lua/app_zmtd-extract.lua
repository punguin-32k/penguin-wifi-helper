-- Extract_MTD4.lua
-- ��ȡ�豸mtdϵͳ����������������Ϊ�ļ�
-- 
-- ��Ȩ (C) 2025-2026 ����Punguin
--
-- ���������������������Ը��������������ᷢ����GNU Afferoͨ�ù������֤����������֤�ĵ�3�����ѡ��ģ��κκ����İ汾���·�������/���޸�������
-- ������ķ�����ϣ�����������á���û���κα�֤������û�������ı�֤��������ķַ���ϣ���������õģ���û���κα�֤������û��������������·���ʺ�ĳһ�ض�Ŀ�ĵı�֤�� �μ� GNU Afferoͨ�ù������֤�˽����ϸ�ڡ�
-- ��Ӧ���Ѿ��յ���һ��GNU Afferoͨ�ù������֤�ĸ����� ���û�У���μ�<https://www.gnu.org/licenses/>��
--
-- ��ϵ���ǣ�3618679658@qq.com
-- ChatGPTЭ��������д

-- ���ñ����봰�ڴ�С
os.execute("title ���WIFI����-MTD��ȡ����")
os.execute("mode con: cols=66 lines=35")

-- �����ⲿ��
local path = require("lua\\path") -- ����·��������
local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- ��ȡ�ű�����Ŀ¼�ľ���·��
local function get_script_dir()
    local path = io.popen("cd"):read("*l")
    return path .. "\\"
end
local script_dir = get_script_dir()

-- ����Ŀ���ļ���·��
local qt_folder = script_dir .. "TQ\\"

-- ��ȡ����
print(colors.blue .. colors.bright .. "��Ѱ�豸..." .. colors.reset)
delay.sleep (4) -- �ȴ��豸
os.execute("bin\\adb pull /dev/mtd4 draw.tmp")   -- �̼�MTD��ȡ
print()
print()
print(colors.green .. "�ѳ�����ȡ" .. colors.reset)

-- ��ȡ�û���������ļ���
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
io.write("�������µ��ļ�����������չ������")               --��ͣ�����ִ��,���û������ı�
local new_file_name = io.read()                            --���û�������ļ��趨Ϊ"new_file_name"����
new_file_name = new_file_name:gsub('^%"', ''):gsub('%"$', '')      --ȥ���ļ�·����˫���ţ�����У�
new_file_name = new_file_name .. ".bin" -- �����ļ������� .bin ��׺

-- ����������·��
local old_file_path = script_dir .. "draw.tmp"
local new_file_path = script_dir .. new_file_name

-- �������ļ�
local success, err = os.rename(old_file_path, new_file_path)
if success then
    print(colors.green .."�ļ��ѳɹ�������Ϊ: " .. new_file_name .. colors.reset)
else
    print(colors.red .."������ʧ��: " .. err .. colors.reset)
end

-- ���Ŀ���ļ����Ƿ���ڣ�����������򴴽�
local function ensure_directory_exists(path)
    local ok, err, code = os.rename(path, path)
    if not ok then
        if code == 2 then
            os.execute('mkdir "' .. path .. '"')
        else
            print(colors.red .."�޷����򴴽�Ŀ¼: " .. err .. colors.reset)
        end
    end
end

ensure_directory_exists(qt_folder)

-- �����µ�Ŀ��·��
local target_file_path = qt_folder .. new_file_name

-- �ƶ��ļ�
local success, err = os.rename(new_file_path, target_file_path)
if success then
    print(colors.green .."�ļ��ѳɹ��ƶ���QT�ļ���".. colors.reset)
	os.execute("explorer TQ")
	print(colors.green .. colors.bright .."�ű�����ȷִ��,�����رմ���".. colors.reset)
	delay.sleep (5)
else
    print(colors.red .."�ƶ��ļ�ʧ��: " .. err .. colors.reset)
	os.execute("pause")
end