local StageEndScreenGui_init_original = StageEndScreenGui.init

function StageEndScreenGui:init(...)
	StageEndScreenGui_init_original(self, ...)

	if managers.hud then
		managers.hud:set_speed_up_endscreen_hud(5)
	end
end

function StageEndScreenGui:special_btn_released()
end