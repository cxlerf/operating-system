; 确保脚本以管理员权限运行，以避免权限问题
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
; Alt + S 截图功能 - 直接使用 PrintScreen 键
!s::
Send, {PrintScreen}  ; 发送 PrintScreen，调用截图选择界面
return
; 备选方案1：如果上面不行，使用这个版本直接调用截图工具
; ^s::
; Run, ms-screenclip:
; return
; 备选方案2：使用传统的 PrintScreen 然后提示用户
; ^s::
; Send, {PrintScreen}
; TrayTip, 截图提示, 截图已复制到剪贴板，可以粘贴使用, 3
; return
; 备选方案3：如果需要全屏截图并保存文件
; ^s::
; Send, {PrintScreen}
; Sleep, 100
; Run, mspaint
; Sleep, 1000
; Send, ^v
; Sleep, 500
; Send, ^s
; return
; Alt + V 切换到 Visual Studio Code
!v::
IfWinExist, ahk_exe Code.exe
{
    WinActivate
}
else
{
    Run, "D:\Microsoft VS Code\Code.exe"  ; 替换为您的 VS Code 实际路径
}
return
; Alt + N 智能切换当前程序的多个窗口
!n::
; 获取当前活动窗口的进程名
WinGet, ActiveProcess, ProcessName, A
; 根据当前活动的程序来切换对应的多个窗口
if (ActiveProcess = "Code.exe")
{
    WinActivateBottom, ahk_exe Code.exe
}
else if (ActiveProcess = "chrome.exe")
{
    WinActivateBottom, ahk_exe chrome.exe
}
else if (ActiveProcess = "wpspdf.exe")
{
    WinActivateBottom, ahk_exe wpspdf.exe
}
else if (ActiveProcess = "PotPlayerMini.exe")
{
    WinActivateBottom, ahk_exe PotPlayerMini.exe
}
else if (ActiveProcess = "YoudaoDict.exe")
{
    WinActivateBottom, ahk_exe YoudaoDict.exe
}
else
{
    ; 如果当前程序不在支持列表中，尝试切换同进程的窗口
    WinActivateBottom, ahk_exe %ActiveProcess%
}
return
; 另一种方法：使用窗口组来更精确地控制切换
; 首先创建一个窗口组
GroupAdd, VSCodeGroup, ahk_exe Code.exe
; Alt + M 使用窗口组方式切换 VS Code 窗口
!m::
IfWinExist, ahk_group VSCodeGroup
{
    ; 激活组中的下一个窗口
    GroupActivate, VSCodeGroup, r
}
else
{
    Run, "C:\Program Files\Microsoft VS Code\Code.exe"
}
return
; Alt + P 切换到 PotPlayer
!p::
IfWinExist, ahk_exe PotPlayerMini.exe  ; 根据您的 PotPlayer 版本，可能需要调整为 PotPlayerMini.exe 或其他
{
    WinActivate
}
else
{
    Run, "D:\PotPlayer\PotPlayerMini.exe"  ; 替换为您的 PotPlayer 实际路径
}
return
; Alt + C 切换到 Chrome 并聚焦到输入框
!c::
IfWinExist, ahk_exe chrome.exe
{
    WinActivate
    ; 等待窗口激活
    WinWaitActive, ahk_exe chrome.exe, , 2
    Sleep, 300
    
    ; 尝试聚焦到Claude输入框
    ; 方法1: 点击页面底部中央（Claude输入框通常在这里）
    WinGetPos, , , Width, Height, A
    ClickX := Width * 0.5
    ClickY := Height * 0.85
    Click, %ClickX%, %ClickY%
    Sleep, 200
    
    
}
else
{
    Run, "C:\Program Files\Google\Chrome\Application\chrome.exe"  ; 替换为您的 Chrome 实际路径
}
return
; Chrome 多窗口切换示例
GroupAdd, ChromeGroup, ahk_exe chrome.exe
!z::
IfWinExist, ahk_group ChromeGroup
{
    GroupActivate, ChromeGroup, r
}
else
{
    Run, "C:\Program Files\Google\Chrome\Application\chrome.exe"
}
return
; Alt + W 切换到 WPS PDF
!w::
IfWinExist, ahk_exe wpspdf.exe
{
    WinActivate
}
else
{
    Run, "D:\WPS Office\12.1.0.21541\office6\wpspdf.exe"
}
return
; Alt + D 切换到网易有道翻译并聚焦到输入框
!d::
IfWinExist, ahk_exe YoudaoDict.exe
{
    WinActivate
    ; 等待窗口激活
    WinWaitActive, ahk_exe YoudaoDict.exe, , 2
    Sleep, 300
    
    ; 尝试聚焦到有道词典输入框
    ; 方法1: 使用Ctrl+E快捷键（有道词典的输入框快捷键）
    Send, ^e
    Sleep, 100
    
    ; 方法2: 如果Ctrl+E不行，点击输入框区域
    Click, 200, 50  ; 点击窗口上部输入框位置
    Sleep, 100
    
    ; 方法3: 使用Tab键导航到输入框
    Send, {Tab 3}
    Sleep, 100
    
    ; 清空输入框准备新输入
    Send, ^a
    Sleep, 50
    Send, {Delete}
}
else
{
    Run, "D:\Dict\YoudaoDict.exe"
}
return
; 通用的多窗口切换函数
; 可以为任何程序创建多窗口切换
SwitchBetweenWindows(exeName, programPath := "")
{
    IfWinExist, ahk_exe %exeName%
    {
        WinActivateBottom, ahk_exe %exeName%
    }
    else if (programPath != "")
    {
        Run, %programPath%
    }
    return
}
; 使用通用函数的示例
; Alt + Shift + V 切换 VS Code 窗口（使用通用函数）
!+v::
SwitchBetweenWindows("Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe")
return