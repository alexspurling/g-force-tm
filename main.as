DashboardAcceleration@ acceleration;

void Main()
{
    @acceleration = DashboardAcceleration();
}

bool usingRaceTime = false;
bool usingGhostTime = false;
float last_time;

void Update(float dt)
{
    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null) return;

    float cur_ghost_time = GetCurrentGhostTime();

    float cur_time = 0;
    float race_time = 0;
    if (cur_ghost_time > 0) {
        cur_time = cur_ghost_time;
        if (!usingGhostTime) {
            print("Using ghost time");
            usingGhostTime = true;
            usingRaceTime = false;
        }
    } else {
        race_time = GetRaceTime(visState);
        cur_time = race_time;
        if (!usingRaceTime) {
            print("Using race time");
            usingRaceTime = true;
            usingGhostTime = false;
        }
    }

    float delta = cur_time - last_time;

    last_time = cur_time;
    // int deltaInt = delta * 1000;
    // if (delta != 0) {
    //     print("Race time: " + race_time + ", cur_ghost_time: " + cur_ghost_time + ", delta f: " + delta);
    // } else {
    //     print("\\$<\\$c11Race time: " + race_time + ", cur_ghost_time: " + cur_ghost_time + ", delta f: " + delta + "\\$>");
    // }
    acceleration.Update(delta, visState);
}

float GetRaceTime(CSceneVehicleVisState@ vis)
{
	const uint64 baseAddress = Dev::BaseAddress();
    // Global variable that holds the current race timer in ms
    const uint64 gameTime = Dev::ReadUInt64(baseAddress + 0x1F01B38);
    const uint64 timer = gameTime - vis.RaceStartTime;
    return timer / 1000.0;
}

float GetCurrentGhostTime()
{
    auto app = GetApp();

    auto scene = app.GameScene;
    if (scene is null)
        return -1.0f;

    auto nod = Dev::GetOffsetNod(scene, 0x120);
    if (nod is null)
        return -2.0f;

    auto ghostClips = Dev::ForceCast<NGameGhostClips_SMgr@>(nod).Get();
    if (ghostClips is null)
        return -3.0f;

    auto clipPlayer = cast<CGameCtnMediaClipPlayer>(Dev::GetOffsetNod(ghostClips, 0x20));
    if (clipPlayer is null)
        return -4.0f;

    return Dev::GetOffsetFloat(clipPlayer, 0x1b4);
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
    auto visState = VehicleState::ViewingPlayerState();

    if (visState is null) {
        return;
    }

	nvg::Translate(Draw::GetWidth() -10, Draw::GetHeight() - 450);

    acceleration.Render(visState);

    nvg::Restore();
}