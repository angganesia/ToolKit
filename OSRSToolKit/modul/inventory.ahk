OpenInventory() {
  TAB_X := 646
  TAB_Y := 207
  MouseMove, TAB_X, TAB_Y
  Click, TAB_X, TAB_Y
}

ClickInventoryItem(row, col) {
  pos := GoToInventoryItem(row, col)
  Click, pos.x pos.y
}

RightClickInventoryItem(row, col, option := 0) {
  pos := GoToInventoryItem(row, col)
  Click, pos.x pos.y Right
  if(option !== 0) {
    Sleep, 300
    SelectDropdown(option)
  }
}

SelectDropdown(option) {
  MouseGetPos, currentX, currentY
  y := currentY + 25 + ((option - 1) * 15)
  MouseMove, currentX, y
  Click, currentX y
}

DropInventory(startRow := 1, startCol := 1) {
  Send, {ShiftDown}
  ForEachItemInInventory("ClickInventoryItem", startRow, startCol)
  Send, {ShiftUp}
}

GoToInventoryItem(row, col) {
  ;Random, randX, -3, 3
  ;Random, randY, -3, 3
  pos := GetInventoryItemPos(row, col)
  x := pos.x ;+ randX
  y := pos.y ;+ randY

  MouseMove, x, y
  return { "x": x, "y": y }
}

GetInventoryItemPos(row, col) {
  LEFT_X := 581
  TOP_Y := 253
  COL_DIFF := 40
  ROW_DIFF := 35

  x := LEFT_X + ((col - 1) * COL_DIFF)
  y := TOP_Y + ((row - 1) * ROW_DIFF)

  return { "x": x, "y": y }
}

ForEachItemInInventory(callbackName, startRow := 1, startCol := 1, endRow := 7, endCol := 4) {
  callback := Func(callbackName)

  MAX_ROWS := 7
  MAX_COLS := 4
  row := startRow
  col := startCol

  While(row <= MAX_ROWS) {
    While(col <= MAX_COLS) {
      callback.Call(row, col)

      if(row == endRow and col == endCol) {
        return
      }

      col++
    }

    row++
    col := 1
  }
}

FindItemInInventory(callbackName, startRow := 1, startCol := 1, endRow := 7, endCol := 4) {
  callback := Func(callbackName)

  MAX_ROWS := 7
  MAX_COLS := 4
  row := startRow
  col := startCol
  colour := 0x

  While(row <= MAX_ROWS) {
    While(col <= MAX_COLS) {
      condition := callback.Call(row, col)

      if(condition == true) {
        return { "row": row, "col": col}
      }

      if(row == endRow and col == endCol) {
        return
      }

      col++
    }

    row++
    col := 1
  }
}

IsItem(row, col) {
	KlikItem(row, col, itemColor)
	CheckAndMoveCursor(x, y, targetColor)
	RightClickInventoryItem(row, col)
	MouseGetPos, x, y
	PixelGetColor, colour, %x%, %y%
	MouseMove, x, y - 50
	return colour == 0x000000
}

GoToNextItem(startRol := 1, startCol := 1) {
  item := FindItemInInventory("IsItem", startRol, startCol)
  GoToInventoryItem(item.row, item.col)
}

CekInv(row, col) {
  pos := GoToInventoryItem(row, col)
  MouseGetPos, x, y
  PixelGetColor, WarInv, %x%, %y%
  ;MsgBox, Coordinates: %x%, %y%`nColor: %colour%
  GuiControl, , WarInv,  %WarInv%
}

KlikItem(row, col, itemColor){
	pos := GoToInventoryItem(row, col)
	MouseGetPos, x, y
	PixelGetColor, color, %x%, %y%
	
	targetColorDec := ConvertHexToDec(itemColor)
	currentColorDec := ConvertHexToDec(color)
	
	if (currentColorDec = targetColorDec) {
        MouseMove, %x%, %y%
		Click, x, y
    } 
}

