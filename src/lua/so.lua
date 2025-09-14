-- so.lua
-- �򵥵�MTD��¼����(���Ʒ)
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
os.execute("title ����PINGUIN_run����д����     ��ǰ�汾: 1.0���԰�")
os.execute("mode con: cols=66 lines=35")

-- �����ⲿ��
local path = require("lua\\path") -- ����·��������
local colors = require("lua\\colors") -- ANSI��ɫ���
local delay = require("lua\\sleep") -- ����ʱ����

-- �����ʾ��Ϣ
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
print(colors.red .. '����!��������κ��ļ�����ֱ�Ӵ����豸/tmp/��' .. colors.reset)
print(colors.red .. "��ȷ���ļ�������3.19MB" .. colors.reset)
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)

-- ��ȡ�ű�����Ŀ¼
local script_dir = debug.getinfo(1).source:match("@?(.*/)")   --�趨һ����Ϊ"script_dir"����
if not script_dir then                                        --ѭ����ȡ"./"·��
    script_dir = "."
end

-- ��ʾ�û������ļ�·���������ļ�
io.write("�������ļ�·�����ļ����봰��: ")               --��ͣ�����ִ��,���û������ı�
local file_path = io.read()                                --���û�������ļ��趨Ϊ"file_path"����
file_path = file_path:gsub('^%"', ''):gsub('%"$', '')      --ȥ���ļ�·����˫���ţ�����У�

-- ����ļ��Ƿ����
local function file_exists(path)                           --��ȡ�����õ��ļ�����
    local file = io.open(path, "rb")                       --��ȡ�û��ո�������ļ�
    if file then                                           --ʣ�µĴ����Ǽ���ļ�
        file:close()
        return true
    else
        return false
    end
end

if not file_exists(file_path) then                         --����ļ������ڣ�����ʾ�û�
    print(colors.red .. "�ļ�������: " .. file_path .. "�ű����˳�" .. colors.reset)
    os.execute("pause")
	return
end

-- ���Ʋ��������ļ�
local destination_path = script_dir .. "/mtds.new"         --����Ҫ���������ļ�����"mtds.new"
local input_file = io.open(file_path, "rb")                --��������������"rb"
local output_file = io.open(destination_path, "wb")        --��������������"wb"

if input_file and output_file then                         --���и���������������
    output_file:write(input_file:read("*all"))
    input_file:close()
    output_file:close()
    print("�ļ��Ѹ��Ʋ�������Ϊ: " .. destination_path)    --������
else
    print("�ļ�����ʧ�ܡ�")                                --������
    os.execute("pause")
	return                                                 --�˳��ű�
end

-- ���busybox�ļ��Ƿ����
local busybox_path = script_dir .. "\\file\\busybox"              --����Ҫ�����ļ�����
if not file_exists(busybox_path) then                      --������
    print("busybox�ļ�������: " .. busybox_path)           --������
    os.execute("pause")
	return                                                 --�˳��ű�
end

-- ʹ��adb push���ļ����䵽�������豸��/tmp
os.execute('adb push "' .. destination_path .. '" /tmp/')  --ͨ��adb�ϴ��ļ�
os.execute('adb push "' .. busybox_path .. '" /tmp/')      --ͨ��adb�ϴ��ļ�
print(colors.green .. "�ļ���busybox�ѳ��Դ��䵽�豸��/tmpĿ¼��".. colors.reset)
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)

-- ɾ����ʱ�ļ�
os.execute("del mtds.new")                                 --ɾ��"mtds.new"�ļ�,�����û��ո��������ʱ�ļ�              

-- ѯ���û��Ƿ���йؼ��Բ���
print(colors.red .. '����!�������Ĳ����漰�ؼ�MTD�����' .. colors.reset)
print(colors.red .. colors.bright .. '������ʧ�ܿ��ܻᵼ�������豸�޷���������!' .. colors.reset)
print(colors.green .. '����ȷ���Ƿ�Ҫ����MTD����²���' .. colors.reset)
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
io.write("������'yes'�Լ�����")                            --��ͣ�����ִ��,���û������ı�
local input = io.read()                                    --���û��ո�����ı�����Ϊ"input"����
if input ~= "yes" then                                     --�ȶ��û��������Ƿ�Ϊ"yes"
  print("��δͬ�⣬�����˳���")
  print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
  os.execute("pause")
  os.exit() -- �˳�����
  else
  print(colors.green .. "����ͬ�⣬����ִ�г���" .. colors.reset)
  print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
end

print(colors.red .. '!��������󼤻����߳�,��������Ŀ���ʱ��!' .. colors.reset)
delay.sleep(5) -- �ӳ�5��
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)

-- ����MTD�����/ˢд����
print(colors.cyan .. colors.bright .. "���ڳ��Ը���busybox�ؼ�Ȩ��" .. colors.reset)
os.execute("adb shell chmod +x /tmp/busybox")
print(colors.green .."busybox�ѱ������дȨ��".. colors.reset)
print(" ")
print(colors.cyan .. colors.bright .. "���ڳ���ʹ��ddˢдMTD4" .. colors.reset)
os.execute("adb shell /tmp/busybox nohup dd if=/tmp/mtds.new of=/dev/mtd4 &")
print(colors.red .. "�����޸���Ϻ��������Զ������豸" .. colors.reset)
print(colors.bright .. "(==0%)" .. colors.reset)
delay.sleep(10) -- �ӳ�10��
print(colors.bright .. "(=======20%)" .. colors.reset)
print(colors.bright .. "(=============30%)" .. colors.reset)
print(colors.bright .. "(===================40%)" .. colors.reset)
print(colors.bright .. "(=========================50%)" .. colors.reset)
print(colors.bright .. "(===============================66%)" .. colors.reset)
delay.sleep(10) -- �ӳ�10��
print(colors.bright .. "(======================================79%)" .. colors.reset)
delay.sleep(9) -- �ӳ�9��
print(colors.bright .. "(===========================================83%)" .. colors.reset)
delay.sleep(12) -- �ӳ�12��
print(colors.bright .. "(=================================================96%)" .. colors.reset)
delay.sleep(6) -- �ӳ�6��
print(colors.bright .. "(=======================================================99%)" .. colors.reset)
delay.sleep(60) -- �ӳ�һ����
print(colors.cyan .. colors.bright .. "�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" .. colors.reset)
print(colors.green .. "��д�Ѿ������,������˵�豸������������" .. colors.reset)
print(colors.red .. "�������������ȴ������Ӻ��ٰγ�" .. colors.reset)
print(colors.red .. "�п���ˢ��ʱ��������Ԥ�Ƶ�ʱ�䲻ͬ" .. colors.reset)
os.execute("pause")