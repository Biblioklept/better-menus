Hooks:PostHook(MultiProfileManager, "set_current_profile", "checkSkillPoints", function(self, index)
	local skt = managers.skilltree
	local profile = self:profile(index)
	local data = skt._global.skill_switches[profile.skillset]
	if skt:total_points_spent(data) > skt:max_points_for_current_level() then
		self:set_current_profile(1)
		profile.skillset = index
	end
end)

Hooks:PostHook(MultiProfileManager, "infamy_reset", "keepSkillsets", function(self)
	self:set_current_profile(1)
	for index, profile in pairs(self._global._profiles) do
		profile.skillset = index
	end
end)