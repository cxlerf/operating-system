; 确保脚本以管理员权限运行，以避免权限问题

#SingleInstance Force

#NoEnv

SetWorkingDir %A_ScriptDir%

; Alt + S 截图功能 - 自动OCR文字识别
!s::
Send, {PrintScreen}  ; 发送 PrintScreen，调用截图选择界面

; 等待用户完成截图选择 - 监测截图工具通知的出现
; 最多等待30秒让用户选择截图区域
Loop, 60 {
    ; 检查是否出现了截图完成的通知
    ; 方法1: 检查是否有截图工具的通知窗口
    IfWinExist, ahk_class Shell_TrayWnd
    {
        ; 检查通知区域是否有新通知
        WinGet, NotificationList, List, ahk_class NotificationWindow_
        if (NotificationList > 0) {
            ; 找到通知，等待一下确保通知完全显示
            Sleep, 1000
            break
        }
    }
    
    ; 方法2: 检查剪贴板是否有新的图片内容（截图完成的标志）
    if (A_Index > 5) {  ; 给截图工具一些启动时间
        Clipboard := ""
        ClipWait, 0.5, 1  ; 等待剪贴板中出现内容
        if (!ErrorLevel) {
            ; 剪贴板有内容了，说明截图可能完成了
            Sleep, 2000  ; 等待通知显示
            break
        }
    }
    
    ; 方法3: 检查截图工具窗口是否消失（用户完成选择）
    IfWinNotExist, ahk_exe ScreenClippingHost.exe
    {
        if (A_Index > 10) {  ; 确保不是刚开始的状态
            Sleep, 2000  ; 等待通知出现
            break
        }
    }
    
    Sleep, 500  ; 每0.5秒检查一次
}

; 现在开始查找并点击截图工具通知
Loop, 10 {
    ; 方法1: 直接点击通知区域
    ; Windows 11通知通常在右下角
    NotificationX := A_ScreenWidth - 50
    NotificationY := A_ScreenHeight - 50
    Click, %NotificationX%, %NotificationY%
    Sleep, 300
    
    ; 检查是否成功打开了截图工具界面
    IfWinExist, ahk_exe ScreenClippingHost.exe
    {
        WinActivate, ahk_exe ScreenClippingHost.exe
        Sleep, 500
        break
    }
    
    ; 方法2: 尝试其他通知位置
    Click, A_ScreenWidth-100, A_ScreenHeight-100
    Sleep, 300
    Click, A_ScreenWidth-150, A_ScreenHeight-80
    Sleep, 300
    
    ; 方法3: 查找截图工具相关窗口
    IfWinExist, 截图工具
    {
        WinActivate, 截图工具
        Sleep, 300
        break
    }
    
    Sleep, 500
}

; 等待截图工具界面完全加载
Sleep, 1000

; 查找并点击"文本操作"按钮
; 尝试多种方法
Loop, 5 {
    ; 方法1: 使用快捷键T（Text actions的快捷键）
    Send, t
    Sleep, 500
    
    ; 方法2: 查找文本操作按钮的可能位置并点击
    ; 在截图工具界面中，文本操作通常在顶部工具栏
    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %A_ScriptDir%\text_action_icon.png
    if (ErrorLevel = 0) {
        Click, %FoundX%, %FoundY%
        Sleep, 500
        break
    }
    
    ; 方法3: 尝试点击可能的文本操作按钮位置
    ; 这些坐标可能需要根据你的屏幕分辨率调整
    PixelSearch, Px, Py, 0, 0, A_ScreenWidth, 200, 0x323130, 3, Fast
    if (ErrorLevel = 0) {
        Click, %Px%, %Py%
        Sleep, 500
    }
    
    Sleep, 300
}

; 等待OCR处理完成
Sleep, 2000

; 查找并点击"复制所有文本"按钮
Loop, 5 {
    ; 方法1: 使用快捷键Ctrl+A然后Ctrl+C
    Send, ^a
    Sleep, 200
    Send, ^c
    Sleep, 300
    
    ; 方法2: 查找"复制所有文本"按钮
    ; 在某些版本中可能是"Copy all text"
    WinActivate, A  ; 确保当前窗口是活动的
    
    ; 尝试Tab键导航到复制按钮
    Send, {Tab 3}
    Sleep, 200
    Send, {Enter}
    Sleep, 300
    
    ; 如果找到了复制按钮就跳出循环
    break
}

; 关闭截图工具
Sleep, 500
Send, {Escape}
Sleep, 200
Send, !{F4}  ; Alt+F4关闭窗口

; 显示完成提示
TrayTip, OCR完成, 截图文字已复制到剪贴板, 2, 1

return

; 备选的更简单的OCR方案（如果上面的方法不稳定）
; Alt + Shift + S - 使用Windows内置的OCR功能
!+s::
; 使用Windows PowerShell调用OCR
RunWait, powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::SetText((Get-Clipboard -Format Image | Invoke-OCR))", , Hide
TrayTip, OCR完成, 文字已提取到剪贴板, 2, 1
return

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