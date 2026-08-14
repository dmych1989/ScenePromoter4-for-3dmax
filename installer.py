#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
场景助手 4 安装程序 (Python 版, 单文件自解压)
-------------------------------------------------
安装逻辑：
  1. 从注册表扫描本机所有已安装的 3ds Max 版本（同时查 64 位与 32 位视图）
  2. 列出菜单让用户勾选要安装到哪些版本（支持多选 / 全部）
  3. 将内嵌的 payload.zip 解压到临时目录，再把：
        ScenePromoter4/  ->  <Max>\\scripts\\ScenePromoter4\\
        SP4_startup.ms   ->  <Max>\\scripts\\Startup\\SP4_startup.ms
  3ds Max 启动时会自动加载 Startup 里的 SP4_startup.ms，再 filein 各主脚本。
"""

import os
import sys
import zipfile
import shutil
import tempfile

try:
    import winreg
except ImportError:
    winreg = None

VERSION = "4.3.0"
AUTHOR = "山医命相卜"
QQGROUP = "756653752"

# 3ds Max 主版本号 -> 发布年份（仅用于友好显示，不影响安装）
MAX_VERSION_NAMES = {
    "9.0": "2007", "11.0": "2009", "12.0": "2010", "13.0": "2011",
    "14.0": "2012", "15.0": "2013", "16.0": "2014", "17.0": "2015",
    "18.0": "2016", "19.0": "2017", "20.0": "2018", "21.0": "2019",
    "22.0": "2020", "23.0": "2021", "24.0": "2022", "25.0": "2023",
    "26.0": "2024", "27.0": "2025", "28.0": "2026",
}


def setup_encoding():
    """让 Windows 控制台正确显示中文（GBK / 代码页 936）。"""
    try:
        if hasattr(sys.stdout, "reconfigure"):
            sys.stdout.reconfigure(encoding="gbk")
        if hasattr(sys.stderr, "reconfigure"):
            sys.stderr.reconfigure(encoding="gbk")
    except Exception:
        pass


def resource_path(filename):
    """打包后资源在 sys._MEIPASS 下；开发模式下在同目录。"""
    if getattr(sys, "frozen", False):
        base = getattr(sys, "_MEIPASS", os.path.dirname(sys.executable))
    else:
        base = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(base, filename)


def find_payload():
    for cand in (resource_path("payload.zip"),
                 os.path.join(os.path.dirname(os.path.abspath(__file__)), "payload.zip")):
        if os.path.isfile(cand):
            return cand
    return None


def enum_max_installs():
    """返回 [(显示名, 安装目录), ...]，扫描 64/32 位注册表视图并去重。"""
    results = []
    seen = set()
    if winreg is None:
        return results
    roots = [
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Autodesk\3dsMax", winreg.KEY_WOW64_64KEY),
        (winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Autodesk\3dsMax", winreg.KEY_WOW64_32KEY),
    ]
    for hkey, sub, flag in roots:
        try:
            key = winreg.OpenKey(hkey, sub, 0, winreg.KEY_READ | flag)
        except OSError:
            continue
        try:
            count = winreg.QueryInfoKey(key)[0]
            for i in range(count):
                ver = winreg.EnumKey(key, i)
                try:
                    vkey = winreg.OpenKey(key, ver, 0, winreg.KEY_READ | flag)
                    inst = winreg.QueryValueEx(vkey, "Installdir")[0]
                    winreg.CloseKey(vkey)
                except OSError:
                    continue
                if not inst:
                    continue
                inst = inst.replace("/", "\\")
                if not inst.endswith("\\"):
                    inst += "\\"
                norm = os.path.normcase(os.path.normpath(inst))
                if norm in seen:
                    continue
                seen.add(norm)
                year = MAX_VERSION_NAMES.get(ver, "")
                name = ("3ds Max %s (v%s)" % (year, ver)) if year else ("3ds Max v%s" % ver)
                results.append((name, inst))
        finally:
            winreg.CloseKey(key)
    results.sort(key=lambda x: x[1])
    return results


def copy_tree(src, dst):
    os.makedirs(dst, exist_ok=True)
    for entry in os.listdir(src):
        s = os.path.join(src, entry)
        d = os.path.join(dst, entry)
        if os.path.isdir(s):
            copy_tree(s, d)
        else:
            shutil.copy2(s, d)


def main():
    setup_encoding()
    print("=" * 44)
    print("    场景助手 %s 安装程序" % VERSION)
    print("    作者：%s" % AUTHOR)
    print("    QQ群：%s" % QQGROUP)
    print("=" * 44)
    print("")

    payload = find_payload()
    if not payload:
        print("错误：未找到安装数据 payload.zip！")
        input("按回车退出...")
        return

    print("正在检测本机已安装的 3ds Max ...")
    installs = enum_max_installs()
    if not installs:
        print("未检测到任何 3ds Max 安装。")
        print("若 3ds Max 安装在非标准位置或注册表项缺失，可手动输入。")
        manual = input("请输入 3ds Max 安装目录(含末尾反斜杠, 如 C:\\Program Files\\Autodesk\\3ds Max 2022\\)：").strip()
        if not manual:
            print("未提供路径，已退出。")
            input("按回车退出...")
            return
        manual = manual.replace("/", "\\")
        if not manual.endswith("\\"):
            manual += "\\"
        installs = [("手动指定路径", manual)]

    print("")
    print("检测到以下 3ds Max 版本：")
    for idx, (name, _) in enumerate(installs, 1):
        print("  [%d] %s" % (idx, name))
    print("")
    print("请选择要安装到的版本 —— 输入序号, 多个用空格分隔(如 '1 3'), 输入 'all' 安装全部：")
    choice = input("选择：").strip()
    if choice.lower() == "all":
        selected = list(range(len(installs)))
    else:
        selected = []
        for part in choice.replace(",", " ").split():
            try:
                n = int(part)
                if 1 <= n <= len(installs):
                    selected.append(n - 1)
            except ValueError:
                pass
    selected = sorted(set(selected))
    if not selected:
        print("未选择任何版本，已退出。")
        input("按回车退出...")
        return

    print("")
    print("开始安装 ...")

    temp_dir = tempfile.mkdtemp(prefix="SP4_")
    try:
        with zipfile.ZipFile(payload, "r") as z:
            z.extractall(temp_dir)

        src_plugin = os.path.join(temp_dir, "ScenePromoter4")
        src_startup = os.path.join(temp_dir, "SP4_startup.ms")

        for idx in selected:
            name, max_dir = installs[idx]
            print("")
            print(">> 安装到 %s (%s)" % (name, max_dir))
            try:
                plugin_dir = os.path.join(max_dir, "scripts", "ScenePromoter4")
                startup_dir = os.path.join(max_dir, "scripts", "Startup")
                os.makedirs(plugin_dir, exist_ok=True)
                os.makedirs(startup_dir, exist_ok=True)
                if os.path.isdir(src_plugin):
                    copy_tree(src_plugin, plugin_dir)
                    print("   插件目录: %s" % plugin_dir)
                else:
                    print("   警告：压缩包内缺少 ScenePromoter4 目录")
                if os.path.isfile(src_startup):
                    dst = os.path.join(startup_dir, "SP4_startup.ms")
                    shutil.copy2(src_startup, dst)
                    print("   启动脚本: %s" % dst)
                else:
                    print("   警告：压缩包内缺少 SP4_startup.ms")
            except PermissionError:
                print("   失败：权限不足！请右键本程序『以管理员身份运行』后重试。")
            except Exception as e:
                print("   失败：%s" % e)

        print("")
        print("安装完成！重启对应的 3ds Max 即可使用场景助手 %s。" % VERSION)
    except Exception as e:
        print("安装过程出错：%s" % e)
    finally:
        try:
            shutil.rmtree(temp_dir, ignore_errors=True)
        except Exception:
            pass

    input("按回车退出...")


if __name__ == "__main__":
    main()
