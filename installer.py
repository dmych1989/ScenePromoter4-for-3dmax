#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
场景助手 4 安装程序 (Python 版, 单文件自解压, 图形界面)
--------------------------------------------------------
安装逻辑：
  1. 从注册表扫描本机所有已安装的 3ds Max 版本（同时查 64 位与 32 位视图）
  2. 在窗口中以勾选框列出，用户勾选要安装到哪些版本
  3. 将内嵌的 payload.zip 解压到临时目录，再把：
        ScenePromoter4/  ->  <Max>\\scripts\\ScenePromoter4\\
        SP4_startup.ms   ->  <Max>\\scripts\\Startup\\SP4_startup.ms
  3ds Max 启动时会自动加载 Startup 里的 SP4_startup.ms，再 filein 各主脚本。

说明：使用 Tkinter 图形界面，文字为 Unicode 原生显示，不再受 Windows
控制台代码页影响（旧版控制台方式在部分系统上会出现中文乱码）。
"""

import os
import sys
import zipfile
import shutil
import tempfile

try:
    import tkinter as tk
    from tkinter import messagebox, scrolledtext
except ImportError:
    tk = None

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


class InstallerApp:
    def __init__(self, root):
        self.root = root
        self.checks = []          # [(BooleanVar, name, path), ...]
        self.payload = find_payload()

        root.title("场景助手 %s 安装程序" % VERSION)
        root.geometry("580x640")
        root.resizable(True, True)

        # ---- 标题区 ----
        head = tk.Frame(root, padx=12, pady=8)
        head.pack(fill=tk.X)
        tk.Label(head, text="场景助手 %s 安装程序" % VERSION,
                 font=("Microsoft YaHei", 16, "bold")).pack(anchor=tk.W)
        tk.Label(head, text="作者：%s     QQ群：%s" % (AUTHOR, QQGROUP),
                 font=("Microsoft YaHei", 10), fg="#555555").pack(anchor=tk.W)

        # ---- 版本列表区 ----
        mid = tk.Frame(root, padx=12)
        mid.pack(fill=tk.BOTH, expand=True)

        tk.Label(mid, text="检测到以下 3ds Max 版本，勾选要安装到的版本：",
                 font=("Microsoft YaHei", 11), anchor=tk.W).pack(fill=tk.X, pady=(4, 6))

        list_frame = tk.Frame(mid)
        list_frame.pack(fill=tk.BOTH, expand=True)

        self.canvas = tk.Canvas(list_frame)
        self.scroll = tk.Scrollbar(list_frame, orient=tk.VERTICAL, command=self.canvas.yview)
        self.canvas.configure(yscrollcommand=self.scroll.set)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.scroll.pack(side=tk.RIGHT, fill=tk.Y)

        self.inner = tk.Frame(self.canvas)
        self.canvas.create_window((0, 0), window=self.inner, anchor=tk.NW)
        self.inner.bind("<Configure>",
                        lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all")))

        btn_row = tk.Frame(mid)
        btn_row.pack(fill=tk.X, pady=6)
        tk.Button(btn_row, text="全选", width=8, command=self.select_all).pack(side=tk.LEFT, padx=4)
        tk.Button(btn_row, text="全不选", width=8, command=self.select_none).pack(side=tk.LEFT, padx=4)

        # ---- 手动添加路径 ----
        man = tk.Frame(mid)
        man.pack(fill=tk.X, pady=(0, 8))
        tk.Label(man, text="未检测到？手动指定 3ds Max 安装目录：").pack(anchor=tk.W)
        row = tk.Frame(man)
        row.pack(fill=tk.X)
        self.manual_var = tk.StringVar()
        tk.Entry(row, textvariable=self.manual_var, font=("Microsoft YaHei", 10)).pack(
            side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 6))
        tk.Button(row, text="添加", width=8, command=self.add_manual).pack(side=tk.RIGHT)

        # ---- 安装按钮 ----
        act = tk.Frame(root, padx=12, pady=8)
        act.pack(fill=tk.X)
        self.install_btn = tk.Button(
            act, text="安装所选版本", font=("Microsoft YaHei", 12, "bold"),
            bg="#2e7d32", fg="white", height=1, command=self.on_install)
        self.install_btn.pack(fill=tk.X)

        # ---- 日志区 ----
        log_frame = tk.Frame(root, padx=12, pady=(0, 10))
        log_frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(log_frame, text="安装日志：", font=("Microsoft YaHei", 10)).pack(anchor=tk.W)
        self.log = scrolledtext.ScrolledText(
            log_frame, height=10, font=("Consolas", 9), state=tk.DISABLED)
        self.log.pack(fill=tk.BOTH, expand=True)

        # ---- 填充版本 ----
        self.populate()

        if not self.payload:
            self.log_print("错误：未找到安装数据 payload.zip！")
            messagebox.showerror("错误", "未找到安装数据 payload.zip，安装无法继续。")
            self.install_btn.configure(state=tk.DISABLED)

    # ---------- 界面逻辑 ----------
    def log_print(self, msg):
        self.log.configure(state=tk.NORMAL)
        self.log.insert(tk.END, msg + "\n")
        self.log.see(tk.END)
        self.log.configure(state=tk.DISABLED)
        self.root.update_idletasks()

    def populate(self):
        installs = enum_max_installs()
        if not installs:
            self.log_print("未检测到已安装的 3ds Max（注册表中无 Autodesk\\3dsMax 项）。")
            self.log_print("如需安装，请用上方输入框手动指定安装目录。")
        for name, path in installs:
            self._add_check(name, path)

    def _add_check(self, name, path):
        var = tk.BooleanVar(value=True)
        cb = tk.Checkbutton(self.inner, text="%s   ->   %s" % (name, path),
                            variable=var, anchor=tk.W, font=("Microsoft YaHei", 10))
        cb.pack(fill=tk.X, padx=2, pady=1)
        self.checks.append((var, name, path))

    def select_all(self):
        for var, _, _ in self.checks:
            var.set(True)

    def select_none(self):
        for var, _, _ in self.checks:
            var.set(False)

    def add_manual(self):
        p = self.manual_var.get().strip().replace("/", "\\")
        if not p:
            return
        if not p.endswith("\\"):
            p += "\\"
        # 去重
        for _, _, existing in self.checks:
            if os.path.normcase(os.path.normpath(p)) == os.path.normcase(os.path.normpath(existing)):
                self.log_print("该路径已存在，忽略：%s" % p)
                return
        self._add_check("手动指定: %s" % p, p)
        self.manual_var.set("")
        self.log_print("已添加手动路径：%s" % p)

    # ---------- 安装逻辑 ----------
    def on_install(self):
        selected = [(name, path) for var, name, path in self.checks if var.get()]
        if not selected:
            messagebox.showwarning("提示", "请至少勾选一个 3ds Max 版本。")
            return

        self.install_btn.configure(state=tk.DISABLED)
        try:
            self.do_install(selected)
        finally:
            self.install_btn.configure(state=tk.NORMAL)

    def do_install(self, selected):
        temp_dir = tempfile.mkdtemp(prefix="SP4_")
        try:
            with zipfile.ZipFile(self.payload, "r") as z:
                z.extractall(temp_dir)

            src_plugin = os.path.join(temp_dir, "ScenePromoter4")
            src_startup = os.path.join(temp_dir, "SP4_startup.ms")

            ok = 0
            for name, max_dir in selected:
                self.log_print(">> 安装到 %s (%s)" % (name, max_dir))
                try:
                    plugin_dir = os.path.join(max_dir, "scripts", "ScenePromoter4")
                    startup_dir = os.path.join(max_dir, "scripts", "Startup")
                    os.makedirs(plugin_dir, exist_ok=True)
                    os.makedirs(startup_dir, exist_ok=True)
                    if os.path.isdir(src_plugin):
                        copy_tree(src_plugin, plugin_dir)
                        self.log_print("   插件目录 -> %s" % plugin_dir)
                    else:
                        self.log_print("   警告：压缩包内缺少 ScenePromoter4 目录")
                    if os.path.isfile(src_startup):
                        dst = os.path.join(startup_dir, "SP4_startup.ms")
                        shutil.copy2(src_startup, dst)
                        self.log_print("   启动脚本 -> %s" % dst)
                    else:
                        self.log_print("   警告：压缩包内缺少 SP4_startup.ms")
                    ok += 1
                except PermissionError:
                    self.log_print("   失败：权限不足！请右键本程序『以管理员身份运行』后重试。")
                except Exception as e:
                    self.log_print("   失败：%s" % e)

            self.log_print("")
            if ok:
                self.log_print("安装完成 %d/%d！重启对应的 3ds Max 即可使用场景助手 %s。"
                               % (ok, len(selected), VERSION))
                messagebox.showinfo("完成",
                                    "已成功安装 %d 个版本。\n重启对应的 3ds Max 即可使用场景助手 %s。"
                                    % (ok, VERSION))
            else:
                self.log_print("没有任何版本安装成功，请检查权限或路径后重试。")
        except Exception as e:
            self.log_print("安装过程出错：%s" % e)
            messagebox.showerror("错误", "安装过程出错：%s" % e)
        finally:
            try:
                shutil.rmtree(temp_dir, ignore_errors=True)
            except Exception:
                pass


def main():
    if tk is None:
        # 窗口程序里 print 不可见，用 Win32 消息框给出明确错误
        try:
            import ctypes
            ctypes.windll.user32.MessageBoxW(
                0,
                "安装程序无法启动：当前运行环境缺少 Tkinter (tcl/tk) 组件。\n"
                "请重新下载最新版本的安装包。",
                "场景助手 安装程序 - 错误", 0x10)
        except Exception:
            pass
        return
    root = tk.Tk()
    try:
        # 让界面使用系统默认中文字体更顺眼
        root.tk.call("tk", "scaling", 1.0)
    except Exception:
        pass
    InstallerApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
