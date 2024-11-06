[Setting hidden]
bool Setting_General_ShowAcceleration = false;
[Setting hidden]
bool Setting_General_ShowAccelerationHidden = false;
[Setting hidden]
vec2 Setting_General_AccelerationPos = vec2(0.720f, 0.120f);
[Setting hidden]
vec2 Setting_General_AccelerationSize = vec2(50, 340);


[Setting category="Acceleration" name="Backdrop color" color]
vec4 Setting_Acceleration_BackdropColor = vec4(0, 0, 0, 0.7f);

[Setting category="Acceleration" name="Border color" color]
vec4 Setting_Acceleration_BorderColor = vec4(1, 1, 1, 1);

[Setting category="Acceleration" name="Border width" drag min=0 max=10]
float Setting_Acceleration_BorderWidth = 3.0f;

[Setting category="Acceleration" name="Border radius" drag min=0 max=50]
float Setting_Acceleration_BorderRadius = 5.0f;

[Setting category="Acceleration" name="Maximum acceleration in g" drag min=0 max=250]
float Setting_Acceleration_MaximumAcceleration = 15.0f;

[Setting category="Acceleration" name="Bar padding" drag min=0 max=100]
float Setting_Acceleration_BarPadding = 7.5f;

[Setting category="Acceleration" name="Enable smoothing"]
bool Setting_Acceleration_Smoothing = true;

[Setting category="Acceleration" name="Show max values"]
bool Setting_Acceleration_ShowMaxValues = true;

[Setting category="Acceleration" name="Text padding" drag min=0 max=100]
float Setting_Acceleration_TextPadding = 20.0f;

[Setting category="Acceleration" name="Text color" color]
vec4 Setting_Acceleration_TextColor = vec4(1, 1, 1, 1);

[Setting category="Acceleration" name="Font"]
string Setting_Acceleration_Font = "DroidSans.ttf";

[Setting category="Acceleration" name="Font size" drag min=0 max=100]
float Setting_Acceleration_FontSize = 15.0f;

[Setting category="Acceleration" name="Show velocity and acceleration vectors"]
bool Setting_Show_Vectors = false;
