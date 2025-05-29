
Hooks:PostHook(BlackMarketGui, 'populate_mods', 'always_show_weapon_mod_stats',
function(self, data)
	for _ , i in ipairs(data) do 
		if not i.comparision_data then
			i.comparision_data = managers.blackmarket:get_weapon_stats_with_mod(i.category, i.slot, i.mod_name)
		end
	end
end)
