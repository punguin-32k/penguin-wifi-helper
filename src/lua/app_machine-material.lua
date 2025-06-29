-- machine_material.lua
-- ͨ��adb��ȡ�豸nv������������ֱ�۵�չʾ���û�
-- 
-- ��Ȩ (C) 2025 ����Punguin
--
-- ���������������������Ը��������������ᷢ����GNU Afferoͨ�ù������֤����������֤�ĵ�3�����ѡ��ģ��κκ����İ汾���·�������/���޸�������
-- ������ķ�����ϣ�����������á���û���κα�֤������û�������ı�֤��������ķַ���ϣ���������õģ���û���κα�֤������û��������������·���ʺ�ĳһ�ض�Ŀ�ĵı�֤�� �μ� GNU Afferoͨ�ù������֤�˽����ϸ�ڡ�
-- ��Ӧ���Ѿ��յ���һ��GNU Afferoͨ�ù������֤�ĸ����� ���û�У���μ�<https://www.gnu.org/licenses/>��
--
-- ��ϵ���ǣ�3618679658@qq.com
-- ChatGPTЭ��������д

-- ���ñ����봰�ڴ�С
os.execute("title �豸��Ϣ(By ����punguin)")
os.execute("mode con: cols=57 lines=35")

-- �����ⲿ��
local path = require("lua\\path") -- ����·��������
local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- ���û��ȴ�
print(colors.cyan .. colors.bright .. "���ڻ�ȡ..." .. colors.reset)
print() -- ����һ�п��п����ý�������

-- ����Ƿ��� adb �豸����
local function is_adb_device_connected()
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
		os.exit(1)  -- ��0��ʾ�쳣�˳�
	end
end

-- ���� nv ��ѯ��������Ӽ�⣩
function get_nv_value(param)
	is_adb_device_connected()  -- ����豸����δ���ӻ��˳��ű�

	local command = "bin\\adb shell nv get " .. param
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	local value = result:gsub("%s+", "")
	return value
end

-- �����Ӧ����(̫�಻��дע��)
local intype = get_nv_value("zcgmi")
local fota_platform = get_nv_value("fota_platform")
local cr_version = get_nv_value("cr_version")
local remo_web_sw_version = get_nv_value("remo_web_sw_version")
local hw_version = get_nv_value("hw_version")
local os_url = get_nv_value("os_url")
local Language = get_nv_value("Language")
local fota_oem = get_nv_value("fota_oem")
local apn_mode = get_nv_value("apn_mode")
local default_apn = get_nv_value("default_apn")
local SSID1 = get_nv_value("SSID1")
local m_SSID = get_nv_value("m_SSID")
local DMZEnable = get_nv_value("DMZEnable")
local upnpEnabled = get_nv_value("upnpEnabled")
local sntp_timezone = get_nv_value("sntp_timezone")
local wifiEnabled = get_nv_value("wifiEnabled")
local max_station_num = get_nv_value("MAX_Station_num")
local sim_unlock_code = get_nv_value("sim_unlock_code")
local remo_sim_admin_password = get_nv_value("remo_sim_admin_password")
local admin_Password = get_nv_value("admin_Password")
local dhcpDns = get_nv_value("dhcpDns")
local tr069_enable = get_nv_value("tr069_enable")
local tr069_acs_url = get_nv_value("tr069_acs_url")
-- Remoר������ add Start 2025.06.25
local remo_sim_select = get_nv_value("remo_sim_select_display_type")
local remo_root_server_url = get_nv_value("fota_request_host")
local remo_root_server_url2 = get_nv_value("remo_fota_request_host")
local remo_root_server_url3 = get_nv_value("remo_dm_request_host")
local remo_root_server_port3 = get_nv_value("remo_dm_request_port")
local remo_root_server_path3 = get_nv_value("remo_dm_request_path")
local remo_config_server_url = get_nv_value("xinxun_iot_http_get_config_host")
local remo_config_server_path = get_nv_value("xinxun_iot_http_get_config_path")
local remo_led_server_url = get_nv_value("xinxun_iot_http_led_control_host")
local remo_led_server_path = get_nv_value("xinxun_iot_http_led_control_path")
local remo_flow_server_url = get_nv_value("xinxun_iot_http_flow_report_host")
local remo_flow_server_path = get_nv_value("xinxun_iot_http_flow_report_path")
local remo_info_server_url = get_nv_value("xinxun_iot_http_info_report_host")
local remo_info_server_path = get_nv_value("xinxun_iot_http_info_report_path")
-- Remoר������ add End
local fota_updateMode = get_nv_value("fota_updateMode")
local fota_updateIntervalDay = get_nv_value("fota_updateIntervalDay")
local fota_version_delta_url = get_nv_value("fota_version_delta_url")
local tc_enable = get_nv_value("tc_enable")
local tc_uplink = get_nv_value("tc_uplink")
local tc_downlink = get_nv_value("tc_downlink")

-- ����
os.execute("cls")

-- ��ʾ���
if intype ~= "" then
	print(colors.green .. colors.bright .. "�豸����: " .. intype .. "          ���ص�ƽ̨:" .. fota_platform .. colors.reset)
else
	print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T ϵͳ��Ϣ�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	print(colors.red .. colors.bright .. "�޷���ȡ�豸��������ص�ƽ̨" .. colors.reset)
end
if remo_web_sw_version ~= "" then
	print(colors.yellow .. colors.bright .. "����汾: " .. remo_web_sw_version .. colors.reset)
elseif cr_version ~= "" then
	print(colors.yellow .. colors.bright .. "����汾: " .. cr_version .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡ����汾" .. colors.reset)
end
if hw_version ~= "" then
	print(colors.yellow .. colors.bright .. "Ӳ���汾: " .. hw_version .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡӲ���汾" .. colors.reset)
end
if os_url ~= "" then
	print("���ҹ���: " .. os_url)
else
	print(colors.red .. colors.bright .. "���ҹ���:�޷���ȡ,����Ϊ��!" .. colors.reset)
end
if Language ~= "" then
	print(colors.green .. colors.bright .. "�豸����: " .. Language .. "            ��������:" .. fota_oem .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡ�豸��������������" .. colors.reset)
end
if apn_mode ~= "" then
	print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T ������Ϣ�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	print(colors.yellow .. colors.bright .. "APNģʽ: " .. apn_mode .. "            ��ǰAPN: " .. default_apn .. colors.reset)
else
	print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T ������Ϣ�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	print(colors.red .. colors.bright .. "�޷���ȡAPN��Ϣ" .. colors.reset)
end
if DMZEnable ~= "" then
	print(colors.yellow .. colors.bright .. "dmz״̬: " .. DMZEnable .. "               upnp״̬: " .. upnpEnabled .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡdmz��upnp��Ϣ" .. colors.reset)
end
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T WIFI��Ϣ�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
if max_station_num ~= "" then
	print(colors.green .. colors.bright .. "WIFI����: " .. wifiEnabled .. "              ���������: " .. max_station_num .. "��" .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡwifi��Ϣ" .. colors.reset)
end
if SSID1 ~= "" then
	print(colors.yellow .. colors.bright .. "��ǰWIFI����: " .. SSID1 .. "   ����WIFI����: " .. m_SSID .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡwifi��Ϣ" .. colors.reset)
end
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T ������Ϣ�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
if dhcpDns ~= "" then
	print(colors.bright .. "��̨��ַ: " .. dhcpDns .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡ��̨��Ϣ" .. colors.reset)
end
if admin_Password ~= "" then
	print(colors.yellow .. colors.bright .. "��̨����: " .. admin_Password .. colors.reset)
else
	print(colors.red .. colors.bright .. "�޷���ȡ��̨����" .. colors.reset)
end
if sim_unlock_code ~= "" then
    print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T ������بT�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	print(colors.yellow .. colors.bright .. "SIM������: " .. sim_unlock_code .. colors.reset)
else
end
if remo_sim_admin_password ~= "" then
    print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T ������بT�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
	print(colors.yellow .. colors.bright .. "SIMģʽ: " .. remo_sim_select .. colors.reset)
	print(colors.yellow .. colors.bright .. "SIM������: " .. remo_sim_admin_password .. colors.reset)
else
end
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T Զ�̿��ƨT�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)

-- tr069��ʾ
if tr069_enable ~= "" then
	print(colors.yellow .. colors.bright .. "tr069(acs)����: " .. tr069_enable .. "            tr069��ַ��" .. tr069_acs_url .. colors.reset)
	print(" ")
else
	print(" ")
end

-- �Զ�������ʾ
if fota_updateMode ~= "" then
	if fota_updateMode == "0" then
		print(colors.yellow .. colors.bright .. "�Զ��������ر�" .. colors.reset)
	else
		print(colors.yellow .. colors.bright .. "�Զ������� ��" ..
		      "       ���ʱ��: " .. fota_updateIntervalDay .. "��" .. colors.reset)
	end
	print(" ")
else
	print()
end

-- ������ʾ
if tc_enable ~= "" then
	if tc_enable == "0" then
		print(colors.yellow .. colors.bright .. "���ٿ���: ��" .. colors.reset)
	else
		print(colors.yellow .. colors.bright .. "���ٿ���: ��" ..
		      "       �ϴ�����: " .. tc_uplink ..
		      "       ��������: " .. tc_downlink .. colors.reset)
	end
	print(" ")
else
	print(colors.red .. colors.bright .. "�޷���ȡTC���豸Ӧ�ò�֧��" .. colors.reset)
end

-- Remoר��Զ�̷�������ʾ
local has_remo = false
if remo_root_server_url ~= "" then
	print(colors.yellow .. colors.bright .. "��������: " .. remo_root_server_url .. colors.reset)
	has_remo = true
end
if remo_root_server_url2 ~= "" then
	print(colors.yellow .. colors.bright .. "���÷�����: " .. remo_root_server_url2 .. colors.reset)
	has_remo = true
end
if remo_root_server_url3 ~= "" then
	local url3 = remo_root_server_url3
	if remo_root_server_port3 ~= "" then
		url3 = url3 .. ":" .. remo_root_server_port3
	end
	if remo_root_server_path3 ~= "" then
		url3 = url3 .. "/" .. remo_root_server_path3
	end
	print(colors.yellow .. colors.bright .. "���÷�����: " .. url3 .. colors.reset)
	has_remo = true
end
if remo_config_server_url ~= "" and remo_config_server_path ~= "" then
	print(colors.yellow .. colors.bright .. "���÷�����: " .. remo_config_server_url .. "/" .. remo_config_server_path .. colors.reset)
	has_remo = true
end
if remo_led_server_url ~= "" and remo_led_server_path ~= "" then
	print(colors.yellow .. colors.bright .. "LED���Ʒ�����: " .. remo_led_server_url .. "/" .. remo_led_server_path .. colors.reset)
	has_remo = true
end
if remo_flow_server_url ~= "" and remo_flow_server_path ~= "" then
	print(colors.yellow .. colors.bright .. "�����ϱ�������: " .. remo_flow_server_url .. "/" .. remo_flow_server_path .. colors.reset)
	has_remo = true
end
if remo_info_server_url ~= "" and remo_info_server_path ~= "" then
	print(colors.yellow .. colors.bright .. "��Ϣ�ϱ�������: " .. remo_info_server_url .. "/" .. remo_info_server_path .. colors.reset)
	has_remo = true
end
if has_remo then
	print(" ")
end

print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
print()

-- ����������˳�����
os.execute("pause")