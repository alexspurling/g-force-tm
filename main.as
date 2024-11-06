nvg::Font m_SpeedFont;
vec2 m_size;
vec2 m_center;
vec4 BasicDigitalGaugeSpeedIdleColor;
vec4 BasicDigitalGaugeSpeedColor;
float cur_speed;
float last_speed;
float cur_accel;
float last_timestep;

int64 cruiseSetTime = 0;

DashboardAcceleration@ acceleration;

void Main()
{
    print("Loading fonts");
    m_SpeedFont = nvg::LoadFont("src/Fonts/Oswald-Light-Italic.ttf");
    m_size = vec2(200, 200);
    m_center = vec2(m_size.x * 0.5f, m_size.y * 0.5f);
    BasicDigitalGaugeSpeedIdleColor = vec4(0.0f, 0.0f, 0.0f, 0.5f);
    BasicDigitalGaugeSpeedColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

    @acceleration = DashboardAcceleration();
    // while (true) {
    //     print(cur_speed);
    //     sleep(1000);
    // }
}

float xPos = 0;
float initialXPos = 0;
float finalXPos = 0;

uint last_time;
float last_ghost_time;

void Update(float dt)
{

	// auto playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);

	// if (playground is null
	// 	|| playground.Arena is null
	// 	|| playground.Map is null)
	// {
	// 	return;
	// }

	// auto player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
	// auto scriptPlayer = player is null ? null : cast<CSmScriptPlayer>(player.ScriptAPI);

    // if (scriptPlayer is null) {
    //     return;
    // }

    // int64 raceTime = GetRaceTime(scriptPlayer);

    // if (raceTime < 0) {
    //     cruiseSetTime = 0;
    //     finalXPos = 0;
    // }

    // auto vis = VehicleState::ViewingPlayerState();
    // if (vis is null) return;

    // xPos = vis.Position.x;

    // // If we finished the round then print the final x position
	// if (playground.GameTerminals[0].UISequence_Current != CGamePlaygroundUIConfig::EUISequence::Playing)
    // {
    //     if (finalXPos == 0) {
    //         finalXPos = xPos;
    //         int64 finalTime = raceTime - cruiseSetTime;
    //         print("finalTime: " + finalTime + ", final dist: " + (initialXPos - xPos));
    //     }
    // }

    // auto cruiseSpeed = VehicleState::GetCruiseDisplaySpeed(vis);
    // if (cruiseSetTime == 0 && cruiseSpeed > 0) {
    //     print(raceTime + ", " + cruiseSpeed + ", " + xPos);
    //     cruiseSetTime = raceTime;
    //     initialXPos = xPos;
    // }

    // auto players = VehicleState::GetAllVis(GetApp().GameScene);

    // if (players == null || players.Length == 0) {
    //     return;
    // }

    // acceleration.Update(dt, players[0].AsyncState);


    float cur_time = getReplayScrubPosition();
    if (cur_time == -1) {
        cur_time = GetCurrentGhostTime();
    }

    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null) return;

    float delta = cur_time - last_ghost_time;
    last_ghost_time = cur_time;
    int deltaInt = delta * 1000;
    if (deltaInt != 0) {
        acceleration.Update(deltaInt, visState);
    }

    /*
    if (Ghosts_PP::IsSpectatingGhost()) {
        const float cur_time = GetCurrentGhostTime();
        float delta = cur_time - last_ghost_time;
        last_ghost_time = cur_time;
        int deltaInt = delta * 1000;
        if (deltaInt != 0) {
            acceleration.Update(deltaInt, visState);
        }
    } else {

        auto playgroundScript = cast<CSmArenaRulesMode>(GetApp().PlaygroundScript);
        if (playgroundScript is null) return;

        const uint cur_time = playgroundScript.Now;

        float delta = cur_time - last_time;
        last_time = cur_time;
        acceleration.Update(delta, visState);
    }
    */
}

float getReplayScrubPosition() {
    auto app = GetApp();
    auto editor = app.Editor;
    if (!(editor is null)) {
        auto pluginApi = editor.PluginAPI;
        if (!(pluginApi is null)) {
            CGameEditorMediaTrackerPluginAPI@ mtPlugin = cast<CGameEditorMediaTrackerPluginAPI>(pluginApi);
            return mtPlugin.CurrentTimer;
        }
    }
    return -1;
}

int64 GetRaceTime(CSmScriptPlayer& scriptPlayer)
{
	if (scriptPlayer is null)
		// not playing
		return 0;

	auto playgroundScript = cast<CSmArenaRulesMode>(GetApp().PlaygroundScript);

	if (playgroundScript is null)
		// Online
		return GetApp().Network.PlaygroundClientScriptAPI.GameTime - scriptPlayer.StartTime;
	else
		// Solo
		return playgroundScript.Now - scriptPlayer.StartTime;
}

float GetCurrentGhostTime()
{
    auto app = GetApp();

    auto scene = app.GameScene;
    if (scene is null)
        return 0.1f;

    auto nod = Dev::GetOffsetNod(scene, 0x120);
    if (nod is null)
        return 0.2f;

    auto ghostClips = Dev::ForceCast<NGameGhostClips_SMgr@>(nod).Get();
    if (ghostClips is null)
        return 0.3f;

    auto clipPlayer = cast<CGameCtnMediaClipPlayer>(Dev::GetOffsetNod(ghostClips, 0x20));
    if (clipPlayer is null)
        return 0.4f;

    float time = Dev::GetOffsetFloat(clipPlayer, 0x1b4);

    return time;
}

string arrToStr(array<int8> arr) {
    string output = "";
    for (uint i = 0; i < arr.Length; i++) {
        output += Text::Format("%02X", arr[i]);
    }
    return output;
}

array<int8> readIntoArray(CGameCtnApp@&in object, int len) {
    array<int8> arr(len);
    for (uint i = 0; i < arr.Length; i++) {
        arr[i] = Dev::GetOffsetInt8(object, i);
    }
    return arr;
}

void Render()
{
    // auto visState = VehicleState::ViewingPlayerState();
    // if (visState is null) return;

    // vec2 margin = vec2(40, 40);

    auto visState = VehicleState::ViewingPlayerState();

    // auto data = Dev::Read(Dev::BaseAddress(), 16);

    // auto data appData = Dev::GetOffsetString(app, 0)

    // auto ptr = uint64(cast<void@>(app));

	// array<int8> byteArray = readIntoArray(app, 32);

    // array<int8> f = cast<array<int8>>(data);

    // nvg::BeginPath();
    // nvg::FontFace(m_SpeedFont);
    // nvg::FontSize(20);
    // nvg::Text(10, 60, Text::Format("%llu", Dev::BaseAddress()));
    // nvg::Text(10, 100, Text::Format("%f", curTime));
    // nvg::ClosePath();

    // auto players = VehicleState::GetAllVis(GetApp().GameScene);

    // if (players == null || players.Length == 0) {
    //     return;
    // }

    // VehicleState::GetViewingPlayer();
    // players[0].AsyncState


	nvg::Translate(Draw::GetWidth() -10, Draw::GetHeight() - 450);

    acceleration.Render(visState);

    nvg::Restore();
}