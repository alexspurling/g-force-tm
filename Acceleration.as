class DashboardAcceleration
{
	float g_dt;
	float prev_speed = 0;
	int arr_size = 4;
	array<float> acc = {0, 0, 0, 0};
	int idx = 0;
	int num_samples = 100;

	array<float> acc_f_history(num_samples);
	array<float> acc_h_history(num_samples);
	array<float> acc_v_history(num_samples);
	array<float> acc_history(num_samples);
	int idx_history = 0;

	vec3 prev_vel;
	vec3 cur_vel;
	vec3 cur_accel;
	vec3 cur_pos;

	nvg::Font m_font;
	string m_fontPath;

	DashboardAcceleration()
	{
		LoadFont();
	}

	void LoadFont()
	{
		if (Setting_Acceleration_Font == m_fontPath) {
			return;
		}

		auto font = nvg::LoadFont(Setting_Acceleration_Font);
		if (font > 0) {
			m_fontPath = Setting_Acceleration_Font;
			m_font = font;
		}
	}

    void Update(float dt, CSceneVehicleVisState@ vis) {
        // if (dt > 0) {
        //     g_dt = dt;
        // } else {
        //     g_dt = 1;
        // }
		if (dt == 0) {
			return;
		} else {
			g_dt = dt;
		}

		cur_pos = vis.Position;
		cur_vel = vis.WorldVel;
		cur_accel = vis.WorldVel - prev_vel;
		prev_vel = cur_vel;

		// Divide by 9.8 to convert from m/s/s to g
		const float G = 9.8;

		acc_history[idx_history] = cur_accel.Length() / (g_dt * G);
        acc_f_history[idx_history] = dot(cur_accel, vis.Dir) / (g_dt * G);
        acc_h_history[idx_history] = dot(cur_accel, vis.Left) / (g_dt * G);
        acc_v_history[idx_history] = dot(cur_accel, vis.Up) / (g_dt * G);
		idx_history = (idx_history + 1) % num_samples;
    }

	void RenderGeforceGraph(const vec2 &in pos, const vec2 &in size)
	{
		float max_accel = Setting_Acceleration_MaximumAcceleration;
		vec2 psize = vec2(size.x, size.y/2 - (Setting_Acceleration_BarPadding / 2));

		nvg::Save();
		nvg::BeginPath();

		nvg::Translate(0, psize.y);

		int bar_width = 2;
		int graph_pos_x = pos.x - (num_samples * bar_width) - Setting_Acceleration_BarPadding;
		int graph_pos_y = pos.y - psize.y;
		int graph_size_y = size.y;
		int graph_center_y = pos.y; //  + (Setting_Acceleration_BarPadding / 2);

		nvg::RoundedRect(graph_pos_x, graph_pos_y, num_samples * bar_width, graph_size_y, Setting_Acceleration_BorderRadius);
		nvg::StrokeWidth(Setting_Acceleration_BorderWidth);
		nvg::StrokeColor(Setting_Acceleration_BorderColor);
		nvg::FillColor(Setting_Acceleration_BackdropColor);
		nvg::Fill();

		for (uint n = 0; n < num_samples; n++) {
			int idx = (idx_history + n + 1) % num_samples;
			float acc = acc_v_history[idx];
			float accHeight = (acc / max_accel) * psize.y;
			if (accHeight >= 0) {
				nvg::Scale(1,-1);
				nvg::Scissor(graph_pos_x + (n * bar_width), pos.y - Setting_Acceleration_BarPadding / 2, bar_width, accHeight * 1.0f);
				nvg::FillColor(vec4(0, 0, 0.9, 0.5));
				nvg::Fill();
				nvg::ResetScissor();
				nvg::Scale(1,-1);
			}
			if (accHeight < 0) {
				nvg::Scissor(graph_pos_x + (n * bar_width), pos.y + Setting_Acceleration_BarPadding / 2, bar_width, accHeight * -1.0f);
				nvg::FillColor(vec4(0, 0, 0.9, 0.5));
				nvg::Fill();
				nvg::ResetScissor();
			}
		}

		for (uint n = 0; n < num_samples; n++) {
			int idx = (idx_history + n + 1) % num_samples;
			float acc = acc_h_history[idx];
			float accHeight = (acc / max_accel) * psize.y;
			if (accHeight >= 0) {
				nvg::Scale(1,-1);
				nvg::Scissor(graph_pos_x + (n * bar_width), pos.y - Setting_Acceleration_BarPadding / 2, bar_width, accHeight * 1.0f);
				nvg::FillColor(vec4(0.9, 0, 0, 0.5));
				nvg::Fill();
				nvg::ResetScissor();
				nvg::Scale(1,-1);
			}
			if (accHeight < 0) {
				nvg::Scissor(graph_pos_x + (n * bar_width), pos.y + Setting_Acceleration_BarPadding / 2, bar_width, accHeight * -1.0f);
				nvg::FillColor(vec4(0.9, 0, 0, 0.5));
				nvg::Fill();
				nvg::ResetScissor();
			}
		}

		for (uint n = 0; n < num_samples; n++) {
			int idx = (idx_history + n + 1) % num_samples;
			float acc = acc_f_history[idx];
			float accHeight = (acc / max_accel) * psize.y;
			if (accHeight >= 0) {
				nvg::Scale(1,-1);
				nvg::Scissor(graph_pos_x + (n * bar_width), pos.y - Setting_Acceleration_BarPadding / 2, bar_width, accHeight * 1.0f);
				nvg::FillColor(vec4(0, 0.9f, 0, 0.5));
				nvg::Fill();
				nvg::ResetScissor();
				nvg::Scale(1,-1);
			}
			if (accHeight < 0) {
				nvg::Scissor(graph_pos_x + (n * bar_width), pos.y + Setting_Acceleration_BarPadding / 2, bar_width, accHeight * -1.0f);
				nvg::FillColor(vec4(0, 0.9f, 0, 0.5));
				nvg::Fill();
				nvg::ResetScissor();
			}
		}

		nvg::BeginPath();
		nvg::RoundedRect(graph_pos_x, graph_pos_y, num_samples * bar_width, graph_size_y, Setting_Acceleration_BorderRadius);
		nvg::Stroke();
		nvg::Restore();
	}

	void RenderMaxValues() {

        nvg::Translate(-(num_samples * 2), 0);

        nvg::TextAlign(nvg::Align::Left | nvg::Align::Center);
        nvg::FontFace(m_font);
        nvg::FontSize(Setting_Acceleration_FontSize);
        nvg::FillColor(Setting_Acceleration_TextColor);

        nvg::TextBox(15, 20, 200, Text::Format("Max F: %.2fg", get_minmax(acc_f_history)));
        nvg::TextBox(15, 40, 200, Text::Format("Max H: %.2fg", get_minmax(acc_h_history)));
        nvg::TextBox(15, 60, 200, Text::Format("Max V: %.2fg", get_minmax(acc_v_history)));

        nvg::BeginPath();
		nvg::Rect(0, 10, 10, 10);
		nvg::FillColor(vec4(0, 1, 0, 0.75));
		nvg::Fill();
        nvg::ClosePath();

        nvg::BeginPath();
		nvg::Rect(0, 30, 10, 10);
		nvg::FillColor(vec4(1, 0, 0, 0.75));
		nvg::Fill();
        nvg::ClosePath();

        nvg::BeginPath();
		nvg::Rect(0, 50, 10, 10);
		nvg::FillColor(vec4(0, 0, 1, 0.75));
		nvg::Fill();
        nvg::ClosePath();

	}

    void drawLine(vec2 start, vec2 end, vec4 color) {
        nvg::BeginPath();
        nvg::MoveTo(start);
        nvg::LineTo(end);
        nvg::StrokeColor(color);
        nvg::StrokeWidth(3);
        nvg::Stroke();
        nvg::ClosePath();
    }

    float dot(vec3 v1, vec3 v2) {
        return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
    }

    vec3 cross(vec3 v1, vec3 v2) {
        const float cross_x = v1.y * v2.z - v1.z * v2.y;
        const float cross_y = v1.z * v2.x - v1.x * v2.z;
        const float cross_z = v1.x * v2.y - v1.y * v2.x;
        return vec3(cross_x, cross_y, cross_z);
    }

    string toStr(vec3 vec) {
        return "x: " + vec.x + ", y: " + vec.y + ", z: " + vec.z;
    }

    string toStr(vec2 vec) {
        return "x: " + vec.x + ", y: " + vec.y;
    }

    void drawVector(vec3 pos, vec3 direction, vec4 color) {

        const float directionLength = direction.Length();
        if (directionLength == 0) {
            return;
        }
        const vec3 unit = direction.Normalized();

        vec3 v_perp = cross(unit, vec3(0, 1, 0));
        if (v_perp.Length() > 0) {
            v_perp = v_perp.Normalized();
        } else {
            v_perp = vec3(1, 0, 0);
        }

        float tip_length = 0.1;
        float tip_width = 0.05;

        const vec3 tip_base = direction - unit * tip_length;
        const vec3 tip1 = tip_base + v_perp * tip_width;
        const vec3 tip2 = tip_base - v_perp * tip_width;

		const vec2 startPoint = Camera::ToScreenSpace(pos);
        const vec2 endPoint = Camera::ToScreenSpace(pos + direction);
        const vec2 tip1Point = Camera::ToScreenSpace(pos + tip1);
        const vec2 tip2Point = Camera::ToScreenSpace(pos + tip2);

        const vec2 endPointPerp = Camera::ToScreenSpace(pos + v_perp);
        const vec2 endPoint2 = Camera::ToScreenSpace(pos + vec3(1, 0, 0));

        if (Math::IsNaN(endPoint.x) || Math::IsNaN(tip1Point.x) || Math::IsNaN(tip2Point.x)) {
            print("pos: " + toStr(pos));
            print("direction: " + toStr(direction));
            print("unit: " + toStr(unit));
            print("cross: " + toStr(cross(unit, vec3(0, 1, 0))));
            print("v_perp: " + toStr(v_perp));
        }
        drawLine(startPoint, endPoint, color);
        // drawLine(startPoint, endPointPerp, vec4(0.0f, 0.0f, 1.0f, 0.5f));
        // drawLine(startPoint, endPoint2, vec4(0.0f, 1.0f, 0.0f, 0.5f));
        drawLine(endPoint, tip1Point, color);
        drawLine(endPoint, tip2Point, color);
    }

    float get_minmax(array<float> arr) {
        float min_value = 0;
        float max_value = 0;

        for (uint i = 0; i < arr.Length; i++) {
            if (arr[i] < min_value) {
                min_value = arr[i];
            }
            if (arr[i] > max_value) {
                max_value = arr[i];
            }
        }

        if (-min_value > max_value) {
            return min_value;
        }
        return max_value;
    }

	void Render(CSceneVehicleVisState@ vis)
	{
		vec2 offset = vec2(0.0f, 0.0f);
		vec2 size = m_size;

        // RenderPositiveAccelerometer(offset, size, curr_acc);
        // RenderNegativeAccelerometer(offset, size, curr_acc);
        RenderGeforceGraph(offset, size);

		if (Setting_Acceleration_ShowMaxValues) {
			RenderMaxValues();
		}

		nvg::ResetTransform();

		if (Setting_Show_Vectors) {
			const vec3 cur_pos = vis.Position;
			// The position of the car in Camera 3 is just slightly ahead of the camera so it
			// behaves weirdly when we draw the vectors. We need a bit of buffer
			float w = (Camera::GetProjectionMatrix() * cur_pos).w;
			if (w < -0.05) {
				drawVector(cur_pos, cur_vel * 0.1, vec4(1, 0.5, 0, 0.5));
				drawVector(cur_pos, cur_accel, vec4(1, 0, 0, 0.5));
			}
		}

        // drawVector(vis.Position, vis.Dir, vec4(1, 0, 0, 0.5));
        // drawVector(vis.Position, vis.Left, vec4(0, 1, 0, 0.5));
        // drawVector(vis.Position, vis.Up, vec4(0, 0, 1, 0.5));
	}
}
