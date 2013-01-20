Image_Fuzzy := "*36"


i=1
; loop looks for poke button
; two variables, PokeBackButtonPos and PokeButtonPos are used
Loop 
{
  
    
      PokeBackButtonPos := GetButtonPos("pokeback.png", 53, 13, 5, 0)
    
      if (PokeBackButtonPos > 0)
      {
        ; ToolTip, Found Poke back txt
        
        ; Click the link
        ClickPos(PokeBackButtonPos)
      }

; sleep
sleep 3000


; repeat for next one

      
      PokeButtonPos := GetButtonPos("pokefinal2.png", 35, 16, 5, 0)
    
      if (PokeButtonPos > 0)
      {
        ; ToolTip, Found Poke final
        
        ; Click btn
        ClickPos(PokeButtonPos)

	; write to log, this could be more explicit
        FileAppend, Poke`n, pokes.txt
      }
    
    
   sleep 10000
   
} ; loop






    
    
    
    


; Pack to numbers together
PackTwoInts(xin, yin)
{
  ; Pack X,Y coords as two 16 bit integers in one 32 bit word.
  ; We do this because autohotkey does not yet support arrays,
  ; and we can only return one value from this function
  x := (xin)
  y := (yin << 16)
  reslt := (y | x)
  return reslt
}


; Look for position on an image
; returns x,y packed into single int on success, 0 on failure
GetButtonPos(g_image,g_width,g_height,g_wait,y_start)
{
    Global Image_Fuzzy
    if (y_start > 0)
    {
        y_start := (A_ScreenHeight - y_start)
    }

    full_image_path := A_ScriptDir . "\" . g_image
    reslt = 0
    CoordMode Pixel
    Loop, %g_wait%
    {
        ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, % Image_Fuzzy . " " . full_image_path
        if ErrorLevel = 0
        {
             ; Pack X,Y coords as two 16 bit integers in one 32 bit word.
             ; We do this because autohotkey does not yet support arrays,
             ; and we can only return one value from this function
            ; x := (FoundX + (g_width/2))
            ; y := ((Foundy + (g_height/2)) << 16)
            ; reslt := (y | x)
            ; MsgBox %reslt%
             x := (FoundX + (g_width/2))
             y := (Foundy + (g_height/2))
             reslt := PackTwoInts( x , y )
            ; MsgBox %reslt%
             break
        }
        else
        {
            if (g_wait > 1)
                Sleep, 100
        }
    }
    return reslt
}



; Click a position, then move the mouse to the lower right
; corner of the screen 
ClickPos(position){
    x := (position & 65535)
    y := (position >> 16)
    CoordMode Mouse
    MouseMove, %x%, %y%, 0
    MouseMove, %x%, %y%, 1
    CoordMode Mouse
    Click, %x%, %y%
    ; Fixme, can we remove this mousemove and sleep here?
;    MouseMove, % x + 50, %y%, 100
;    Sleep, 50
    ;result := ParkMouse()
    return 0
}


; Get the "X" portion of a position
GetX(position)
{
    x := (position & 65535)
    y := (position >> 16)
    return x
}


; Get the "Y" portion of a position
GetY(position)
{
    x := (position & 65535)
    y := (position >> 16)
    return y
}
