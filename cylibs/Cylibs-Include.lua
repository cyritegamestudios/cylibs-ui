current_cylibs_include_version = "1.1.0"

function init_include()
	print('Loaded Cylibs Version: '..current_cylibs_include_version)

	require('cylibs/util/Modes')
	require('cylibs/util/States')

	-- Actions
	ActionQueue = require('cylibs/actions/action_queue')

	SpellAction = require('cylibs/actions/spell')
	WaitAction = require('cylibs/actions/wait')
	RunToAction = require('cylibs/actions/runto')
	RunToLocationAction = require('cylibs/actions/runtolocation')
	RunAwayAction = require('cylibs/actions/runaway')
	RunBehindAction = require('cylibs/actions/runbehind')
	WalkAction = require('cylibs/actions/walk')
	CommandAction = require('cylibs/actions/command')
	BloodPactRageAction = require('cylibs/actions/blood_pact_rage')
	BloodPactWardAction = require('cylibs/actions/blood_pact_ward')
	JobAbilityAction = require('cylibs/actions/job_ability')
	StrategemAction = require('cylibs/actions/strategem')
	WeaponSkillAction = require('cylibs/actions/weapon_skill')
	SequenceAction = require('cylibs/actions/sequence')
	BlockAction = require('cylibs/actions/block')

	-- Conditions
	Condition = require('cylibs/conditions/condition')
	InBattleCondition = require('cylibs/conditions/in_battle')
	IdleCondition = require('cylibs/conditions/idle')
	HasBuffCondition = require('cylibs/conditions/has_buff_condition')
	HasBuffsCondition = require('cylibs/conditions/has_buffs')
	MinHitPointsPercentCondition = require('cylibs/conditions/min_hpp')
	MaxHitPointsPercentCondition = require('cylibs/conditions/max_hpp')
	HitPointsPercentRangeCondition = require('cylibs/conditions/hpp_range')
	MaxDistanceCondition = require('cylibs/conditions/max_distance')
	MinManaPointsCondition = require('cylibs/conditions/min_mp')
	NotCondition = require('cylibs/conditions/not_condition')
	SpellRecastReadyCondition = require('cylibs/conditions/spell_recast_ready')
	ValidTargetCondition = require('cylibs/conditions/valid_target')

	-- Battle
	MobTracker = require('cylibs/battle/mob_tracker')
	MonsterBuffTracker = require('cylibs/battle/monster_buff_tracker')
	Spell = require('cylibs/battle/spell')
	Buff = require('cylibs/battle/spells/buff')
	Debuff = require('cylibs/battle/spells/debuff')
	Roll = require('cylibs/battle/roll')

	-- Roles
	Role = require('cylibs/trust/roles/role')

	-- Util
	action_message_util = require('cylibs/util/action_message_util')
	player_util = require('cylibs/util/player_util')
	pet_util = require('cylibs/util/pet_util')
	buff_util = require('cylibs/util/buff_util')
	spell_util = require('cylibs/util/spell_util')
	geometry_util = require('cylibs/util/geometry_util')
	ffxi_util = require('cylibs/util/ffxi_util')
	battle_util = require('cylibs/util/battle_util')
	party_util = require('cylibs/util/party_util')
	pup_util = require('cylibs/util/pup_util')
	job_util = require('cylibs/util/job_util')
	flanking_util = require('cylibs/util/flanking_util')
	
	Trust = require('cylibs/trust/trust')
	Monster = require('cylibs/battle/monster')

	-- Entities
	Player = require('cylibs/entity/player')
	PartyMember = require('cylibs/entity/party_member')
end

function check_cylibs_version(addon_version)
	return addon_version == current_cylibs_include_version
end

init_include()


