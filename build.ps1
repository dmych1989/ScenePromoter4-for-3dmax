# 场景助手4 打包脚本
# 使用方法: 在 PowerShell 中运行 .\build.ps1
# 依赖: .NET Framework 4.x (自带 csc.exe)

$ErrorActionPreference = "Stop"

$projectDir = "D:\GitHub\ScenePromoter4"
$workDir = Join-Path $projectDir "_build_temp"
$csc = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
$outExe = Join-Path $projectDir "场景助手4_2_2.exe"

Write-Host "=== 场景助手4 打包工具 ===" -ForegroundColor Cyan
Write-Host "项目目录: $projectDir"
Write-Host ""

# 1. 清理临时目录
if (Test-Path $workDir) { Remove-Item $workDir -Recurse -Force }
New-Item -ItemType Directory -Path $workDir | Out-Null
New-Item -ItemType Directory -Path "$workDir\stage\ScenePromoter4" | Out-Null

# 2. 复制插件文件（保留目录结构，排除旧exe和临时目录）
Write-Host "[1/4] 复制插件文件..."
Copy-Item "$projectDir\*" "$workDir\stage\ScenePromoter4\" -Recurse -Force -Exclude "*.exe", "_build_temp"

# 3. 复制启动脚本到暂存根目录
if (Test-Path "$projectDir\SP4_startup.ms") {
    Copy-Item "$projectDir\SP4_startup.ms" "$workDir\stage\SP4_startup.ms" -Force
} else {
    Write-Warning "未找到 SP4_startup.ms，请确认启动脚本存在"
}

# 4. 生成 zip 包
Write-Host "[2/4] 压缩文件..."
$zipPath = Join-Path $workDir "payload.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path "$workDir\stage\*" -DestinationPath $zipPath -CompressionLevel Optimal
Write-Host "  压缩包大小: $([math]::Round((Get-Item $zipPath).Length / 1KB, 1)) KB"

# 5. 生成 C# 安装程序源码
Write-Host "[3/4] 生成安装程序..."
$csFile = Join-Path $workDir "Installer.cs"
$csCode = @'
using System;
using System.IO;
using System.IO.Compression;
using System.Reflection;
using System.Text;
using Microsoft.Win32;

namespace SP4Installer {
    class Program {
        [STAThread]
        static void Main(string[] args) {
            Console.OutputEncoding = Encoding.GetEncoding("GBK");
            Console.WriteLine("========================================");
            Console.WriteLine("    场景助手 4.2.2 安装程序");
            Console.WriteLine("    作者：山医命相卜");
            Console.WriteLine("    QQ群：756653752");
            Console.WriteLine("========================================\n");

            string maxDir = null;
            try {
                using (RegistryKey key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Autodesk\3dsMax\24.0")) {
                    if (key != null) maxDir = key.GetValue("Installdir") as string;
                }
            } catch { }
            if (string.IsNullOrEmpty(maxDir)) {
                try {
                    using (RegistryKey hklm = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32))
                    using (RegistryKey key = hklm.OpenSubKey(@"SOFTWARE\Autodesk\3dsMax\24.0")) {
                        if (key != null) maxDir = key.GetValue("Installdir") as string;
                    }
                } catch { }
            }
            if (string.IsNullOrEmpty(maxDir)) {
                Console.Write("未检测到3ds Max 2022，请输入安装路径: ");
                maxDir = Console.ReadLine();
            }
            if (!maxDir.EndsWith("\\")) maxDir += "\\";

            string scriptDir = Path.Combine(maxDir, "scripts");
            string pluginDir = Path.Combine(scriptDir, "ScenePromoter4");
            string startupDir = Path.Combine(scriptDir, "Startup");

            Console.WriteLine("3ds Max路径: " + maxDir);
            Console.WriteLine("插件目录: " + pluginDir + "\n");
            Console.WriteLine("正在安装...");

            string tempDir = Path.Combine(Path.GetTempPath(), "SP4_Install_" + Guid.NewGuid().ToString("N"));
            try {
                Assembly asm = Assembly.GetExecutingAssembly();
                using (Stream res = asm.GetManifestResourceStream("payload.zip")) {
                    if (res == null) { Console.WriteLine("错误：无法读取安装数据！"); Console.ReadKey(); return; }
                    Directory.CreateDirectory(tempDir);
                    string zipTemp = Path.Combine(tempDir, "p.zip");
                    using (FileStream fs = new FileStream(zipTemp, FileMode.Create)) res.CopyTo(fs);
                    ZipFile.ExtractToDirectory(zipTemp, tempDir);
                    File.Delete(zipTemp);
                }
                Directory.CreateDirectory(pluginDir);
                Directory.CreateDirectory(startupDir);
                string srcPlugin = Path.Combine(tempDir, "ScenePromoter4");
                if (Directory.Exists(srcPlugin)) CopyDir(srcPlugin, pluginDir);
                string srcStartup = Path.Combine(tempDir, "SP4_startup.ms");
                if (File.Exists(srcStartup)) File.Copy(srcStartup, Path.Combine(startupDir, "SP4_startup.ms"), true);

                Console.WriteLine("\n安装完成！");
                Console.WriteLine("插件目录: " + pluginDir);
                Console.WriteLine("启动脚本: " + startupDir);
                Console.WriteLine("\n重启3ds Max后即可使用场景助手4.2.2");
            } catch (Exception ex) {
                Console.WriteLine("\n安装失败: " + ex.Message);
            } finally {
                try { Directory.Delete(tempDir, true); } catch { }
            }
            Console.WriteLine("\n按任意键退出...");
            Console.ReadKey();
        }
        static void CopyDir(string src, string dst) {
            Directory.CreateDirectory(dst);
            foreach (string f in Directory.GetFiles(src)) File.Copy(f, Path.Combine(dst, Path.GetFileName(f)), true);
            foreach (string d in Directory.GetDirectories(src)) CopyDir(d, Path.Combine(dst, Path.GetFileName(d)));
        }
    }
}
'@
Set-Content -Path $csFile -Value $csCode -Encoding UTF8

# 6. 编译
Write-Host "[4/4] 编译安装包..."
& $csc /target:exe /out:$outExe `
    /reference:"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.IO.Compression.FileSystem.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.IO.Compression.dll" `
    /resource:$zipPath,payload.zip $csFile 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    $size = [math]::Round((Get-Item $outExe).Length / 1KB, 1)
    Write-Host ""
    Write-Host "打包成功！" -ForegroundColor Green
    Write-Host "输出文件: $outExe"
    Write-Host "文件大小: $size KB"
} else {
    Write-Host "编译失败！" -ForegroundColor Red
    exit 1
}

# 7. 清理
Remove-Item $workDir -Recurse -Force
Write-Host "临时文件已清理" -ForegroundColor Gray
