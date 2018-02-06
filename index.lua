local pad, oldpad = Controls.read(), Controls.read()
local Screen_size_x, Screen_size_y = 960, 544
local Screen_x, Screen_y=(960/2-Screen_size_x/2), (544/2-Screen_size_y/2)
local color_background = Color.new(48,48,48)
local color_orange = Color.new(255,106,0)
local color_skyblue = Color.new(0,148,255)
local color_black = Color.new(0,0,0)
local color_white = Color.new(255,255,255)
local color_gray_thin = Color.new(64,64,64)
local color_gray_fat = Color.new(128,128,128)
local Touch_x,Touch_y,Touch_c,Touch_z,Touch_old_x,Touch_old_y
local Touch_mode = "None"
local Center_x,Center_y = Screen_x+Screen_size_x/2,Screen_y+Screen_size_y/2
local Move_speed,Resize_speed = 2.5,0.1
local Stick_right_x, Stick_right_y = Controls.readRightAnalog()
local Stick_left_x, Stick_left_y = Controls.readLeftAnalog()
local Zoom_min = 12
local Zoom_mode = "xy"
local Size_x,Size_y = 25, 25
local Left_x,Right_x,Down_y,Up_y= (Screen_x - Center_x)/Size_x, (Screen_x + Screen_size_x - Center_x)/Size_x,-(Screen_y + Screen_size_y - Center_y)/Size_y,-(Screen_y - Center_y)/Size_y
local Grapic_dots = 250
local x_num = {}
local y_num = {}
local texture = Graphics.loadImage("app0:/assets/texture.png")
local priceDX,priceDY = 1,1
pi = math.pi
function sin(x)
return math.sin(x)
end
function sqrt(x)
return math.sqrt(x)
end
function cos(x)
	return math.cos(x)
end
function floor(x)
return math.floor(x)
end
function ceil(x)
return math.ceil(x)
end
function abs(x)
return math.abs(x)
end
function arccos(x)
return math.acos(x)
end
function arcsin(x)
return math.asin(x)
end
function tg(x)
return math.tan(x)
end
function ctg(x)
return 1/math.tan(x)
end
function arctg(x)
return math.atan(x)
end
function arcctg(x)
return -math.atan(x)+pi/2
end
function priceY(num)
	local x1,y1
	if Center_x>Screen_x+Screen_size_x then
		x1 = Screen_x + Screen_size_x - string.len(math.abs(num))*16
		if num<0 then
			x1 = x1 - 5
		end
		elseif Center_x < Screen_x then
		x1 = Screen_x + 5
		else
		x1 = Center_x + 5
	end
	y1=Center_y-num*Size_y
	Graphics.drawLine(Center_x-5,Center_x+5,Center_y-num*Size_y,Center_y-num*Size_y,color_white)
	if num~=0 then
		Graphics.debugPrint(x1,y1,num,color_white)
		else
		Graphics.debugPrint(x1 - 5 + 3,y1+5,num,color_white)
	end
end
function priceX(num)
	local x1,y1
	if Center_y<Screen_y+5 then
		y1 = Screen_y+5
		elseif Center_y>Screen_y+Screen_size_y - 20 then
		y1 = Screen_y+Screen_size_y-20
		else
		y1 = Center_y+5
	end
	x1=Center_x+num*Size_x
	Graphics.drawLine(Center_x+num*Size_x,Center_x+num*Size_x,Center_y-5,Center_y+5,color_white)
	Graphics.debugPrint(x1+3,y1,num,color_white)
end
function drawImage(x,y,row, column)
	Graphics.drawPartialImage(x,y,texture,(column-1)*32,(row-1)*32,32,32)
end
function Update_XY()
	Left_x,Right_x,Down_y,Up_y= (Screen_x - Center_x)/Size_x, (Screen_x + Screen_size_x - Center_x)/Size_x,-(Screen_y + Screen_size_y - Center_y)/Size_y,-(Screen_y - Center_y)/Size_y
	local period=(Right_x-Left_x)/Grapic_dots
	for i = -1, Grapic_dots+1 do
		x_num[i]=Left_x+period*i
		y_num[i]=Y_make(x_num[i])
	end
end
function NewFunction(fun)
	System.deleteFile("ux0:/fun.lua")
	func = System.openFile("ux0:/fun.lua",FCREATE)
	savestring = "function Y_make(x) local y "..fun.." return y end"
	savestringlen = string.len(savestring)
	System.writeFile(func,savestring,savestringlen)
	System.closeFile(func)
	dofile("ux0:/fun.lua")
end
word = "y = 0"
NewFunction("y = 0")
local function Coordinate_Lines()
	for i=1, 4 do
		local color = color_black
		if i>1 and i<4 then
			color = color_orange
		end
		if (Center_x-2+i)>=Screen_x and (Center_x-2+i)<=Screen_x+Screen_size_x then
			Graphics.drawLine(Center_x-2+i,Center_x-2+i,Screen_y,Screen_y+Screen_size_y,color)
		end
		color = color_black
		if i>1 and i<4 then
			color = color_skyblue
		end
		if (Center_y-2+i)>=Screen_y and (Center_y-2+i)<=Screen_y+Screen_size_y then
			Graphics.drawLine(Screen_x,Screen_x+Screen_size_x,Center_y-2+i,Center_y-2+i,color)
		end
	end
end
local function Move_CooLines()
	if math.abs(Stick_right_x-128)>20 or math.abs(Stick_right_y-128)>20 then
		Center_x = Center_x - (math.ceil((Stick_right_x-128)/64)*Move_speed)
		Center_y = Center_y - (math.ceil((Stick_right_y-128)/64)*Move_speed)
		Update_XY()
	end
end
local function Rescale_GphX()
	local sizeBefore_x,sizeBefore_y=Size_x,Size_y
	if math.abs(Stick_left_y-128)>20 and Size_x-(math.ceil((Stick_left_y-128)/32)*Resize_speed)>Zoom_min then 
		if Zoom_mode=="xy" or Zoom_mode=="x" then
			Size_x = Size_x - (math.ceil((Stick_left_y-128)/32)*Resize_speed)
		end
	end
	if math.abs(Stick_left_y-128)>20 and Size_y - (math.ceil((Stick_left_y-128)/32)*Resize_speed)>Zoom_min then
		if Zoom_mode=="xy" or Zoom_mode=="y" then
			Size_y = Size_y - (math.ceil((Stick_left_y-128)/32)*Resize_speed)
		end
	end
	if sizeBefore_x~=Size_x or sizeBefore_y~=Size_y then
		JumpTo((Center_x - (Screen_x+Screen_size_x/2))/sizeBefore_x,((Screen_y+Screen_size_y/2) - Center_y)/sizeBefore_y)
		Update_XY()
	end
end
local function Grid()
	for i=0,math.floor(Right_x-Left_x)+1 do
		if (math.floor(Left_x)+i)%5 == 0 then
			Graphics.drawLine(Center_x+(math.floor(Left_x)+i)*Size_x,Center_x+(math.floor(Left_x)+i)*Size_x,Screen_y,Screen_y+Screen_size_y,color_gray_fat)
		else
			Graphics.drawLine(Center_x+(math.floor(Left_x)+i)*Size_x,Center_x+(math.floor(Left_x)+i)*Size_x,Screen_y,Screen_y+Screen_size_y,color_gray_thin)
		end
	end
	for i=0,math.floor(Up_y-Down_y)+1 do
		if (math.floor(Down_y)+i)%5 == 0 then
			Graphics.drawLine(Screen_x,Screen_x+Screen_size_x,Center_y-(math.floor(Down_y)+i)*Size_y,Center_y-(math.floor(Down_y)+i)*Size_y,color_gray_fat)
		else
			Graphics.drawLine(Screen_x,Screen_x+Screen_size_x,Center_y-(math.floor(Down_y)+i)*Size_y,Center_y-(math.floor(Down_y)+i)*Size_y,color_gray_thin)
		end
		
	end
end
function JumpTo(x, y)
	local y = y or Y_make(x)
	Center_x,Center_y=(Screen_x+Screen_size_x/2+x*Size_x),(Screen_y+Screen_size_y/2-y*Size_y)
end
local function GetCenterXY()
	return ((Center_x-(Screen_x+Screen_size_x/2))/Size_x),((Screen_y+Screen_size_y/2-Center_y)/Size_y)
end
local function Touch_screen()
	local sizeBefore_x,sizeBefore_y=Size_x,Size_y
	if Touch_x~=nil and Touch_x>=0 and Touch_y>=0 and Touch_x<=Screen_size_x and Touch_y<=Screen_size_y and Touch_mode=="None" then
		Touch_mode="Move"
	end
	if Touch_c~=nil and Touch_c>=0 and Touch_z>=0 and Touch_c<=Screen_size_x and Touch_z<=Screen_size_y and Touch_mode=="Move" then
		Touch_mode="Resize"
	end
	if Touch_mode=="Move" then
		Touch_old_x=Touch_old_x or Center_x-Touch_x
		Touch_old_y=Touch_old_y or Center_y-Touch_y
		Center_x=Touch_old_x+Touch_x
		Center_y=Touch_old_y+Touch_y
		Update_XY()
		else
		Touch_old_x=nil
		Touch_old_y=nil
	end
	if Touch_mode=="Resize" then
		Touch_old_vx=Touch_old_vx or math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed-Size_x
		Touch_old_vy=Touch_old_vy or math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed-Size_y
		if Zoom_mode == "x" or Zoom_mode == "xy" then
			if math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed - Touch_old_vx>Zoom_min then
			Size_x = math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed - Touch_old_vx
			else
			Touch_old_vx=math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed-Size_x
			end
		end
		if Zoom_mode == "y" or Zoom_mode == "xy" then
		if math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed - Touch_old_vy>Zoom_min then
			Size_y = math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed - Touch_old_vy
		else
		Touch_old_vy=math.sqrt((Touch_c-Touch_x)^2+(Touch_z-Touch_y)^2)*Resize_speed-Size_y
		end
		end
		Update_XY()
	else
		Touch_old_vx=nil
		Touch_old_vy=nil
	end
	if sizeBefore_x~=Size_x or sizeBefore_y~=Size_y then
		JumpTo((Center_x - (Screen_x+Screen_size_x/2))/sizeBefore_x,((Screen_y+Screen_size_y/2) - Center_y)/sizeBefore_y)
		Update_XY()
	end
end
Update_XY()
while true do
	Touch_x,Touch_y,Touch_c,Touch_z = Controls.readTouch()
	Stick_right_x, Stick_right_y = Controls.readRightAnalog()
	Stick_left_x, Stick_left_y = Controls.readLeftAnalog()
	if Size_x>650 then
		priceDX=0.1
		elseif Size_x>450 then
		priceDX=0.2
		elseif Size_x>160 then
		priceDX=0.5
		elseif Size_x>80 then
		priceDX=1
		elseif Size_x>35 then
		priceDX=2
		elseif Size_x>15 then
		priceDX=5
		else
		priceDX=10
	end
	if Size_y>650 then
		priceDY=0.1
		elseif Size_y>450 then
		priceDY=0.2
		elseif Size_y>160 then
		priceDY=0.5
		elseif Size_y>80 then
		priceDY=1
		elseif Size_y>35 then
		priceDY=2
		elseif Size_y>15 then
		priceDY=5
		else
		priceDY=10
	end
	if Touch_x~=nil then
		Touch_x,Touch_y=Touch_x-Screen_x,Touch_y-Screen_y
		if Touch_c~=nil then
			Touch_c,Touch_z=Touch_c-Screen_x,Touch_z-Screen_y
		end
		if Touch_x>=0 and Touch_x<=Screen_size_x and Touch_y>=0 and Touch_y<=Screen_size_y then
			elseif Touch_mode=="None" then
			Touch_mode="Nothing"
		end
	else
	Touch_mode="None"
	end
	if Touch_c==nil and Touch_mode=="Resize" then
		Touch_mode="Nothing"
	end
	pad = Controls.read()
	Graphics.initBlend()
	Screen.clear(color_background)
	Grid()
	Coordinate_Lines()
	for i=-1, Grapic_dots do
		if Center_y-y_num[i]*Size_y>=0 and Center_y-y_num[i]*Size_y<=960 then
			Graphics.drawLine(Center_x+x_num[i]*Size_x,Center_x+x_num[i+1]*Size_x,Center_y-y_num[i]*Size_y,Center_y-y_num[i+1]*Size_y,color_white)
		end
	end
	if priceDX<1 then
		for i=0, math.floor((Right_x-Left_x)*priceDX^-1)+10 do
			if (math.floor(Left_x)*priceDX^-1+i)%priceDX==0 then
				priceX(math.floor(Left_x)+i*priceDX)
			end
		end
		else
		for i=0, math.floor(Right_x-Left_x)+1 do
			if (math.floor(Left_x)+i)%priceDX==0 then
				priceX(math.floor(Left_x)+i)
			end
		end
	end
	if priceDY<1 then
		for i=0, math.floor((Up_y-Down_y)*priceDY^-1)+10 do
			if (math.floor(Down_y)*priceDY^-1+i)%priceDY==0 then
				priceY(math.floor(Down_y)+i*priceDY)
			end
		end
		else
		for i=0, math.floor(Up_y-Down_y)+1 do
			if (math.floor(Down_y)+i)%priceDY==0 then
				priceY(math.floor(Down_y)+i)
			end
		end
	end
	Graphics.fillRect(Screen_x,Screen_x+Screen_size_x,0,Screen_y,color_black)
	Graphics.fillRect(Screen_x,Screen_x+Screen_size_x,Screen_y+Screen_size_y,960,color_black)
	Graphics.fillRect(0,Screen_x,0,544,color_black)
	Graphics.fillRect(Screen_x+Screen_size_x,960,0,544,color_black)
	if Zoom_mode=="xy" then
	drawImage(0,544-32,1,1)
	elseif Zoom_mode=="y" then
	drawImage(0,544-32,1,2)
	else
	drawImage(0,544-32,1,3)
	end
	drawImage(0,544-64,1,4)
	drawImage(125,544-64,1,5)
	Graphics.debugPrint(Screen_x+5,Screen_y+5,word,color_white)
	Graphics.debugPrint(35,544-26,"- Zoom Mode □", color_white)
	Graphics.debugPrint(35,544-32-16-6,"- Zoom", color_white)
	Graphics.debugPrint(160,544-32-16-6,"- Move", color_white)
	Graphics.termBlend()
	Move_CooLines()
	Rescale_GphX()
	Touch_screen()
	
	if Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then 
		JumpTo(0,0)
		Update_XY()
	end
	if Controls.check(pad, SCE_CTRL_SQUARE) and not Controls.check(oldpad, SCE_CTRL_SQUARE) then
		if Zoom_mode=="xy" then
		Zoom_mode="y"
		elseif Zoom_mode=="y" then
		Zoom_mode="x"
		else
		Zoom_mode="xy"
		end
	end
	if Controls.check(pad, SCE_CTRL_SELECT) then 
		Graphics.freeImage(texture)
		FTP = FTP + 1	
	end
	if Controls.check(pad, SCE_CTRL_TRIANGLE) and Controls.check(pad, SCE_CTRL_TRIANGLE) then 
		oldword = word
		word = "y = 0"
		Keyboard.show("Enter a F(x)", oldword)
		status = Keyboard.getState()
		while status==RUNNING do
			status = Keyboard.getState()
			Graphics.initBlend()
			Screen.clear(color_background)
	Grid()
	Coordinate_Lines()
	for i=-1, Grapic_dots do
		if Center_y-y_num[i]*Size_y>=0 and Center_y-y_num[i]*Size_y<=960 then
			Graphics.drawLine(Center_x+x_num[i]*Size_x,Center_x+x_num[i+1]*Size_x,Center_y-y_num[i]*Size_y,Center_y-y_num[i+1]*Size_y,color_white)
		end
	end
	if priceDX<1 then
		for i=0, math.floor((Right_x-Left_x)*priceDX^-1)+10 do
			if (math.floor(Left_x)*priceDX^-1+i)%priceDX==0 then
				priceX(math.floor(Left_x)+i*priceDX)
			end
		end
		else
		for i=0, math.floor(Right_x-Left_x)+1 do
			if (math.floor(Left_x)+i)%priceDX==0 then
				priceX(math.floor(Left_x)+i)
			end
		end
	end
	if priceDY<1 then
		for i=0, math.floor((Up_y-Down_y)*priceDY^-1)+10 do
			if (math.floor(Down_y)*priceDY^-1+i)%priceDY==0 then
				priceY(math.floor(Down_y)+i*priceDY)
			end
		end
		else
		for i=0, math.floor(Up_y-Down_y)+1 do
			if (math.floor(Down_y)+i)%priceDY==0 then
				priceY(math.floor(Down_y)+i)
			end
		end
	end
	Graphics.fillRect(Screen_x,Screen_x+Screen_size_x,0,Screen_y,color_black)
	Graphics.fillRect(Screen_x,Screen_x+Screen_size_x,Screen_y+Screen_size_y,960,color_black)
	Graphics.fillRect(0,Screen_x,0,544,color_black)
	Graphics.fillRect(Screen_x+Screen_size_x,960,0,544,color_black)
	if Zoom_mode=="xy" then
	drawImage(0,544-32,1,1)
	elseif Zoom_mode=="y" then
	drawImage(0,544-32,1,2)
	else
	drawImage(0,544-32,1,3)
	end
	drawImage(0,544-64,1,4)
	drawImage(125,544-64,1,5)
	Graphics.debugPrint(Screen_x+5,Screen_y+5,word,color_white)
	Graphics.debugPrint(35,544-26,"- Zoom Mode □", color_white)
	Graphics.debugPrint(35,544-32-16-6,"- Zoom", color_white)
	Graphics.debugPrint(160,544-32-16-6,"- Move", color_white)
			word = Keyboard.getInput()
			if status==CANCELED then
				word=oldword
			end
			Graphics.termBlend()
			Screen.flip()
		end
		if word~=nil then
		NewFunction(word)
		Update_XY()
		end
		Keyboard.clear()
	end	
	Screen.flip()
	Screen.waitVblankStart()
	oldpad = pad
end