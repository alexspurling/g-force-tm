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

// don't blame me if you crash your game
uint64 Dev_GetPtrForNod(CMwNod@ nod) {
    if (nod is null) throw("null nod passed"); // return 0 here if you prefer, but remember to check it later!
    uint64 vtablePtr = Dev::GetOffsetUint64(nod, 0); // store the vtable ptr to restore later
    Dev::SetOffset(nod, 0, nod); // think about this from first principles if this doesn't make sense
    uint64 nodPtr = Dev::GetOffsetUint64(nod, 0); // read the nod ptr
    Dev::SetOffset(nod, 0, vtablePtr); // restore vtable ptr otherwise you will get a crash trying to do like anything with the nod
    return nodPtr; // ^_^
}

void printMembers(string type) {
    auto refinfo = Reflection::GetType(type);

    if (refinfo is null) {
        print("\\$<\\$c11\\$ Type not found: \\$>" + type);
        return;
    }
    auto refMembers = refinfo.get_Members();

    print("Found " + refMembers.Length + "members of type " + type + ":");
    for (int i = 0; i < refMembers.Length; i++) {
        auto mi = refMembers[i];


        print("Got member: " + mi.get_Name() + ", offset: " + mi.Offset);
    }
}

void Main()
{
    print("Loading fonts");
    m_SpeedFont = nvg::LoadFont("src/Fonts/Oswald-Light-Italic.ttf");
    m_size = vec2(200, 200);
    m_center = vec2(m_size.x * 0.5f, m_size.y * 0.5f);
    BasicDigitalGaugeSpeedIdleColor = vec4(0.0f, 0.0f, 0.0f, 0.5f);
    BasicDigitalGaugeSpeedColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

    @acceleration = DashboardAcceleration();


    auto app = GetApp();

    printMembers("CGameCtnApp");
    printMembers("CGameUserManagerScript");

    // Get the address of the GameScene
    auto gameScenePtr = Dev::GetOffsetUint64(app, 672);

    // App -> GameScene -> 120 -> 20 -> 1B4


    print("\\$<\\$1c1Game App Ptr:\\$> " + Text::FormatPointer(Dev_GetPtrForNod(app)));
    print("GameScene ptr: " + Text::FormatPointer(gameScenePtr));


    auto userManager = app.UserManagerScript;
    if (userManager !is null) {
        print("UserManagerScript addr: " + Text::FormatPointer(Dev_GetPtrForNod(userManager)));
        auto nod1 = Dev::GetOffsetNod(userManager, 0x180);
        print("Nod1 addr: " + Text::FormatPointer(Dev_GetPtrForNod(nod1)));
        auto nod2 = Dev::GetOffsetNod(nod1, 0x88);
        print("Nod2 addr: " + Text::FormatPointer(Dev_GetPtrForNod(nod2)));
        auto timer = Dev::GetOffsetUint64(nod2, 0xE8);
        print("Timer: " + timer);
    }


    // auto nod2 = Dev::GetOffsetNod(nod1, 0x88);
    // auto timerPtr = Dev::GetOffsetUint64(nod2, 0xE8);
    // const uint64 gameTime = Dev::ReadInt32(timerPtr);

    // print("\\$<\\$1c1\\$Ptr:\\$> " + Text::FormatPointer(Dev_GetPtrForNod(cast<CMwNod>(app.GameScene))));
    // print("\\$<\\$1c1\\$Ptr:\\$> " + Text::FormatPointer(Dev_GetPtrForNod(app.DefaultStyleSheet)));
    // print("\\$<\\$1c1\\$Ptr:\\$> " + Text::FormatPointer(Dev_GetPtrForNod(app.Network)));
    // print("\\$<\\$1c1\\$Ptr:\\$> " + Text::FormatPointer(Dev_GetPtrForNod(app.PlaygroundScript)));


    // while (true) {
    //     print(cur_speed);
    //     sleep(1000);
    // }
}

float xPos = 0;
float initialXPos = 0;
float finalXPos = 0;

float last_time;

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


    // float cur_time = getReplayScrubPosition();
    // if (cur_time == -1) {
    //     // cur_time = GetCurrentGhostTime();
    //     // print("Ghost time: " + cur_time);

    //     auto playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);

    //     if (playground is null
    //     	|| playground.Arena is null
    //     	|| playground.Map is null)
    //     {
    //         print("No playground");
    //     	return;
    //     }

    //     auto player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
    //     auto scriptPlayer = player is null ? null : cast<CSmScriptPlayer>(player.ScriptAPI);

    //     if (scriptPlayer is null) {
    //         print("No script player");
    //     }
    //     cur_time = GetRaceTime(scriptPlayer) / 1000.0;
    //     print("Race time: " + cur_time);
    // }
    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null) return;

    float race_time = GetRaceTime();
    float my_time = GetMyFloatRaceTime(visState);
    print(my_time);
    float cur_ghost_time = GetCurrentGhostTime();

    float cur_time = my_time;


    float delta = cur_time - last_time;

    last_time = cur_time;
    int deltaInt = delta * 1000;
    // if (delta != 0) {
        print("My time: " + my_time + ", race time: " + race_time + ", cur_ghost_time: " + cur_ghost_time + ", delta f: " + delta + ", delta int: " + deltaInt);
    // }
    if (deltaInt != 0) {
        acceleration.Update(delta, visState);
    }

    // if (Ghosts_PP::IsSpectatingGhost()) {
        // const float cur_time = GetCurrentGhostTime();
        // float delta = cur_time - last_ghost_time;
        // last_ghost_time = cur_time;
        // int deltaInt = delta * 1000;
        // if (deltaInt != 0) {
        //     acceleration.Update(deltaInt, visState);
        // }
    // } else {

    //     auto playgroundScript = cast<CSmArenaRulesMode>(GetApp().PlaygroundScript);
    //     if (playgroundScript is null) return;

    //     const uint cur_time = playgroundScript.Now;

    //     float delta = cur_time - last_time;
    //     last_time = cur_time;
    //     acceleration.Update(delta, visState);
    // }
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

float GetRaceTime()
{
    auto app = GetApp();
    // print("app timesinceinit: " + app.TimeSinceInitMs);
	auto playground = cast<CSmArenaClient>(app.CurrentPlayground);

	if (playground is null
		|| playground.Arena is null
		|| playground.Map is null)
	{
		return 0.5;
	}

	auto player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
	auto scriptPlayer = player is null ? null : cast<CSmScriptPlayer>(player.ScriptAPI);

	if (scriptPlayer is null)
		// not playing
		return 0.6;

	auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);

	if (playgroundScript is null) {
		// Online
        uint64 gameTime = app.Network.PlaygroundClientScriptAPI.GameTime;
        print("gameTime: " + gameTime);
		return (gameTime - scriptPlayer.StartTime) / 1000.0;
    } else {
		// Solo
        uint64 playgroundTime = playgroundScript.Now;
        uint64 timeSinceInit = app.TimeSinceInitMs;
        uint64 timeSinceStart = timeSinceInit - scriptPlayer.StartTime;
        // print("playgroundScript.now: " + playgroundTime + ", timeSinceInit: " + timeSinceInit + ", timeSinceStart: " + timeSinceStart);
		return (playgroundTime - scriptPlayer.StartTime) / 1000.0;
    }
}

float GetMyRaceTime()
{
    auto app = GetApp();
	const uint64 baseAddress = Dev::BaseAddress();
    const int gameTime = Dev::ReadInt32(baseAddress + 0x2011704);
    // const int gameTimeWithMs = gameTime + (app.TimeSinceInitMs % 10);
    return gameTime / 1000.0;
}

float GetMyFloatRaceTime(CSceneVehicleVisState@ vis)
{
    // auto app = GetApp();
    // print("app timesinceinit: " + app.TimeSinceInitMs);
	// auto playground = cast<CSmArenaClient>(app.CurrentPlayground);

	// if (playground is null
	// 	|| playground.Arena is null
	// 	|| playground.Map is null)
	// {
	// 	return 0.7;
	// }

	// auto player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
	// auto scriptPlayer = player is null ? null : cast<CSmScriptPlayer>(player.ScriptAPI);

	// if (scriptPlayer is null)
	// 	// not playing
	// 	return 0.8;


    // auto userManager = app.UserManagerScript;
    // if (userManager is null) {
    //     return 0.9;
    // }
    // print("UserManagerScript addr: " + Text::FormatPointer(Dev_GetPtrForNod(userManager)));
    // auto nod1 = Dev::GetOffsetNod(userManager, 0x180);
    // // print("Nod1 addr: " + Text::FormatPointer(Dev_GetPtrForNod(nod1)));
    // auto nod2 = Dev::GetOffsetNod(nod1, 0x88);
    // // print("Nod2 addr: " + Text::FormatPointer(Dev_GetPtrForNod(nod2)));
    // const uint64 gameTime = Dev::GetOffsetUint64(nod2, 0xE8);
    // print("Timer addr: " + Text::FormatPointer(timerPtr));

	const uint64 baseAddress = Dev::BaseAddress();
    const uint64 gameTime = Dev::ReadUInt64(baseAddress + 0x1F01B38);
    // const uint64 timer = gameTime - scriptPlayer.StartTime;
    const uint64 timer = gameTime - vis.RaceStartTime;
    return timer / 1000.0;
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

    if (visState is null) {
        return;
    }

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