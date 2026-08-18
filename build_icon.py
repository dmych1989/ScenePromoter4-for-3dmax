#!/usr/bin/env python3
"""将 images/logo.gif 转为 NSIS 安装包可用的 images/logo.ico（多尺寸）."""
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("[错误] 缺少 Pillow。请先安装:  python -m pip install Pillow")
    sys.exit(1)

PROJECT = Path(__file__).resolve().parent
SRC = PROJECT / "images" / "logo.gif"
DST = PROJECT / "images" / "logo.ico"

if not SRC.exists():
    print(f"[错误] 找不到图标源文件: {SRC}")
    sys.exit(1)

with Image.open(SRC) as im:
    im.seek(0)
    img = im.convert("RGBA")

sizes = [16, 24, 32, 48, 64, 128, 256]
frames = [img.resize((s, s), Image.Resampling.LANCZOS) for s in sizes]
frames[0].save(
    DST,
    format="ICO",
    sizes=[(f.width, f.height) for f in frames],
    append_images=frames[1:],
)
print(f"[完成] 已生成 {DST}，尺寸: {[(f.width, f.height) for f in frames]}")
