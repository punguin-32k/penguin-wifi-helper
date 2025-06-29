-- zmtd-brusque
-- ���WiFi���� ˢд��V2.1
-- 
-- ��Ȩ (C) 2025 ����Punguin
--
-- ���������������������Ը��������������ᷢ����GNU Afferoͨ�ù������֤����������֤�ĵ�3�����ѡ��ģ��κκ����İ汾���·�������/���޸�������
-- ������ķ�����ϣ�����������á���û���κα�֤������û�������ı�֤��������ķַ���ϣ���������õģ���û���κα�֤������û��������������·���ʺ�ĳһ�ض�Ŀ�ĵı�֤�� �μ� GNU Afferoͨ�ù������֤�˽����ϸ�ڡ�
-- ��Ӧ���Ѿ��յ���һ��GNU Afferoͨ�ù������֤�ĸ����� ���û�У���μ�<https://www.gnu.org/licenses/>��
--
-- ��ϵ���ǣ�3618679658@qq.com
-- ChatGPTЭ��������д

-- �贰�ڱ���
os.execute("title ���WiFi����  MTDˢдV2.1")
os.execute("mode con: cols=80 lines=32")

-- �����ⲿ��
local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- �ն�������ִ��
local function exec(cmd)
    --print("[ִ������] " .. cmd)
    local f = io.popen(cmd .. " 2>&1")
    local res = f:read("*a")
    f:close()
    --print("[�������] " .. res)
    return res
	-- �����Ҫ���Գ��򣬽�����printȥ��ע��
end

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

local function copy_to_workdir(src_path)
    local filename = src_path:match("([^\\/]+)$")
    exec(string.format('copy /Y "%s" "mtd.bin"', src_path))
    return "mtd.bin"
end

local function get_local_md5(file)
    local output = exec(string.format('bin\\md5sum.exe "%s"', file))
    local md5 = output:match("^(%x+)")
    if not md5 then
        error("[!] �޷���������MD5�����Ϊ: " .. output)
    end
    return md5
end

local function adb_push(local_file, device_file)
    local cmd = string.format('bin\\adb push "%s" "%s"', local_file, device_file)
    exec(cmd)
end

local function get_device_md5(device_file)
    local output = exec(string.format('bin\\adb shell md5sum "%s"', device_file))
    local md5 = output:match("^(%x+)")
    if not md5 then
        error("[!] �޷������豸��MD5�����Ϊ: " .. output)
    end
    return md5
end

local function compare_md5(local_md5, device_md5)
    print("\n" .. colors.cyan .. colors.bright .."------------------ ".. colors.blue .. colors.bright .."�ļ�����У��".. colors.reset .. colors.cyan .. colors.bright .." ------------------")
    print(string.format(colors.cyan .. colors.bright .."[".. colors.blue .. colors.bright .."*".. colors.cyan .. colors.bright .."]".. colors.blue .." �����ļ� :    ".. colors.reset .. colors.green .."%s", local_md5))
    print(string.format(colors.cyan .. colors.bright .."[".. colors.blue .. colors.bright .."*".. colors.cyan .. colors.bright .."]".. colors.blue .." �豸�ļ� :    ".. colors.reset .. colors.green .."%s", device_md5))
    if local_md5:lower() == device_md5:lower() then
        print(colors.cyan .. colors.bright .."[".. colors.green .."��".. colors.cyan .. colors.bright .."]".. colors.green ..  colors.bright .." У��һ�£��ļ�����ɹ�")
		print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
    else
        print(colors.cyan .. colors.bright .."[".. colors.red .."!".. colors.cyan .. colors.bright .."]".. colors.red .. colors.bright .."У��ʧ�ܣ��ļ������𻵣�����ֹˢд���������豸�����¿�ʼ")
		print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
		os.execute("pause")
        os.exit(1)
    end
end

local function prepare_device_environment()
    exec('bin\\adb shell mount -t tmpfs rw,remount /tmp')
    adb_push('file\\busybox', '/tmp/')
    exec('bin\\adb shell ln -s /tmp/busybox /tmp/dd')
    exec('bin\\adb shell ln -s /tmp/busybox /tmp/sh')
    exec('bin\\adb shell ln -s /tmp/busybox /tmp/reboot')
    exec('bin\\adb shell chmod +x /tmp/busybox /tmp/dd /tmp/sh /tmp/reboot')
end

local function optional_backup()
    print(colors.blue .. colors.bright .."�Ƿ���б��ݵ�ǰ����".. colors.cyan .. colors.bright .."(".. colors.red .."���ݽ��ķѽϳ�ʱ��".. colors.cyan .. colors.bright ..")".. colors.yellow .. colors.bright .." [��Ҫ��yes���س�����]")
    local choice = io.read()
	print(colors.reset)
    if choice:lower() == "yes" then
        -- ��ȡ��ǰʱ�䲢��ʽ��Ϊ: ������Сʱ���� (���磺202506151519)
        local timestamp = os.date("%Y%m%d%H%M")

        -- ��ȡ�û�����·��
        local userprofile = os.getenv("USERPROFILE")
        local backup_folder = userprofile .. "\\Desktop\\MTD��������"
        local filename = string.format("MTD4����%s.bin", timestamp)
        local desktop_path = backup_folder .. "\\" .. filename

        -- ���������ļ��У�ȷ�����ڣ�
        os.execute('mkdir "' .. backup_folder .. '" 2>nul')

        -- ����readme�ļ�
        local readme_path = backup_folder .. "\\readme.txt"
        local readme_file = io.open(readme_path, "w")
        if readme_file then
            readme_file:write("���ļ������������MTDˢд�����ɣ�����ѡ��MTD�ļ����ݡ�\n������֧�ֶ�α��ݲ�������ԭ�ļ���������ɾ��ԭ�ļ���\n\n�����Խ����ݵ�MTD�ļ�����д���豸��")
            readme_file:close()
        end

        -- ִ�б���
        local command = string.format('bin\\adb pull /dev/mtd4 "%s" > NUL 2>&1', desktop_path)
        os.execute(command)

        print(colors.cyan .. colors.bright .."[".. colors.green .."��".. colors.cyan .. colors.bright .."]".. colors.blue .. colors.bright .." ������ɣ��ѱ���������:\n".. colors.yellow .. colors.bright .. desktop_path .. colors.reset)
		print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
		
    else
        print(colors.cyan .. colors.bright .."[".. colors.red .."!".. colors.cyan .. colors.bright .."]".. colors.red .." ��ѡ�����豸�ݣ��������ݲ���".. colors.reset)
		print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
    end
end

local function upload_flash_files()
    exec('bin\\adb shell killall -9 zte_ufi')
    exec('bin\\adb shell killall -9 zte_mifi')
    exec('bin\\adb shell killall -9 zte_cpe')
    exec('bin\\adb shell killall -9 goahead')
    adb_push('mtd.bin', '/tmp/mtd4.bin')
    exec('bin\\adb shell mkdir -p /mnt/userdata/temp/')
end

local function write_flash_script()
    -- �����豸
    adb_push("file\\flash.sh", "/mnt/userdata/temp/flash.sh")
    exec('bin\\adb shell chmod +x /mnt/userdata/temp/flash.sh')
end

local function final_confirmation()
    print()
    print(colors.yellow .. colors.bright .."ȫ���ļ���".. colors.green .."���ͳɹ�".. colors.yellow .. colors.bright .."���ļ�����".. colors.green .."У�����")
	print()
    print(colors.yellow .. colors.bright .."�����ȷ�����ṩ��".. colors.red .."�ļ��Ƿ���ȷ".. colors.yellow .. colors.bright .."��������".. colors.red .."���Ļ��ᡣ")
    print(colors.yellow .. colors.bright .."���".. colors.green .."ȷ��������������5�λس�".. colors.yellow .. colors.bright .."��".. colors.red .."�������̰ε�����!".. colors.reset)
    for i = 1, 5 do io.read() end
end

local function execute_flash()
    print(colors.red .. colors.bright .."���棺".. colors.green .."������ʼˢд".. colors.yellow .. colors.bright .."��".. colors.red .. colors.bright .."�����ڻᱻadbռ�á�".. colors.reset)
    print(colors.red .. colors.bright .."��ʱ��Ҫ�������̣��Է�����ָ�����룡����".. colors.reset)
	print(colors.green .. colors.bright .."���������ٰ����λس�����л��ϣ�".. colors.reset)
    for i = 1, 2 do io.read() end
    print(colors.cyan .. colors.bright .."[".. colors.green .."��".. colors.cyan .. colors.bright .."]".. colors.green ..  colors.bright .."ˢд�������ڽ��У���Ҫ�رձ����ڣ������ĵȴ��豸����....".. colors.reset)
    os.execute("bin\\adb shell ./mnt/userdata/temp/flash.sh &")
	print()
    print(colors.cyan .. colors.bright .."[".. colors.red .."!".. colors.cyan .. colors.bright .."]".. colors.green ..  colors.bright .."�豸ˢд��ɣ���ȴ��豸��������лʹ�á�".. colors.reset)
	print(colors.green .. colors.bright .."����������һ�µƹػ�����ש�ˣ����ñ�����Ȼأ�".. colors.reset)
    os.execute("pause") -- ���������
end

local function print_flash()
    print(colors.cyan .. colors.bright .."[".. colors.blue .. colors.bright .."$".. colors.cyan .. colors.bright .."]".. colors.blue .." ��ȴ��ļ���������������豸......".. colors.reset)
end

local function print_tip()
    print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
end

------------------ ������ ------------------
is_adb_device_connected()

print(colors.yellow .. colors.bright .."�뽫Ҫд����ļ�����˴��ں󰴻س���".. colors.red)
local user_path = io.read()
print(colors.reset)
copy_to_workdir(user_path)

local local_md5 = get_local_md5("mtd.bin")
adb_push("mtd.bin", "/tmp/mtd4.bin")
local device_md5 = get_device_md5("/tmp/mtd4.bin")
compare_md5(local_md5, device_md5)

prepare_device_environment()
optional_backup()
print_flash()
upload_flash_files()
print_tip()
write_flash_script()
final_confirmation()
execute_flash()