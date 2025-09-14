-- web.lua
-- �򵥵�jffs2�ɶ�д�豸��¼web��̨
-- 
-- ��Ȩ (C) 2025-2026 ����Punguin
--
-- ���������������������Ը��������������ᷢ����GNU Afferoͨ�ù������֤����������֤�ĵ�3�����ѡ��ģ��κκ����İ汾���·�������/���޸�������
-- ������ķ�����ϣ�����������á���û���κα�֤������û�������ı�֤��������ķַ���ϣ���������õģ���û���κα�֤������û��������������·���ʺ�ĳһ�ض�Ŀ�ĵı�֤�� �μ� GNU Afferoͨ�ù������֤�˽����ϸ�ڡ�
-- ��Ӧ���Ѿ��յ���һ��GNU Afferoͨ�ù������֤�ĸ����� ���û�У���μ�<https://www.gnu.org/licenses/>��
--
-- ��ϵ���ǣ�3618679658@qq.com
-- ChatGPTЭ��������д

local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- ���ñ����ն��붨�崰�ڴ�С
os.execute("title ���WIFI����_WEB��д����")
os.execute("mode con: cols=66 lines=35")
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)

-- ���� executeADBCommand ����,ͨ��os.execute����adb���������,�����жϻ����Ƿ�Ϊ�ɶ�д���������
local function executeADBCommand(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- ���� check_file ����
local function check_file()
    print(colors.blue .. colors.bright .. "��Ѱ�豸..." .. colors.reset)
    delay.sleep(4)
    os.execute("cls")
    -- ���� adb devices ������񷵻ؽ��
    local adbDevicesCommand = "bin\\adb devices"
    local devicesOutput = executeADBCommand(adbDevicesCommand)

    -- ����Ƿ����豸����
    if not string.find(devicesOutput, "\tdevice") then
        print(colors.red .. "��ǰ���豸����" .. colors.reset)
		os.execute("pause")
        os.exit(1)
    end

    -- ���� adb touch ������񷵻ؽ��
    local adbCommand = "bin\\adb shell touch /etc_ro/web/test_file"
    local output = executeADBCommand(adbCommand)

    -- ��鷵�ؽ���Ƿ���� "Read-only file system"
    if string.find(output, "Read") then
        print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
        print(colors.red .. "�û���Ϊֻ���ļ�ϵͳ (squashfs)" .. colors.reset)
        print(colors.blue .. colors.bright .. "ǿ��ˢ��ᵼ�������豸��ʧ��̨" .. colors.reset)
        os.execute("pause")
        os.exit(1)
    else
        print(colors.green .. colors.bright .."�û���Ϊ��д�ļ�ϵͳ,֧���ļ��ϴ�(������jffs2)".. colors.reset)
        print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
    end
end

-- �޸� 5.1-Build-250816
folderPath = nil -- ������ȫ��nil����
-- End

local function file()
-- ��ȡ�û�������ļ���·��
print(colors.yellow .."�뽫�ļ�������˴��ڣ�Ȼ�󰴻س���:" ..colors.red)
  -- �޸� 5.1-Build-250816
  -- ȥ��local,��Ϊȫ�ֱ���
  folderPath = io.read("*l") -- ��ȡ�û�������ļ���·��
  -- End

-- ȥ�����ܴ��ڵ�����
folderPath = folderPath:gsub("\"", "")

-- ����ļ���·���Ƿ���Ч
local checkCommand = string.format("if exist \"%s\" (echo ok) else (echo not found)", folderPath)
local handle = io.popen(checkCommand)
local result = handle:read("*a")
handle:close()

if not result:find("ok") then
    print(colors.red .. "��Ч���ļ���·����")
	os.execute("pause")
    os.exit(1)
end
end

-- ��ȡ��ǰ Lua �ű�����Ŀ¼
local function getScriptDirectory()
    local str = arg[0]
    return str:match("(.*/)") or str:match("(.*\\??") or ".\\"
end

-- ����Ŀ¼
local function createDirectory(path)
    os.execute("mkdir \"" .. path .. "\"")
end

-- ִ��ADB������ؽ��
local function executeADBCommand(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- ���� /etc_ro/web �ļ��е�ָ��Ŀ¼
local function backupWebFolder(tempBackupPath)
    print()
    print(colors.green .. "���ڱ����豸��̨WEB�ļ���..." .. colors.blue)
    local backupCommand = "bin\\adb pull /etc_ro/web \"" .. tempBackupPath .. "\""
    return executeADBCommand(backupCommand)
end

-- �ƶ��������������ļ���
local function moveBackupFolder(tempBackupPath, backupDir)
    -- ѯ���û������ļ�������
	print()
    print(colors.yellow .. "�����뱸���ļ��е�����:" .. colors.red)
    local folderName = io.read()
	print(colors.blue)

    -- �ƶ����������ļ���
    local moveCommand = "move /Y \"" .. tempBackupPath .. "\" \"" .. backupDir .. folderName .. "\""
    local moveResult = os.execute(moveCommand)
    print(colors.reset)
	
    -- ����ƶ����
    if moveResult then
	    print()
        print(colors.green .. "������ɣ��ļ��ѱ��浽: " .. backupDir .. folderName .. colors.reset)
		os.execute("explorer TQ")
    else
	    print()
        print(colors.red .. "�ƶ��ļ�ʧ�ܣ�����Ȩ�ޡ�" .. colors.reset)
    end
end

-- ��װ�����������̵ĺ���
local function Backup_web()
    local scriptDir = getScriptDirectory()

    -- ���ñ��ݱ���·��
    local tempBackupPath = scriptDir .. "web_backup" -- ֱ�ӱ��ݵ��ű�����Ŀ¼
    local backupDir = scriptDir .. "TQ\\"

    -- ѯ���û��Ƿ񱸷� /etc_ro/web �ļ���
	print()
    print(colors.yellow .. colors.bright .. "�Ƿ񱸷��豸ԭ��̨? (y/n)" .. colors.reset)
    local userInput = io.read()

    if userInput == "y" or userInput == "Y" then
        -- �û�ѡ�񱸷ݣ�ִ�б��ݲ���
        local backupResult = backupWebFolder(tempBackupPath)
        
        -- ��鱸�ݽ��
        if backupResult and backupResult:find("error") then
		    print()
            print(colors.red .. "����ʧ�ܣ������豸���Ӽ�Ȩ�ޡ�" .. colors.reset)
        else
            moveBackupFolder(tempBackupPath, backupDir)
        end
    else
        -- �û�ѡ�񲻱���
		print()
        print(colors.blue .. "���������ݲ���" .. colors.reset)
    end

    print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
end

local function up_web()
-- ɾ���豸��ԭ�е� /etc_ro/web �ļ���
local deleteCommand = "bin\\adb shell rm -rf /etc_ro/web"
os.execute(deleteCommand)

-- �ϴ������ļ��е��豸
local uploadCommand = string.format("bin\\adb push \"%s\" /etc_ro/web", folderPath)
os.execute(uploadCommand)
print()
print(colors.green .. colors.bright .."�ϴ����,�豸web���滻!"..colors.reset)
end

os.execute("bin\\adb shell mount -o remount,rw /")
check_file() -- ����豸�Ƿ������д
file() -- ���û������ļ�
Backup_web() -- ���к�̨�ı���
up_web() -- ɾ���豸��ԭ�е�WEB���ϴ��µ��ļ�
os.execute("pause")