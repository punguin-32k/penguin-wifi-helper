-- helper.lua
-- ���WIFI���� һ�����Ϲ�����,���û���Я�����豸
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
os.execute("title ���WIFI����(ChatGPTЭ��������д)                      ��ǰ�汾: 5.0                     ����QQ:3618679758���ٷ�QQȺ:725700912 ")
os.execute("mode con: cols=113 lines=32")

-- �����ⲿ��
local path = require("lua\\path") -- ����·��������
local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- ��ȡ�ű���ǰĿ¼
local script_dir = debug.getinfo(1, "S").source:match("@(.*[/\\])")

-- ����ADB������ؽ��
local function exec_command(cmd)       -- ����cmommand���ͱ�ǩ,ʹ������cmd������
    local file = io.popen(cmd)         -- ����������cmd
    local output = file:read("*all")   -- ����All
    file:close()                       -- �����ض���
    return output                      -- ���
end

-- ���ADB����״̬
local function check_adb_status()
    local adb_path = path.adb -- ����adb.exe
    -- ���� adb devices ��������ȡ���ӵ��豸�б�
    local adb_output = exec_command(adb_path .. " devices 2>nul")

    -- �������Ƿ������Ч�豸��Ϣ
    local has_device = false        -- ƥ������device
    local is_offline = false        -- ƥ������offline
    for line in adb_output:gmatch("[^\r\n]+") do   -- �趨�������ƥ��
        if line:match("device$") then      -- ƥ������device
            has_device = true              -- �����,���device��Ӧ����
        elseif line:match("offline") then  -- ƥ������offline
            is_offline = true              -- �����,���device���ݲ�����offline����
        end
    end

    -- ���ݼ������������趨�ı���ɫ
    if has_device and not is_offline then
        print(colors.yellow .. colors.bright .. "�豸״̬��" .. colors.reset .. colors.green .. colors.bright .."������" .. colors.reset)
    elseif is_offline then
        print(colors.yellow .. colors.bright .. "�豸״̬��" .. colors.reset .. colors.green ..  colors.bright .."������(".. colors.reset .. colors.red .."����" .. colors.reset .. colors.green ..  colors.bright ..")".. colors.reset)
    else
        print(colors.yellow .. colors.bright .. "�豸״̬��" .. colors.reset .. colors.red .. "���豸" .. colors.reset)
    end
end

-- ��װ��鴮�����ӵĺ���
function check_serial()
    -- ���ϵͳ���Ƿ��п��õĴ���
    local function is_serial_port_connected()
        for i = 1, 256 do
            local com_port = "\\\\.\\COM" .. i
            local file = io.open(com_port, "r")
            if file then
                file:close()
                return true -- ����򿪳ɹ���˵���д���
            end
        end
        return false -- ���û�д򿪳ɹ���˵��û�д���
    end

    -- ������
    if is_serial_port_connected() then
	    print(colors.yellow .. colors.bright .. "����״̬(AT��)��" .. colors.reset .. colors.green .. colors.bright .."������" .. colors.reset)
    else
	    print(colors.yellow .. colors.bright .. "����״̬(AT��)��" .. colors.reset .. colors.red .. "���豸" .. colors.reset)
    end
end

-- ����һ����������ȡ�ƶ˰汾��Ϣ
local function check_version()
    local local_version = "5.0"  -- �滻Ϊ���صİ汾��
    local temp_version_file = "version.ini" -- ��ʱ�汾�ļ�
    
    -- �Ӱ汾�ļ�����ȡ�ƶ˰汾��
    local function get_version_from_html(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return nil
        end
        for line in file:lines() do
            local version = line:match("%d.%d") -- "%d.%d"Ϊ�汾�Ÿ�ʽ
            if version then
                file:close()
                return version
            end
        end
        file:close()
        return nil
    end
    
    local cloud_version = get_version_from_html(temp_version_file)
    --os.remove(temp_version_file) -- ɾ����ʱ�汾�ļ�(��4.5�汾��ʼ,���ø�ָ��)

    -- ����汾��Ϣ
    if cloud_version then
        print(colors.bright .."���°汾: " .. cloud_version .. "  ��ǰ�汾: " .. local_version .. colors.reset)
    else
        print(colors.bright .."�޷���ȡ�ƶ˰汾" .. colors.reset)
    end
end

local function mtd_check() --��ʾ�豸MTD״̬
        print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
        print("����Ϊ�����豸MTD����״̬")
        print()
        os.execute("bin\\adb shell cat /proc/mtd")
        print()
		print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
        print("һ�������,mtd4:'rootfs' ")
		print(" С���ֻ�����mtd4:'imagefs'")
		print("  ��������Ŀǰ��֧��mtd4:'rootfs'�Ļ���")
		print("   ���ڿ��ܿ������mtd5����֧��")
		print()
		os.execute("pause")
end

local function install_drive() --����һ������װ
  print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
  print("��ѡ��Ҫ��װ������(û��������ȫ��)��")
  print()
  print(colors.cyan .. colors.bright .. "           1.ͨ�ð�׿ADB����    2.����΢ר��lnterface����    3.��Զ��ASRר������     4.�Ϲ�SPDͨ������" .. colors.reset)
  print()
  print(colors.red .. colors.bright .."��ʾ:��������Ϊ�밲����,��װ����ֻ�ᵯ��cmd�������װ�ɹ����ֱ�ӹرա�".. colors.reset)
  print()
  io.write(colors.green .. "���������ֲ��� Enter ��: " .. colors.reset)
  local drive_selection = io.read()
    if drive_selection == "1" then
     os.execute("start file\\drive\\vivo-drive.exe")
    elseif drive_selection == "2" then
     os.execute("start file\\drive\\zxicser.exe")
    elseif drive_selection == "3" then
     os.execute("start file\\drive\\Quectel_LTE_Windows_USB_Driver.exe")
    elseif drive_selection == "4" then
     os.execute("start file\\drive\\SPD_Driver\\DriverSetup.exe")
    end
end

local function set_adb()   -- �����豸adb(3.21�汾����,4.0����)
  print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
  print()
  -- ���û�����IP��ַ������Ϊ��ʱ����ipAddress
  print(colors.red .. colors.bright .. "����!���������豸WIFI������,���������[����Ц]" .. colors.reset)
  print()
  print()
  io.write(colors.green .. "�豸WEB��ַ(���� 192.168.100.1): "  .. colors.red .. colors.bright)
  local ipAddress = io.read()
  print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
  -- ��ӡ����ѡ��˵�
  print()
  print(colors.cyan .. colors.bright .."ʹ��С��ʿ:".. colors.reset .. colors.green .. "�����豸����ɾ��adbd���,���¿���adb����Ȼ���޷�ʹ��״̬(����ģʽ),�����뿴������ҳ�豸״̬")
  print()
  print(colors.cyan .. colors.bright .." =------".. colors.magenta .. colors.bright .."ѡ��ģʽ" .. colors.cyan .. colors.bright .."------------------------------------------------------------------------------------------------=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."1. ����ģʽ(ADB+AT+����)     2. �����˿�ģʽ(��AT)       3. ��ϵͳģʽ(����)        4. �ر�����ģʽ       ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."5. Remoר�õ���ģʽ(ADB+AT+����)                                                                          ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =--------------------------------------------------------------------------------------------------------------=")
  print()
  -- ���û�ѡ����Ӧ�Ĳ�����������ʱ����
  io.write(colors.green .. "���������ֲ��� Enter ��: ".. colors.red .. colors.bright)
  local adb_selection = io.read()
  -- ɸѡ�������ݲ�ִ�ж�Ӧ����
    if adb_selection == "1" then
      print(colors.blue .. colors.bright)
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=2"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=1"')
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1"')
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1&password=MM888@Qiruizhilian20241202"')
      print(colors.green .. colors.bright .."\n�Ժ������豸(5��)....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."\n��������ɣ��Ժ󷵻�" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "2" then
      print(colors.blue .. colors.bright)
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=2"')
      print(colors.green .. colors.bright .."\n�Ժ������豸(5��)....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."\n��������ɣ��Ժ󷵻�" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "3" then
      print(colors.blue .. colors.bright) 
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=3"')
      print(colors.green .. colors.bright .."\n�Ժ������豸(5��)....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."\n��������ɣ��Ժ󷵻�" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "4" then
      print(colors.blue .. colors.bright)
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=0"')
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=ID_SENDAT&at_str_data=AT%2BZMODE%3D0"')
	  print(colors.green .. colors.bright .."\n�Ժ������豸(5��)....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."\n��������ɣ��Ժ󷵻�" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "5" then -- �ⲿ�ֳ�Ϯ��ufitool
	  print(colors.red .. colors.bright .."\n\n����:�÷�ʽ��Դ��Remo�ڲ���Ա" .. colors.blue .. colors.bright)
	  print(colors.red .. colors.bright .."�������ڵ��Ĵ�������ǰ�İ汾(��24��12��֮ǰ),�����汾���ƻ���������" .. colors.blue .. colors.bright)
	  print("\n")
	  print(colors.green .. colors.bright .."\n������ϵͳ��������....." .. colors.blue .. colors.bright)
	  delay.sleep(2)
	  print(colors.blue .. colors.bright)
	  os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=LOGIN&password=cmVtb19zdXBlcl9hZG1pbl8yMjAx"')
	  os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=LOGIN&password=YWRtaW4%3D"')
	  print(colors.green .. colors.bright .."\n��⵽��ֹ,�����ƹ�....." .. colors.blue .. colors.bright)
	  delay.sleep(3)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REMO_SIM_SELECT_R1865&isTest=false&sim_option_id=3&select_sim_mode=1"')
	  print(colors.green .. colors.bright .."\n���ҵ���ʱAPi,���ڷ���ٳ�adbd....." .. colors.blue .. colors.bright)
	  delay.sleep(2)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SysCtlUtal&action=System_MODE&debug_enable=1"')
	  delay.sleep(2)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=ID_SENDAT&at_str_data=AT%2BZMODE%3D1"')
	  delay.sleep(2)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1"')
      print(colors.green .. colors.bright .."\n�Ժ������豸(5��)....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?isTest=false&goformId=RESTORE_FACTORY_SETTINGS"')
      print(colors.green .. colors.bright .."\n��������ɣ��Ժ󷵻�" .. colors.reset)
      delay.sleep(3)
	elseif About_stealing == "stealing" then
	  A = "������Remo��δ���͵����Ufitool"
	  B = "�����ܲ���ÿ���Ǽ��ε�ʹ�û�����"
	  C = "ϣ���ո���ԭ���Ұ�,���½�"
	  D = "͵����Ϊȷʵ������,��������������Ҳ�ܲ���"
	  E = "��֮ϣ���ո���ԭ����,������δ������ϵ�Ұ�"
	  print ("Test,remo adbd By ufitool")
    end
 end
 
 local function ufi_nv_set() --ͨ�����ñ�׼NV�������Ż��豸
 print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
 local check = io.popen("bin\\adb get-state")
	local state = check:read("*a")
	check:close()

	if not state:match("device") then -- ��û���豸ʱ�����
	    print()
		print(colors.red .."[����] δ��⵽ADB�豸���������豸�����ԡ�".. colors.reset)
		print(colors.green .."��ʾ:����豸�������ӵ�����ģʽ���豸adbҲ�ǲ����á�".. colors.reset)
		print()
		print("��������˳�...")
		io.read()  -- ��ȡ�û�����
		os.execute("bin\\lua54 lua\\helper.lua")
	end
 -- ��ӡ����ѡ��˵�
  print()
  print(colors.cyan .. colors.bright .."ʹ��С��ʿ:".. colors.reset .. colors.green .. "��ȥ�ص�ʱ������豸��jffs2��ϵͳ����ô���߻᳢�Խ�Զ�س��������")
  print()
  print(colors.cyan .. colors.bright .." =------".. colors.magenta .. colors.bright .."ѡ��ģʽ" .. colors.cyan .. colors.bright .."------------------------------------------------------------------------------------------------=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."1. SZXFͨ���Ż�      2.ZTE�����Ż�(SZXK)                                                                  ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."                                                                                                          ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                      �Ժ��½��֧�ָ����豸,���ڴ�����ota    =")
  print(colors.cyan .. colors.bright .." =--------------------------------------------------------------------------------------------------------------=")
  print()
  -- ���û�ѡ����Ӧ�Ĳ�����������ʱ����
  io.write(colors.green .. "���������ֲ��� Enter ��: ".. colors.red .. colors.bright)
  local selection = io.read()
  print(colors.reset)
  -- ɸѡ�������ݲ�ִ�ж�Ӧ����
    if selection == "1" then
	print()
	print("���ض�д")
	os.execute("bin\\adb shell mount -o remount,rw /")
	print()
	print("�رղ��۸�����")
	os.execute("bin\\adb shell nv set fota_updateMode=0")
	os.execute("bin\\adb shell nv set fota_updateIntervalDay=365")
	os.execute("bin\\adb shell nv set fota_platform=Punguin")
	os.execute("bin\\adb shell nv set fota_token_rs=0")
	os.execute("bin\\adb shell nv set fota_version_delta_id=")
	os.execute("bin\\adb shell nv set fota_version_delta_url=")
	os.execute("bin\\adb shell nv set fota_version_name=")
	os.execute("bin\\adb shell nv set fota_upgrade_result_internal=")
	os.execute("bin\\adb shell nv set fota_oem=QEJ")
	print("�۸�Զ������")
	os.execute("bin\\adb shell rm -rf /bin/terminal_mgmt")
	os.execute("bin\\adb shell rm -rf /sbin/ip_ratelimit.sh")
	os.execute("bin\\adb shell nv set traffic_mgmt_enable=0")
	os.execute("bin\\adb shell nv set terminal_mgmt_enable=0")
	os.execute("bin\\adb shell nv set tr069_enable=0")
	os.execute("bin\\adb shell nv set enable_lpa=0")
	os.execute("bin\\adb shell nv set lpa_trigger_host=info.punguin.cn")
	os.execute("bin\\adb shell nv set os_url=http://punguin.cn/")
	os.execute("bin\\adb shell nv set TM_SERVER_NAME=reportinfo.punguin.cn")
	os.execute("bin\\adb shell nv set HOST_FIELD=reportinfo.punguin.cn")
	print("��ǿ����")
	os.execute("bin\\adb shell nv set sim_auto_switch_enable=0")
	os.execute("bin\\adb shell nv set sim_switch=1")
	os.execute("bin\\adb shell nv set sim_unlock_code=az952#")
	os.execute("bin\\adb shell nv set sim_default_type=1")
	os.execute("bin\\adb shell nv set band_select_enable=1")
	os.execute("bin\\adb shell nv set dns_manual_func_enable=1")
	os.execute("bin\\adb shell nv set tr069_func_enable=1")
	os.execute("bin\\adb shell nv set ussd_enable=1")
	os.execute("bin\\adb shell nv set pdp_type=IPv4v6")
	os.execute("bin\\adb shell nv set zcgmi=SZXF-Punguin")
	print("����NV����")
	os.execute("bin\\adb shell nv save")
	print(colors.green .. colors.bright .."nv�༭���������ѱ���".. colors.reset)
	print()
	print(colors.blue .."���ڸ��豸��ˮӡ".. colors.reset)
	os.execute([[bin\\adb shell "echo 'copyright = ���豸����� &copy; ����Punguin �޸�' >> /etc_ro/web/i18n/Messages_zh-cn.properties"]])
	os.execute([[bin\\adb shell "echo 'copyright = Software by: &copy; Penguin Revise' >> /etc_ro/web/i18n/Messages_en.properties"]])
	os.execute([[bin\\adb shell "echo 'killall zte_de &' >> /etc/ro"]])
	os.execute([[bin\\adb shell "echo 'nv set cr_version=SZXF-Punguin_P001-20250601 &' >> /etc/ro"]])
	print(colors.green .. colors.bright .."����Read-only file system��������".. colors.reset)
	print()
	print()
	print()
	print()
	print()
	print(colors.red .."�޸���ɣ��ָ��������ᶪʧ���ģ���Ҫ�ָ�����".. colors.reset)
	print()
	os.execute("pause")  -- �ȴ��û������������
	elseif selection == "2" then
            -- �޸��豸
			print(colors.green .. colors.bright .."�ѹ��ظ�Ŀ¼Ϊ�ɶ�д������ֹͣ���ҷ���...".. colors.reset)
			os.execute("bin\\adb shell killall fota_Update")
			os.execute("bin\\adb shell killall fota_upi")
			os.execute("bin\\adb shell killall zte_mqtt_sdk &")
			print()
			print(colors.green .. colors.bright .."�ѹرն������".. colors.reset)
			print()
			print(colors.yellow .."�����Ż��豸nv����...".. colors.reset)
			os.execute("bin\\adb shell nv set mqtt_syslog_level=0")
			os.execute("bin\\adb shell nv set dm_enable=0")
			os.execute("bin\\adb shell nv set mqtt_enable=0")
			os.execute("bin\\adb shell nv set tc_enable=0")
			os.execute("bin\\adb shell nv set tc_downlink=")
			os.execute("bin\\adb shell nv set tc_uplink=")
			os.execute("bin\\adb shell nv set tr069_enable=0")
			os.execute("bin\\adb shell nv set fota_updateMode=0")
			os.execute("bin\\adb shell nv set fota_version_delta_id=")
			os.execute("bin\\adb shell nv set fota_version_delta_url=")
			os.execute("bin\\adb shell nv set fota_version_name=")
			os.execute("bin\\adb shell nv set fota_upgrade_result_internal=")
			os.execute("bin\\adb shell nv save")
			print(colors.green .. colors.bright .."nv�༭���������ѱ���".. colors.reset)
			print()
	        print(colors.blue .."���ڸ��豸��ˮӡ".. colors.reset)
			os.execute([[bin\\adb shell "echo 'copyright = ���豸����� &copy; ����Punguin �޸�' >> /etc_ro/web/i18n/Messages_zh-cn.properties"]])
			os.execute([[bin\\adb shell "echo 'copyright = Software by: &copy; Penguin Revise' >> /etc_ro/web/i18n/Messages_en.properties"]])
			os.execute([[bin\\adb shell "echo 'killall zte_de &' >> /etc/ro"]])
			os.execute([[bin\\adb shell "echo 'nv set cr_version=SZXK-Punguin_P049U-20250601 &' >> /etc/ro"]])
			print(colors.green .. colors.bright .."����Read-only file system��������".. colors.reset)
			print()
			print(colors.yellow .."�����޸��豸�ļ�".. colors.reset)
			os.execute("bin\\adb push file\\gsmtty /bin")
			os.execute('bin\\adb shell "chmod +x /bin/gsmtty"')
			os.execute("bin\\adb shell gsmtty AT+ZCARDSWITCH=0")
			os.execute("bin\\adb push file\\hosts /etc/hosts")
			os.execute("bin\\adb shell chmod +x /etc/hosts")
			os.execute("bin\\adb shell rm -r -rf /sbin/tc_tbf.sh")
			os.execute("bin\\adb push file\\tc_tbf.sh /sbin/tc_tbf.sh")
            os.execute("bin\\adb shell rm -rf /sbin/start_update_app.sh")
            os.execute("bin\\adb shell rm -rf /bin/fota_Update")
            os.execute("bin\\adb shell rm -rf /bin/fota_upi")
			os.execute([[bin\\adb shell "echo 'killall zte_de &' >> /etc/ro"]])
            os.execute([[bin\\adb shell "echo 'killall ztede_timer &' >> /etc/ro"]])
            os.execute([[bin\\adb shell "echo 'killall zte_mqtt_sdk &' >> /etc/ro"]])
			print()
			print(colors.yellow .."������ʱ�ļ�...".. colors.reset)
			os.execute("bin\\adb shell rm -r -rf /bin/miniupnp")
			os.execute("adb shell rm -r -rf /bin/gsmtty")
			os.execute("bin\\adb shell reboot")
			print()
			print(colors.green .. colors.bright .."���,��ȴ��豸����".. colors.reset)
	        print()
	        print()
	        print()
	        print()
	        os.execute("pause")  -- �ȴ��û������������
	end
 end

-- ��ӡѡ��
local function uisoc()
    print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
    print("\n")
	print()
    print(colors.yellow .. "       1.��ѯ�ۻ�SN" .. colors.reset) 
	print()
    print(colors.blue .. "          2.�޸��豸����" .. colors.reset) 
	print()
    print(colors.cyan .. "             3.ResearchDownload" .. colors.reset) 
	print()
    print(colors.green .. "                4.spd_dump" .. colors.reset) 
	print()
    print(colors.white .. "                   5.�п�" .. colors.reset) 
	print()
	print("���»س�����")
	print()
	print()
	print()
	print()
	io.write(colors.green .. "�����벢��Enter��: " .. colors.reset)
        local choice111 = io.read()
        if choice111 == "1" then
            os.execute("explorer file\\tool\\SN��ѯ")
        elseif choice111 == "2" then
		    os.execute("explorer file\\tool\\Pandora_R22.20.1701")
        elseif choice111 == "3" then
		    os.execute("explorer file\\tool\\ResearchDownload")
        elseif choice111 == "4" then
		    os.execute("explorer file\\tool\\spd_dump")
        elseif choice111 == "5" then
		    print()
            print(colors.red .. colors.bright .. "����!���������豸WIFI������,���������[����Ц]" .. colors.reset)
            print()
            print()
		    io.write(colors.green .. "�豸WEB��ַ(���� 192.168.100.1): "  .. colors.red .. colors.bright)
             local ipAddress = io.read()
			 os.execute('start "" "http://'..ipAddress..'//postesim?postesim=%7B%22esim%22:0%7D"')
		else
            os.execute("bin\\lua54 lua\\helper.lua")
        end
end

 local function mifi_Studio() --����MifiStudio����ȡ�豸�ļ�
    print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	print()
	print()
	print(colors.green .. colors.bright .."ʹ��С��ʿ:".. colors.reset .. colors.green .. " 1.��������ֱ������MIFI֮�ҵ�ZXIC-RomKit������ȡ,�ù���������3.0ʱ���Ѿ�����")
	print()
	print()
	print()
	print()
	print(colors.red .. '��ȡ��ɺ�,����ȡ�����ݻ���ZXIC-RomKit��Ŀ¼��"Z."��ͷ���ļ�����'.. colors.reset)
	print()
	print(colors.bright .."��ѡ��Ҫ���еĲ�����")
    print()
    print(colors.cyan .. colors.bright .. "                      1.�򿪹���           2.����ȡĿ¼          3.����" .. colors.reset)
	print()
	io.write(colors.green .. "���������ֲ��� Enter ��: " .. colors.reset)
    local user_Studio_selection = io.read()
        if user_Studio_selection == "1" then
        os.execute("start file\\ZXIC-RomKit\\_ADBһ����ȡ�̼�.bat")
        elseif user_Studio_selection == "2" then
		os.execute("explorer file\\ZXIC-RomKit")
        end
 end

local function AD()  --Ϊ��ά���������ӵ�һ��С��档
os.execute('start "" "https://shimo.im/docs/RKAWMBJLgXu96aq8/"')
end

 local function set_wifi()  -- ����zxic����WIFI,4.1�汾����,24.11.14
    print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
    print()
	print(colors.red .. "ʹ����֪:".. colors.blue .. colors.bright .."Ŀǰ�汾�ݲ�֧�ָ�����·��������WiFi����,ֻ֧���޸�����WiFi����,֧������")
    print()
	print("         " .. "֧��С���ֱ��������󲿷������ַ����������WiFi��ʧ��WiFi�޷����ӵ�����,�볤���ָ�������ť��")
	print()
	print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	io.write(colors.green .. "�豸WEB��ַ(���� 192.168.100.1): "  .. colors.red .. colors.bright)
    local YOUR_IP = io.read()
    print()
    print(colors.blue .. colors.bright .."�����ڵ����ϵ�¼�豸��̨: http://".. YOUR_IP .."/".. colors.reset)
    print()
    io.write(colors.green .."��������� SSID: ".. colors.red .. colors.bright)
    local YOUR_SSID = io.read()
    print(colors.reset)
    io.write(colors.green .."�������豸��: ".. colors.red .. colors.bright)
    local MAX_Access = io.read()
    print(colors.reset)
    -- Prepare the POST data
    local DATA = "goformId=SET_WIFI_SSID1_SETTINGS&ssid=" .. YOUR_SSID ..
                "&broadcastSsidEnabled=0&MAX_Access_num=" .. MAX_Access ..
                "&security_mode=OPEN&cipher=2&NoForwarding=0&show_qrcode_flag=0&security_shared_mode=NONE"

    local TYPES = {
        'goform/goform_set_cmd_process',
        'reqproc/proc_post'
    }

    -- Function to perform the POST request
    local function requ(type)
        local command = "bin\\curl -s -X POST -d \"" .. DATA .. "\" \"http://" .. YOUR_IP .. "/" .. type .. "\" 1>nul 2>nul"
        os.execute(command)
    end

    -- Loop through the request types and execute
    for _, TYPE in ipairs(TYPES) do
        requ(TYPE)
    end

    -- Output result
    print(colors.green .."�����ʱWiFi�Ͽ��������óɹ�")
    print("����ʧ��")
    io.read(1)
end

-- ��ӡ����
local function print_title1()
    os.execute("cls")  -- ����
	print("(C) 2020-2025 ����punguin. All rights reserverd.".. colors.cyan .. colors.bright .. "                XZ.ж��        RE.ˢ������      EXIT.�˳�����\n".. colors.reset)

end

-- ��ӡ����
local function print_announcement()
    print()
    print(colors.blue .. colors.bright .. "���ֹ���:".. colors.red .."��������4GȦ���Ѿ���������������ͣ����\n" .. colors.reset)
    check_adb_status()  -- ADB״̬���
    check_serial() -- ����״̬���
	print(colors.green .. "\n" .. "Tips:���ֹٷ�QQȺ��������2000�˴�Ⱥ,��ӭ����" .. colors.underline_blue .. colors.bright .. "725700912" .. colors.reset)
	print()
	check_version() -- ��Ӱ汾��Ϣ���
	print(colors.blue .. colors.bright .. "���ƶ����°汾,������'new'����" .. colors.reset)
end

-- ��ӡѡ��
local function print_menu()
	print()
	print()
    print(colors.yellow .. "            01.�豸��Ϣ           02.�����豸adb       03.������װ       04.ADB�ն�      05.�豸������    " .. colors.reset)
    print(colors.cyan .. colors.bright .. "          =------ �����豸�ļ�-------------------------------------------------------------------------=" .. colors.reset)
    print(colors.cyan .. colors.bright .."          =                                                                                            =".. colors.reset)
    print(colors.cyan .. colors.bright .."          =".. colors.reset .. colors.yellow .."    A.��ȡMTD4����    B.����dongleˢ��MTD4     C.����MTDˢд����      D.�鿴����mtd����     ".. colors.reset .. colors.cyan ..colors.bright .."=" .. colors.reset)
    print(colors.cyan .. colors.bright .."          =                                                                                            =".. colors.reset)
	print(colors.cyan .. colors.bright .."          =".. colors.reset .. colors.yellow .."    E.д��WEB         F.����΢ͨɱ����ȥ��     G.�̼���ȡ�����                           ".. colors.reset .. colors.cyan ..colors.bright .."=" .. colors.reset)
	print(colors.cyan .. colors.bright .."          =                                                                                            =".. colors.reset)
    print(colors.cyan .. colors.bright .. "          =--------------------------------------------------------------------------------------------=" .. colors.reset)
	print("\n")
	print(colors.cyan .. colors.bright .. "     �����뵼����:" .. colors.reset)
    print()
	print(colors.yellow .. "         1.���ڹ���         2.��С������      3.1869����      4.����ζasr����(����)   5.Orz0000����(������)" .. colors.reset)
	print()
	print(colors.yellow .. "         6.zxic����WIFI     7.����ʧ����      ".. colors.underline_magenta .. "8.�Ϲ�ר�����" .. colors.reset .."  ".. colors.underline_green .. colors.bright .."9.Ҫ����������" .. colors.reset)
	print()
	print()
end

-- �û������Ӧ��ѡ��
    while true do
    print_title1()            --����
    print_announcement()      --����
    print_menu()              --�˵�
    io.write(colors.green .. "�����벢��Enter��: " .. colors.reset) --��ʾ�û�����
    local choice = io.read() --�����û�����
    if choice == "A" then
        os.execute("start bin\\lua54 lua\\app_zmtd-extract.lua") --��ȡ�����Ľű�
    elseif choice == "B" then
		os.execute("cls")
		os.execute("start file\\dongle_fun\\dongle_fun.bat") --����dongle_fun��Bat
    elseif choice == "C" then
        os.execute("start bin\\lua54 lua\\app_zmtd-brusque.lua")
    elseif choice == "D" then
        mtd_check()
		os.execute("pause")
    elseif choice == "E" then
        os.execute("start bin\\lua54 lua\\app_zfile-web.lua")
	elseif choice == "F" then
        ufi_nv_set()
	elseif choice == "G" then
        os.execute("explorer file\\OpenZxicEditor-For-Windows")
	elseif choice == "H" then
        mifi_Studio()
	elseif choice == "01" then
	    os.execute("start lua\\app_machine-material.lua")
	elseif choice == "02" then
        set_adb()
	elseif choice == "03" then
        install_drive()
	elseif choice == "04" then
        os.execute("start bin\\openadb.bat")
	elseif choice == "05" then
        os.execute("start devmgmt.msc")
	elseif choice == "1" then
        os.execute('start "" "https://atmaster.netlify.app/#/"')
	elseif choice == "2" then
        os.execute("start file\\tool\\YXF_TOOL.exe")
	elseif choice == "3" then
        os.execute("start file\\tool\\ZTE_PATCH_1.1.exe")
	elseif choice == "4" then
        os.execute("start file\\tool\\Watermelon-ASR_Tools.exe")
	elseif choice == "5" then
        os.execute("start file\\tool\\UFITOOL_MTD4.exe")
	elseif choice == "6" then
        set_wifi()
	elseif choice == "7" then
        os.execute('start "" "https://net.arsn.cn/"')
	elseif choice == "8" then
        uisoc()
	elseif choice == "9" then
	    AD()
	elseif choice == "new" then
        os.execute('start "" "http://punguin.cn/web-helper"')
    elseif choice == "C" then
         os.execute("start bin\\lua54 lua\\so.lua")
	elseif choice == "RE" then
        os.execute("bin\\lua54 lua\\helper.lua")
	elseif choice == "XZ" then
        os.execute("start unins000.exe")
		break
    elseif choice == "EXIT" then
        print(colors.red .. "�˳�������" .. colors.reset)
        break
    else
        print(colors.red .. "��Ч��ѡ������ԡ�" .. colors.reset)
		os.execute("pause")
    end
end