#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
场景助手 4 安装包打包脚本 (Python 版)
--------------------------------------
用法: 用本虚拟环境里的 python 运行  python build_installer.py
产物: dist\\场景助手4_3_0.exe  (单文件, 请求管理员权限, 内嵌 payload.zip)

步骤:
  1. 暂存插件文件到 _sp4_stage\\ScenePromoter4\\
  2. 把 SP4_startup.ms 放到暂存根目录 (3ds Max 的 Startup 目录需要它)
  3. 把整个暂存目录压缩成 payload.zip
  4. 用 PyInstaller 把 installer.py + payload.zip 打包成独立 exe
"""

import os
import sys
import zipfile
import shutil
import subprocess

PROJECT = os.path.dirname(os.path.abspath(__file__))
STAGE = os.path.join(PROJECT, "_sp4_stage")
PAYLOAD = os.path.join(PROJECT, "payload.zip")
OUT_NAME = "场景助手4_3_0"
INSTALLER = os.path.join(PROJECT, "installer.py")

# 需要打进安装包的插件内容（白名单，避免把 exe/脚本自身也塞进去）
STAGE_FILES = [
    "CGplusplusFunc.ms",
    "SPMainRollout.ms",
    "ScenePromoter.ms",
    "ScenePromoter4.ini",
    "ScenePromotermcr.ms",
    "SP4_startup.ms",
    "ReadMe.txt",
]
STAGE_DIRS = ["Lib", "Help", "images"]


def stage_files():
    # 复用暂存目录（覆盖写入即可），避免批量删除触发某些环境的拦截
    plugin_dir = os.path.join(STAGE, "ScenePromoter4")
    os.makedirs(plugin_dir, exist_ok=True)

    for f in STAGE_FILES:
        src = os.path.join(PROJECT, f)
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(plugin_dir, f))
        else:
            print("  [警告] 缺少文件: %s" % f)

    for d in STAGE_DIRS:
        src = os.path.join(PROJECT, d)
        if os.path.isdir(src):
            shutil.copytree(src, os.path.join(plugin_dir, d), dirs_exist_ok=True)
        else:
            print("  [警告] 缺少目录: %s" % d)

    # 启动脚本放到暂存根目录（安装时复制到 <Max>\\scripts\\Startup\\）
    shutil.copy2(os.path.join(PROJECT, "SP4_startup.ms"),
                 os.path.join(STAGE, "SP4_startup.ms"))


def make_zip():
    if os.path.exists(PAYLOAD):
        os.remove(PAYLOAD)
    with zipfile.ZipFile(PAYLOAD, "w", zipfile.ZIP_DEFLATED) as z:
        for root, _, files in os.walk(STAGE):
            for fn in files:
                full = os.path.join(root, fn)
                arc = os.path.relpath(full, STAGE).replace("/", "\\")
                z.write(full, arc)
    size = os.path.getsize(PAYLOAD)
    print("  压缩包大小: %.1f KB" % (size / 1024.0))


def build_exe():
    dist = os.path.join(PROJECT, "dist")
    build = os.path.join(PROJECT, "build")
    spec = os.path.join(PROJECT, OUT_NAME + ".spec")
    for p in (dist, build):
        if os.path.exists(p):
            shutil.rmtree(p)
    if os.path.exists(spec):
        os.remove(spec)

    cmd = [
        sys.executable, "-m", "PyInstaller",
        "--onefile",
        "--windowed",            # 图形界面，无控制台（避免中文乱码）
        "--uac-admin",           # 请求管理员权限（写 Program Files 需要）
        "--collect-all", "tkinter",   # 确保把 tcl/tk 运行时一起打进 exe
        "--name", OUT_NAME,
        "--distpath", dist,
        "--workpath", build,
        "--add-data", "%s;." % PAYLOAD,   # 把 payload.zip 打进 exe
        INSTALLER,
    ]
    print("  执行: %s" % " ".join(cmd))
    subprocess.check_call(cmd)


def main():
    print("=== 场景助手 4 打包工具 (Python) ===")
    print("项目目录: %s\n" % PROJECT)

    print("[1/3] 暂存插件文件 ...")
    stage_files()

    print("[2/3] 生成 payload.zip ...")
    make_zip()

    print("[3/3] 编译安装包 ...")
    build_exe()

    out = os.path.join(PROJECT, "dist", OUT_NAME + ".exe")
    if os.path.isfile(out):
        size = os.path.getsize(out) / 1024.0
        print("\n打包成功！")
        print("输出文件: %s" % out)
        print("文件大小: %.1f KB" % size)
    else:
        print("\n打包失败：未生成 exe")

    # 清理临时产物（保留 dist 里的 exe）
    # 注：某些环境对批量删除(>50 文件)有拦截，清理失败不影响产物，忽略即可
    build_dir = os.path.join(PROJECT, "build")
    for p in (STAGE, PAYLOAD, build_dir):
        try:
            if os.path.isdir(p):
                shutil.rmtree(p)
            elif os.path.isfile(p):
                os.remove(p)
        except Exception as e:
            print("  [提示] 清理临时文件被环境拦截（可忽略，已被 .gitignore 忽略）: %s" % p)
    print("打包完成")


if __name__ == "__main__":
    main()
