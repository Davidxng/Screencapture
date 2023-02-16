Printscreen::
;DllCall("TXGYMailCamera.dll\CameraWindow")
DllCall("PrScrn.dll\PrScrn")
return

#q::

Gui, new, +Toolwindow +AlwaysOnTop +Border -MinimizeBox -MaximizeBox -Caption ;创建一个置顶,无标题, 有边框的窗口
Gui, Add, Picture, x1 y1 +0xE hWndPic1 gmoveWin ; 给窗口添加一个图片控件
Gui, Margin, 1,1

DllCall( "LoadLibrary", Str,"gdiplus" ) 
VarSetCapacity(si, 16, 0), si := Chr(1) 
DllCall( "gdiplus\GdiplusStartup", UIntP,pToken, UInt,&si, UInt,0 ) 

DllCall("OpenClipboard", "Uint", 0)
a:=DllCall("IsClipboardFormatAvailable", "Uint", 2) 
if a=0
{
msgbox no image on clipboard
Gui, Destroy
}

hBitMap:=DllCall("GetClipboardData", "Uint", 2)
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", hbitmap, "Uint", 0, "UintP", pImage)
DllCall("CloseClipboard")

DllCall("gdiplus\GdipGetImageWidth", "UInt", pImage, "UInt*", Width)
DllCall("gdiplus\GdipGetImageHeight", "UInt", pImage, "UInt*", Height)
w:=width ,h:=height
Gui,show,x10 y10 w%w% h%h%, Snapshot

SendMessage, (STM_SETIMAGE:=0x172), (IMAGE_BITMAP:=0x0), hBitmap,, ahk_id %Pic1% 

DllCall("DeleteObject", "Uint", pImage)
DllCall("DeleteObject", "Uint", hBitmap)
DllCall( "gdiplus\GdiplusShutdown", UInt,pToken ) 
Return    

moveWin:
if A_GuiEvent = DoubleClick
{
    Gui,destroy
}
return

;窗口上左键响应事件,使窗口可任意区域拖动
WM_LBUTTONDOWN()
{
    Static init:=OnMessage(0x0201, "WM_LBUTTONDOWN")
    PostMessage, 0xA1, 2
}