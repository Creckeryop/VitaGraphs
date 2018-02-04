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
local Left_x,Right_x = (Screen_x - Center_x)/Size_x, (Screen_x + Screen_size_x - Center_x)/Size_x
local Up_y,Down_y = (Screen_y + Screen_size_y - Center_y)/Size_y,(Screen_y - Center_y)/Size_y
local Grapic_dots = 250
local x_num = {}
local y_num = {}
local texture = Graphics.loadImage("app0:/assets/texture.png")
function drawImage(x,y,row, column)
	Graphics.drawPartialImage(x,y,texture,(column-1)*32,(row-1)*32,32,32)
end
function Update_XY()
	Left_x,Right_x,Up_y,Down_y= (Screen_x - Center_x)/Size_x, (Screen_x + Screen_size_x - Center_x)/Size_x,(Screen_y + Screen_size_y - Center_y)/Size_y,(Screen_y - Center_y)/Size_y
	local period=(Right_x-Left_x)/Grapic_dots
	for i = -1, Grapic_dots+1 do
		x_num[i]=Left_x+period*i
		y_num[i]=Y_make(x_num[i])
	end
end
function Y_make(x)
	return x^3
end
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
			Graphics.drawLine(Screen_x,Screen_x+Screen_size_x,Center_y+(math.floor(Down_y)+i)*Size_y,Center_y+(math.floor(Down_y)+i)*Size_y,color_gray_fat)
		else
			Graphics.drawLine(Screen_x,Screen_x+Screen_size_x,Center_y+(math.floor(Down_y)+i)*Size_y,Center_y+(math.floor(Down_y)+i)*Size_y,color_gray_thin)
		end
		
	end
end
function JumpTo(x, y)
	local y = y or Y_make(x)
	Center_x,Center_y=(Screen_x+Screen_size_x/2+x*Size_x),(Screen_y+Screen_size_y/2-y*Size_y)
end
local function GetCenterXY()
	return (Screen_x+Screen_size_x/2+x*Size_x),(Screen_y+Screen_size_y/2-y*Size_y)
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
	Screen.flip()
	Screen.waitVblankStart()
	oldpad = pad
end