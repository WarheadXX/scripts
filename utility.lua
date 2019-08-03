Auxiliary={}
aux=Auxiliary
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE
RACE_CYVERSE=RACE_CYBERSE
usingsanctuary=false

function Auxiliary.ExtraLinked(c,emc,card,eg)
	eg:AddCard(c)
	local res
	if c==emc then
		res=eg:IsContains(card)
	else
		local g=c:GetMutualLinkedGroup()
		res=g and g:IsExists(Auxiliary.ExtraLinked,1,eg,emc,card,eg)
	end
	eg:RemoveCard(c)
	return res
end
function Card.IsExtraLinked(c)
	local card50=Duel.GetFieldCard(0,LOCATION_MZONE,5)
	local card60=Duel.GetFieldCard(0,LOCATION_MZONE,6)
	if card50 and card60 then
		local mg=card50:GetMutualLinkedGroup()
		return mg and mg:IsExists(Auxiliary.ExtraLinked,1,nil,card60,c,Group.FromCards(card50))
	end
	local card51=Duel.GetFieldCard(1,LOCATION_MZONE,5)
	local card61=Duel.GetFieldCard(1,LOCATION_MZONE,6)
	if card51 and card61 then
		local mg=card51:GetMutualLinkedGroup()
		return mg and mg:IsExists(Auxiliary.ExtraLinked,1,nil,card61,c,Group.FromCards(card51))
	end
	return false
end
function Auxiliary.Stringid(code,id)
	return code*16+id
end
function Auxiliary.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
function Auxiliary.NULL()
end
function Auxiliary.TRUE()
	return true
end
function Auxiliary.FALSE()
	return false
end
function Auxiliary.AND(f1,f2)
	return	function(a,b,c)
				return f1(a,b,c) and f2(a,b,c)
			end
end
function Auxiliary.OR(f1,f2)
	return	function(a,b,c)
				return f1(a,b,c) or f2(a,b,c)
			end
end
function Auxiliary.NOT(f)
	return	function(a,b,c)
				return not f(a,b,c)
			end
end
function Auxiliary.BeginPuzzle(effect)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.PuzzleOp)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_SP)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,0)
end
function Auxiliary.PuzzleOp(e,tp)
	Duel.SetLP(0,0)
end
function Auxiliary.IsDualState(effect)
	local c=effect:GetHandler()
	return not c:IsDisabled() and c:IsDualState()
end
function Auxiliary.IsNotDualState(effect)
	local c=effect:GetHandle()
	return c:IsDisabled() or not c:IsDualState()
end
function Auxiliary.DualNormalCondition(effect)
	local c=effect:GetHandler()
	return c:IsFaceup() and not c:IsDualState()
end
function Auxiliary.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
end
--register effect of return to hand for Spirit monsters
function Auxiliary.EnableSpiritReturn(c,event1,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.SpiritReturnReg)
	c:RegisterEffect(e1)
	for i,event in ipairs{...} do
		local e2=e1:Clone()
		e2:SetCode(event)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnCondition)
	e1:SetTarget(Auxiliary.SpiritReturnTarget)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function Auxiliary.SpiritReturnCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function Auxiliary.SpiritReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function Auxiliary.SpiritReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function Auxiliary.IsUnionState(effect)
	local c=effect:GetHandler()
	return c:IsHasEffect(EFFECT_UNION_STATUS)
end
function Auxiliary.SetUnionState(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNION_STATUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	if c.old_union then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_OLDUNION_STATUS)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.CheckUnionEquip(uc,tc)
	ct1,ct2=tc:GetUnionCount()
	if uc.old_union then return ct1==0
	else return ct2==0 end
end
-- function Auxiliary.TargetEqualFunction(f,value,a,b,c)
	-- return	function(effect,target)
				-- return f(target,a,b,c)==value
			-- end
-- end
-- function Auxiliary.TargetBoolFunction(f,a,b,c)
	-- return	function(effect,target)
				-- return f(target,a,b,c)
			-- end
-- end
-- function Auxiliary.FilterEqualFunction(f,value,a,b,c)
	-- return	function(target)
				-- return f(target,a,b,c)==value
			-- end
-- end
-- function Auxiliary.FilterBoolFunction(f,a,b,c)
	-- return	function(target)
				-- return f(target,a,b,c)
			-- end
-- end
function Auxiliary.TargetEqualFunction(f,value,...)
	local params={...}
	return	function(effect,target)
				return f(target,table.unpack(params))==value
			end
end
function Auxiliary.TargetBoolFunction(f,...)
	local params={...}
	return	function(effect,target)
				return f(target,table.unpack(params))
			end
end
function Auxiliary.FilterEqualFunction(f,value,...)
	local params={...}
	return	function(target)
				return f(target,table.unpack(params))==value
			end
end
--used for Material Types Filter Bool (works for IsRace, IsAttribute, IsType)
function Auxiliary.FilterBoolFunctionEx(f,value)
	return	function(target,scard,sumtype,tp)
				return f(target,value,scard,sumtype,tp)
			end
end
function Auxiliary.FilterBoolFunction(f,...)
	local params={...}
	return	function(target)
				return f(target,table.unpack(params))
			end
end
Auxiliary.ProcCancellable=false
function Auxiliary.IsMaterialListCode(c,...)
	if not c.material then return false end
	local codes={...}
	for _,code in ipairs(codes) do
		for _,mcode in ipairs(c.material) do
			if code==mcode then return true end
		end
	end
	return false
end
function Auxiliary.IsMaterialListSetCard(c,...)
	if not c.material_setcode then return false end
	local setcodes={...}
	for _,setcode in ipairs(setcodes) do
		if type(c.material_setcode)=='table' then
			for _,v in ipairs(c.material_setcode) do
				if v==setcode then return true end
			end
		else
			if c.material_setcode==setcode then return true end
		end
	end
	return false
end
function Auxiliary.IsCodeListed(c,...)
	if not c.listed_names then return false end
	local codes={...}
	for _,code in ipairs(codes) do
		for _,ccode in ipairs(c.listed_names) do
			if code==ccode then return true end
		end
	end
	return false
end
-- function Auxiliary.IsCodeListed(c,code)
	-- if not c.card_code_list then return false end
	-- for i,ccode in ipairs(c.card_code_list) do
		-- if code==ccode then return true end
	-- end
	-- return false
-- end
--Returns the zones, on the specified player's field, pointed by the specified number of Link markers. Includes Extra Monster Zones.
-- function Duel.GetZoneWithLinkedCount(count,tp)
	-- local g = Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	-- local zones = {}
	-- local z = {0x1,0x2,0x4,0x8,0x10,0x20,0x40}
	-- for _,zone in ipairs(z) do
		-- local ct = 0
		-- for tc in aux.Next(g) do
			-- if (zone and tc:GetLinkedZone(tp))~= 0 then
				-- ct = ct + 1
			-- end
		-- end
		-- zones[zone] = ct
	-- end
	-- local rzone = 0
	-- for i,ct in pairs(zones) do
		-- if ct >= count then
			-- rzone = i
		-- end
	-- end
	-- return rzone
-- end
function Card.IsInMainMZone(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and (not tp or c:IsControler(tp))
end
function Duel.GetZoneWithLinkedCount(c,count,tp)
	local g = Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local zones = {}
	local oneZone = c:GetLinkedZone(tp)
	local twoZone = Duel.GetLinkedZone(tp)
	-- local z = {0x1,0x2,0x4,0x8,0x10,0x20,0x40}
	-- for _,zone in ipairs(z) do
		-- local ct = 0
		-- for tc in aux.Next(g) do
			-- if (zone and tc:GetLinkedZone(tp))~= 0 then
				-- ct = ct + 1
			-- end
		-- end
		-- zones[zone] = ct
	-- end
	-- local rzone = 0
	-- for i,ct in pairs(zones) do
		-- if ct >= count then
			-- rzone = i
		-- end
	-- end
	if oneZone == twoZone then 
	return true
	end
end
function Auxiliary.Tuner(f,a,b,c)
	return	function(target)
				return target:IsType(TYPE_TUNER) and (not f or f(target,a,b,c))
			end
end
function Auxiliary.NonTuner(f,a,b,c)
	return	function(target,scard,sumtype,tp)
				return target:IsNotTuner(scard,tp) and (not f or f(target,a,b,c))
			end
end
function Auxiliary.NonTunerEx(f,val)
	return	function(target,scard,sumtype,tp)
				return target:IsNotTuner(scard,tp) and f(target,val,scard,sumtype,tp)
			end
end
-- function Auxiliary.NonTuner(f,a,b,c)
	-- return	function(target,scard,sumtype,tp)
				-- return target:IsNotTuner(scard,tp) and (not f or f(target,a,b,c))
			-- end
-- end
-- function Auxiliary.NonTunerEx(f,val)
	-- return	function(target,scard,sumtype,tp)
				-- return target:IsNotTuner(scard,tp) and f(target,val,scard,sumtype,tp)
			-- end
-- end
-- Synchro monster, 1 tuner + n or more monsters
function Auxiliary.AddSynchroProcedure(c,f1,f2,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynCondition(f1,f2,minct,maxc)
	return	function(e,c,smat,mg)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				local ct=-ft
				local minc=minct
				if minc<ct then minc=ct end
				if maxc<minc then return false end
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
					-- return Duel.CheckTunerMaterial(c,c,f1,f2,minc,maxc,smat,mg)
				--return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
				--return Duel.CheckSynchroMaterial(c,f1,min1,max1,f2,min2,max2,smat,mg)
				--return Duel.CheckSynchroMaterial(c,f1,min1,max1,f2,min2,max2,smat,mg)
			end
end
-- function Auxiliary.SMaterialFilter()
	-- return c:IsFaceup() and c:IsCanBeSynchroMaterial() 
-- end
-- function Auxiliary.SynMaterialFilter(c,syncard)
	-- return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
-- end
-- function Auxiliary.synfilter1(c,syncard,lv,g1,g2)
	-- local f1=c.tuner_filter
		-- return g1:IsExists(Auxiliary.synfilter2,1,c,syncard,lv,g2,f1,c)
	-- end
-- function Auxiliary.synfilter2(c,syncard,lv,g2,f1,tuner1)
	-- local f2=c.tuner_filter
	-- if f1 and not f1(c) then return false end
	-- if f2 and not f2(tuner1) then return false end
	-- local mg=g2:Filter(Auxiliary.synfilter3,nil,f1,f2)
	-- Duel.SetSelectedCard(Group.FromCards(c,tuner1))
	-- return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,1,syncard)
-- end
-- function Auxiliary.synfilter3(c,f1,f2)
	-- return (not f1 or f1(c)) and (not f2 or f2(c))
-- end
function Auxiliary.SynTarget(f1,f2,minct,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg)
				local g=Group.CreateGroup()
				-- local g1=nil
	            -- local g2=nil
				-- g1=Duel.GetMatchingGroup(f1,tp,LOCATION_MZONE,nil,nil,c)
		        -- g2=Duel.GetMatchingGroup(f2 and Auxiliary.SynMaterialFilter,tp,LOCATION_MZONE,nil,nil,c)
				-- local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	            -- local lv=c:GetLevel()
				local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				local ct=-ft
				local minc=minct
				if minc<ct then minc=ct end
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
				-- local tuner1=nil
				-- local lv=c:GetLevel()
				-- local t2=Duel.SelectMatchingCard(tp,aux.Tuner(f1),tp,LOCATION_MZONE,0,1,1,lv)
				-- -- local t2=g1:FilterSelect(tp,Auxiliary.synfilter1,1,1,nil,c,lv,g1,g2)
			    -- tuner1=t2:GetFirst()
				-- -- local tc=t2:GetFirst()
				-- g:AddCard(tuner1)
				-- -- Duel.SetSelectedCard(g)
		        -- -- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				-- local lv2=tuner1:GetLevel()
				-- local mg2=g2:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		        -- local m3=mg2:SelectWithSumEqual(c:GetControler(),Card.GetSynchroLevel,lv-lv2,minc,99,tuner1)
		        -- g:Merge(m3)
				 -- t2:DeleteGroup()
			     -- m3:DeleteGroup()
			     -- g1:DeleteGroup()
			     -- g2:DeleteGroup()
				-- g=Duel.SelectTunerMaterial(c:GetControler(),c,c,smat,f1,f2,minc,maxc,mg)
				   g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
					 --g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,min1,max1,f2,min2,max2,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.SynOperation(f1,f2,minct,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
-- -- Synchro monster, 1 tuner + n or more monsters
-- function Auxiliary.AddSynchroProcedure(c,f1,f2,ct)
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_SPSUMMON_PROC)
	-- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e1:SetRange(LOCATION_EXTRA)
	-- e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
	-- e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
	-- e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
	-- e1:SetValue(SUMMON_TYPE_SYNCHRO)
	-- c:RegisterEffect(e1)
-- end
-- function Auxiliary.SynCondition(f1,f2,minct,maxc)
	-- return	function(e,c,smat,mg)
				-- if c==nil then return true end
				-- if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				-- local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				-- local ct=-ft
				-- local minc=minct
				-- if minc<ct then minc=ct end
				-- if maxc<minc then return false end
				-- if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					-- return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
					-- -- return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg)
				-- return Duel.CheckSynchroMaterial(c,f,f1,f2,minc,maxc,smat,mg)
			-- end
-- end
-- function Auxiliary.SynTarget(f1,f2,minct,maxc)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg)
				-- local g=nil
				-- local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				-- local ct=-ft
				-- local minc=minct
				-- if minc<ct then minc=ct end
				-- if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					-- g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				-- else
					-- g=Duel.SelectSynchroMaterial(c:GetControler(),c,f,f1,f2,minc,maxc,smat,mg)
				-- end
				-- if g then
					-- g:KeepAlive()
					-- e:SetLabelObject(g)
					-- return true
				-- else return false end
			-- end
-- end
-- function Auxiliary.SynOperation(f1,f2,minct,maxc)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				-- local g=e:GetLabelObject()
				-- c:SetMaterial(g)
				-- Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				-- g:DeleteGroup()
			-- end
-- end
--Synchro monster, 1 tuner + min to max monsters
-- function Auxiliary.AddSynchroProcedure(c,f1,f2,minc,maxc)
	-- if maxc==nil then maxc=99 end
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_SPSUMMON_PROC)
	-- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e1:SetRange(LOCATION_EXTRA)
	-- e1:SetCondition(Auxiliary.SynCondition(f1,f2,minc,maxc))
	-- e1:SetTarget(Auxiliary.SynTarget(f1,f2,minc,maxc))
	-- e1:SetOperation(Auxiliary.SynOperation(f1,f2,minc,maxc))
	-- e1:SetValue(SUMMON_TYPE_SYNCHRO)
	-- c:RegisterEffect(e1)
-- end
-- function Auxiliary.SynCondition(f1,f2,minc,maxc)
	-- return	function(e,c,smat,mg)
				-- if c==nil then return true end
				-- if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				-- local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				-- local ct=-ft
				-- local minc=minct
				-- if min then
					-- if min>minc then minc=min end
					-- if max<maxc then maxc=max end
					-- if minc>maxc then return false end
				-- end
				-- if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					-- return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				-- return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			-- end
-- end
-- -- function Auxiliary.SynCondition(f1,f2,minct,maxc)
	-- -- return	function(e,c,smat,mg)
				-- -- if c==nil then return true end
				-- -- if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				-- -- local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				-- -- local ct=-ft
				-- -- local minc=minct
				-- -- if minc<ct then minc=ct end
				-- -- if maxc<minc then return false end
				-- -- if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					-- -- return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				-- -- return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			-- -- end
-- -- end
-- function Auxiliary.SynTarget(f1,f2,minc,maxc)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg)
				-- local g=nil
				-- local minc=1
				-- if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					-- g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				-- else
					-- g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				-- end
				-- if g then
					-- g:KeepAlive()
					-- e:SetLabelObject(g)
					-- return true
				-- else return false end
			-- end
-- end
-- function Auxiliary.SynOperation(f1,f2,minct,maxc)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				-- local g=e:GetLabelObject()
				-- c:SetMaterial(g)
				-- Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				-- g:DeleteGroup()
			-- end
-- end
--Synchro monster, 1 tuner + 1 monster
--backward compatibility
function Auxiliary.AddSynchroProcedure2(c,f1,f2)
	Auxiliary.AddSynchroProcedure(c,f1,f2,1,1)
end
--Synchro monster, f1~f3 each 1 MONSTER + f4 min to max monsters
function Auxiliary.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(f1,f2,f3,f4,minc,maxc))
	e1:SetTarget(Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc))
	e1:SetOperation(Auxiliary.SynMixOperation(f1,f2,f3,f4,minc,maxc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynMaterialFilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function Auxiliary.SynLimitFilter(c,f,e)
	return f and not f(e,c)
end
function Auxiliary.GetSynchroLevelFlowerCardian(c)
	return 2
end
function Auxiliary.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(Auxiliary.SynMaterialFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
function Auxiliary.SynMixCondition(f1,f2,f3,f4,minc,maxc)
	return	function(e,c,smat,mg1)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg
				if mg1 then
					mg=mg1
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				return mg:IsExists(Auxiliary.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat)
			end
end
function Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
				local g=Group.CreateGroup()
				local mg
				if mg1 then
					mg=mg1
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c1=mg:FilterSelect(tp,Auxiliary.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat):GetFirst()
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c2=mg:FilterSelect(tp,Auxiliary.SynMixFilter2,1,1,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1):GetFirst()
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						local c3=mg:FilterSelect(tp,Auxiliary.SynMixFilter3,1,1,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2):GetFirst()
						g:AddCard(c3)
					end
				end
				local g4=Group.CreateGroup()
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,nil)
					end
					local cg=mg2:Filter(Auxiliary.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat)
					if cg:GetCount()==0 then break end
					local minct=1
					if Auxiliary.SynMixCheckGoal(tp,g4,minc,i,c,g,smat) then
						if not Duel.SelectYesNo(tp,210) then break end
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local tg=cg:Select(tp,minct,1,nil)
					if tg:GetCount()==0 then break end
					g4:Merge(tg)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.SynMixOperation(f1,f2,f3,f4,minct,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				if not g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and c:IsHasEffect(80896940) then
					c:RegisterFlagEffect(80896940,RESET_EVENT+0x1fe0000,0,1)
				end
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
function Auxiliary.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat)
	return (not f1 or f1(c)) and mg:IsExists(Auxiliary.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c)
end
function Auxiliary.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1)
	if f2 then
		return f2(c) and mg:IsExists(Auxiliary.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c)
	else
		return mg:IsExists(Auxiliary.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil)
	end
end
function Auxiliary.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2)
	if f3 then
		return f3(c) and mg:IsExists(Auxiliary.SynMixFilter4,1,Group.FromCards(c1,c2,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c2)
	else
		return mg:IsExists(Auxiliary.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil)
	end
end
function Auxiliary.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3)
	if f4 and not f4(c) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,nil)
	end
	return aux.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat)
end
function Auxiliary.SynMixCheck(mg,sg1,minc,maxc,syncard,smat)
	local tp=syncard:GetControler()
	for c in aux.Next(sg1) do
		mg:RemoveCard(c)
	end
	local sg=Group.CreateGroup()
	if minc==0 and Auxiliary.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat) then return true end
	if maxc==0 then return false end
	return mg:IsExists(Auxiliary.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat)
end
function Auxiliary.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
		or (ct<maxc and mg:IsExists(Auxiliary.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if smat and not g:IsContains(smat) then return false end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	if pe and not g:IsContains(pe:GetOwner()) then return false end
	if not g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and not syncard:IsHasEffect(80896940) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(Auxiliary.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he) then return false end
				if (hmin and ct<hmin) or (hmax and ct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local ct=g:GetCount()-1
			if lloc then
				local lg=g:Filter(Card.IsLocation,c,lloc)
				if lg:GetCount()~=ct then return false end
			end
			if lf and g:IsExists(Auxiliary.SynLimitFilter,1,c,lf,le) then return false end
			if (lmin and ct<lmin) or (lmax and ct>lmax) then return false end
		end
	end
	return true
end

function Auxiliary.XyzAlterFilter(c,alterf,xyzc,e,tp,op)
	return alterf(c) and c:IsCanBeXyzMaterial(xyzc) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),xyzc)>0 and (not op or op(e,tp,0,c))
end
--Xyz monster, lv k*n
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	if alterf then
		e1:SetCondition(Auxiliary.XyzCondition2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetTarget(Auxiliary.XyzTarget2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetOperation(Auxiliary.XyzOperation2(f,lv,ct,maxct,alterf,desc,op))
	else
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct))
		e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function Auxiliary.XyzMatGenerate(e,tp,eg,ep,ev,re,r,rp)
	local tck0=Duel.CreateToken(0,419)
	xyztempg0:AddCard(tck0)
	local tck1=Duel.CreateToken(1,419)
	xyztempg1:AddCard(tck1)
end
--Xyz Summon(normal)
function Auxiliary.XyzM12(c,f,lv,xyz,xg,mustbemat,tp)
	return Auxiliary.XyzMatFilter(c,f,lv,xyz,tp) or Auxiliary.XyzSubMatFilter(c,rk,xyz,xg,mustbemat)
end
function Auxiliary.XyzMatFilter(c,f,lv,xyz,tp)
	return (c:IsFaceup() or not c:IsOnField()) and (not f or f(c)) and c:IsXyzLevel(xyz,lv) and c:IsCanBeXyzMaterial(xyz) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
end
function Auxiliary.XyzSubMatFilter(c,f,lv,xyz,xg,mustbemat)
	if c:IsLocation(LOCATION_GRAVE) then
		--Graveyard Material
		return c:IsHasEffect(511002793) and (not f or f(c)) and c:IsXyzLevel(xyz,lv) and c:IsCanBeXyzMaterial(xyz)
	else
		--Solid Overlay-type OR Orichalcum Chain (minus material)
		if mustbemat then return false end
		if c:IsHasEffect(511002116) then return true end
		return c:GetFlagEffect(511000189)==lv and xg:IsExists(Auxiliary.XyzSubFilterChk,1,nil,f)
	end
end
function Auxiliary.XyzSubFilterChk(c,f)
	return (not f or f(c))
end
function Auxiliary.XyzFilterChk(c,mg,xyz,tp,minc,maxc,matg,ct,nodoub,notrip,sg,min,matct,mustbemat)
	local tg
	local g=mg:Clone()
	if matg==nil or matg:GetCount()==0 then tg=Group.CreateGroup() else tg=matg:Clone() end
	g:RemoveCard(c)
	tg:AddCard(c)
	local tsg=false
	if sg then
		tsg=sg:Clone()
		tsg:RemoveCard(c)
	end
	local gg=tg:Filter(Auxiliary.ValidXyzMaterial,nil)
	if gg:IsExists(Auxiliary.TuneMagXyzFilter,1,nil,gg,tp) then return false end
	local ctc=ct+1
	local matct2=matct
	if not c:IsHasEffect(511002116) and min then
		matct2=matct+1
	end
	if min and matct2>min then return false end
	if (not min or matct2==min) and ctc>=minc and ctc<=maxc and tg:IsExists(Auxiliary.XyzFCheck,1,nil,tp) 
		and not tg:IsExists(Auxiliary.XyzMatNumCheck,1,nil,tg:GetCount()) then return true end
	if ctc>maxc then return false end
	local res2=false
	local res3=false
	--Extra Equip Material
	local eqg=c:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
	if not sg and not mustbemat then
		g:Merge(eqg)
	end
	local isDouble=false
	--Double Material
	if not mustbemat and not nodoub and c:IsHasEffect(511001225) and (not c.xyzlimit2 or c.xyzlimit2(xyz)) then
		if ctc+1<=maxc then
			isDouble=true
			res2=true
		end
		if (not min or matct2==min) and ctc+1>=minc and ctc+1<=maxc and tg:IsExists(Auxiliary.XyzFCheck,1,nil,tp) 
			and not tg:IsExists(Auxiliary.XyzMatNumCheck,1,nil,tg:GetCount()) then return true end
	end
	--Triple Material
	if not mustbemat and not notrip and c:IsHasEffect(511003001) and (not c.xyzlimit3 or c.xyzlimit3(xyz)) then
		if ctc+2<=maxc then
			res3=true
		end
		if (not min or matct2==min) and ctc+2>=minc and ctc+2<=maxc and tg:IsExists(Auxiliary.XyzFCheck,1,nil,tp) 
			and not tg:IsExists(Auxiliary.XyzMatNumCheck,1,nil,tg:GetCount()) then return true end
	end
	return g:IsExists(Auxiliary.XyzFilterChk,1,nil,g,xyz,tp,minc,maxc,tg,ctc,false,false,tsg,min,matct2,mustbemat) 
		or (res2 and g:IsExists(Auxiliary.XyzFilterChk,1,nil,g,xyz,tp,minc,maxc,tg,ctc+1,false,false,tsg,min,matct2,mustbemat))
		or (res3 and g:IsExists(Auxiliary.XyzFilterChk,1,nil,g,xyz,tp,minc,maxc,tg,ctc+2,false,false,tsg,min,matct2,mustbemat))
end
function Auxiliary.XyzMatNumCheck(c,ct)
	return c:GetFlagEffect(91110378)>0 and c:GetFlagEffectLabel(91110378)~=ct
end
function Auxiliary.XyzFCheck(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:IsControler(tp))
end
function Auxiliary.ValidXyzMaterial(c)
	return not c:IsHasEffect(511001175) and not c:IsHasEffect(511002116)
end
function Auxiliary.TuneMagXyzFilter(c,g,tp)
	return c:IsHasEffect(73941492) and c.xyzlimitfilter and g:IsExists(Auxiliary.TuneMagFilter2,1,c,c.xyzlimitfilter,tp)
end
function Auxiliary.ExtraXyzMaterial(c,g,tp,ct,max)
	local gg=g:Filter(Auxiliary.ValidXyzMaterial,nil)
	gg:AddCard(c)
	if gg:IsExists(Auxiliary.TuneMagXyzFilter,1,nil,gg,tp) then return false end
	return ct+1<=max
end
--Xyz Summon(normal)
function Auxiliary.XyzCondition(f,lv,minc,maxc)
	--og: use special material
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local ft=Duel.GetLocationCountFromEx(tp)
				local ct=-ft
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return ct<minc and Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				--return mg:IsExists(Auxiliary.XyzFilterChk,1,nil,mg,c,tp,minc,maxc,nil,0,false,false,sg,minchk,0,mustbemat)
			end
end
function Auxiliary.XyzTarget(f,lv,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzOperation(f,lv,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(alterf)
function Auxiliary.XyzCondition2(f,lv,minc,maxc,alterf,desc,op)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local ft=Duel.GetLocationCountFromEx(tp)
				local ct=-1
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op) then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return ct<minc and Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTarget2(f,lv,minc,maxc,alterf,desc,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local ft=Duel.GetLocationCountFromEx(tp)
				local ct=-ft
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local b1=ct<minc and Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzOperation2(f,lv,minc,maxc,alterf,desc,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--above is original xyz, below is patch

function Auxiliary.AddXyzProcedureLevelFree(c,f,gf,minc,maxc,alterf,desc,op)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if alterf then
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition2(f,gf,minc,maxc,alterf,desc,op))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget2(f,gf,minc,maxc,alterf,desc,op))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation2(f,gf,minc,maxc,alterf,desc,op))
	else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f,gf,minc,maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f,gf,minc,maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f,gf,minc,maxc))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(level free)
function Auxiliary.XyzLevelFreeFilter(c,xyzc,f)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function Auxiliary.XyzLevelFreeCheck(c,tp,xyzc,mg,sg,gf,minc,maxc)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=minc and Auxiliary.XyzLevelFreeGoal(sg,tp,xyzc,gf))
		or (ct<maxc and mg:IsExists(Auxiliary.XyzLevelFreeCheck,1,sg,tp,xyzc,mg,sg,gf,minc,maxc))
	sg:RemoveCard(c)
	return res
end
function Auxiliary.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function Auxiliary.XyzLevelFreeCondition(f,gf,minct,maxct)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Group.CreateGroup()
				return maxc>=minc and mg:IsExists(Auxiliary.XyzLevelFreeCheck,1,sg,tp,c,mg,sg,gf,minc,maxc)
			end
end
function Auxiliary.XyzLevelFreeTarget(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local g=Group.CreateGroup()
				local ag=mg:Filter(Auxiliary.XyzLevelFreeCheck,g,tp,c,mg,g,gf,minc,maxc)
				local ct=g:GetCount()
				while ct<maxc and ag:GetCount()>0 do
					local minsct=1
					local finish=(ct>=minc and Auxiliary.XyzLevelFreeGoal(g,tp,c,gf))
					if finish then
						minsct=0
						if not Duel.SelectYesNo(tp,210) then break end
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tg=ag:Select(tp,minsct,1,nil)
					if tg:GetCount()==0 then break end
					g:Merge(tg)
					ct=g:GetCount()
					ag=mg:Filter(Auxiliary.XyzLevelFreeCheck,g,tp,c,mg,g,gf,minc,maxc)
				end
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeOperation(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(level free&alterf)
function Auxiliary.XyzLevelFreeCondition2(f,gf,minct,maxct,alterf,desc,op)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op) then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				local sg=Group.CreateGroup()
				return maxc>=minc and mg:IsExists(Auxiliary.XyzLevelFreeCheck,1,sg,tp,c,mg,sg,gf,minc,maxc)
			end
end
function Auxiliary.XyzLevelFreeTarget2(f,gf,minct,maxct,alterf,desc,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local g=Group.CreateGroup()
				local ag=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f):Filter(Auxiliary.XyzLevelFreeCheck,g,tp,c,mg,g,gf,minc,maxc)
				local b1=ag:GetCount()>0
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local sg=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,sg:GetFirst()) end
					g:Merge(sg)
				else
					e:SetLabel(0)
					local ct=g:GetCount()
					while ct<maxc and ag:GetCount()>0 do
						local minsct=1
						local finish=(ct>=minc and Auxiliary.XyzLevelFreeGoal(g,tp,c,gf))
						if finish then
							minsct=0
							if not Duel.SelectYesNo(tp,210) then break end
						end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
						local tg=ag:Select(tp,minsct,1,nil)
						if tg:GetCount()==0 then break end
						g:Merge(tg)
						ct=g:GetCount()
						ag=ag:Filter(Auxiliary.XyzLevelFreeCheck,g,tp,c,mg,g,gf,minc,maxc)
					end
				end
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeOperation2(f,gf,minct,maxct,alterf,desc,op)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function Auxiliary.FConditionFilterF2(c,g2)
	return g2:IsExists(aux.TRUE,1,c)
end
function Auxiliary.FConditionFilterF2c(c,f1,f2)
	return f1(c) or f2(c)
end
function Auxiliary.FConditionCheckF(c,chkf)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(chkf)
end
--material_count: number of different names in material list
--material: names in material list
--Fusion monster, mixed materials
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			table.insert(mat,val[i])
		end
	end
	if #mat>0 and c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.material_count=#mat
		mt.material=mat
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMix(insf,sub,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf end
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMix(gc,tp,mg,sg,c,sub,chkf,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMix,1,nil,tp,mg,sg,c,sub,chkf,table.unpack(funs))
			end
end
function Auxiliary.FOperationMix(insf,sub,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				while sg:GetCount()<#funs do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g=mg:FilterSelect(tp,Auxiliary.FSelectMix,1,1,sg,tp,mg,sg,c,sub,chkf,table.unpack(funs))
					sg:Merge(g)
				end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FConditionFilterMix(c,fc,sub,...)
	if not c:IsCanBeFusionMaterial(fc) then return false end
	for i,f in ipairs({...}) do
		if f(c,fc,sub) then return true end
	end
	return false
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,sub,fun2,...)
		elseif sub and fun1(c,fc,true,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,false,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,sub,mg,sg)
	end
end
function Auxiliary.FCheckTuneMagicianX(c,sg)
	return true--sg:IsExists(c.fuslimit,1,c) and  --c:IsHasEffect(EFFECT_TUNE_MAGICIAN_F) 
end
--if sg1 is subset of sg2 then not Auxiliary.FCheckAdditional(tp,sg1,fc) -> not Auxiliary.FCheckAdditional(tp,sg2,fc)
Auxiliary.FCheckAdditional=nil
function Auxiliary.FCheckMixGoal(tp,sg,fc,sub,chkf,...)
	if sg:IsExists(Auxiliary.FCheckTuneMagicianX,1,nil,sg) then return false end
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.FSelectMix(c,tp,mg,sg,fc,sub,chkf,...)
	sg:AddCard(c)
	local res
	if sg:GetCount()<#{...} then
		res=mg:IsExists(Auxiliary.FSelectMix,1,sg,tp,mg,sg,fc,sub,chkf,...)
	else
		res=Auxiliary.FCheckMixGoal(tp,sg,fc,sub,chkf,...)
	end
	sg:RemoveCard(c)
	return res
end
--Fusion monster, mixed material * minc to maxc + material + ...
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			table.insert(mat,val[i])
		end
	end
	if #mat>0 and c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.material_count=#mat
		mt.material=mat
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf end
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,fun1,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMixRep(gc,tp,mg,sg,c,sub,chkf,fun1,minc,maxc,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMixRep,1,nil,tp,mg,sg,c,sub,chkf,fun1,minc,maxc,table.unpack(funs))
			end
end
function Auxiliary.FOperationMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,fun1,table.unpack(funs))
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				while sg:GetCount()<maxc+#funs do
					local cg=mg:Filter(Auxiliary.FSelectMixRep,sg,tp,mg,sg,c,sub,chkf,fun1,minc,maxc,table.unpack(funs))
					if cg:GetCount()==0 then break end
					local minct=1
					if Auxiliary.FCheckMixRepGoal(tp,sg,c,sub,chkf,fun1,minc,maxc,table.unpack(funs)) then
						if not Duel.SelectYesNo(tp,210) then break end
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g=cg:Select(tp,minct,1,nil)
					if g:GetCount()==0 then break end
					sg:Merge(g)
				end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		return sg:IsExists(Auxiliary.FCheckMixRepFilter,1,g,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	else
		local ct1=sg:FilterCount(fun1,g,fc,sub,mg,sg)
		local ct2=sg:FilterCount(fun1,g,fc,false,mg,sg)
		return ct1==sg:GetCount()-g:GetCount() and ct1-ct2<=1
	end
end
function Auxiliary.FCheckMixRepFilter(c,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2(c,fc,sub,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun2(c,fc,false,mg,sg)
		local res=Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,...)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,chkf,fun1,minc,maxc,...)
	if sg:IsExists(Auxiliary.FCheckTuneMagicianX,1,nil,sg) then return false end
	if sg:GetCount()<minc+#{...} or sg:GetCount()>maxc+#{...} then return false end
	local g=Group.CreateGroup()
	return Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.FCheckMixRepTemplate(c,cond,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
	for i,f in ipairs({...}) do
		if f(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and f(c,fc,false,mg,sg)
			local t={...}
			table.remove(t,i)
			local res=cond(tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,table.unpack(t))
			g:RemoveCard(c)
			if res then return true end
		end
	end
	if maxc>0 then
		if fun1(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun1(c,fc,false,mg,sg)
			local res=cond(tp,mg,sg,g,fc,sub,chkf,fun1,minc-1,maxc-1,...)
			g:RemoveCard(c)
			if res then return true end
		end
	end
	return false
end
function Auxiliary.FCheckMixRepSelectedCond(tp,mg,sg,g,...)
	if g:GetCount()<sg:GetCount() then
		return sg:IsExists(Auxiliary.FCheckMixRepSelected,1,g,tp,mg,sg,g,...)
	else
		return Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,...)
	end
end
function Auxiliary.FCheckMixRepSelected(c,...)
	return Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckMixRepSelectedCond,...)
end
function Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
	if chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
		if minc<=0 and #{...}==0 then return true end
		return mg:IsExists(Auxiliary.FCheckSelectMixRepAll,1,g,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
	else
		return mg:IsExists(Auxiliary.FCheckSelectMixRepM,1,g,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
	end
end
function Auxiliary.FCheckSelectMixRepAll(c,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		if fun2(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun2(c,fc,false,mg,sg)
			local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
			g:RemoveCard(c)
			return res
		end
	elseif maxc>0 and fun1(c,fc,sub,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun1(c,fc,false,mg,sg)
		local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc-1,maxc-1)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckSelectMixRepM(c,tp,...)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckSelectMixRep,tp,...)
end
function Auxiliary.FSelectMixRep(c,tp,mg,sg,fc,sub,chkf,...)
	sg:AddCard(c)
	local res=false
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		res=false
	elseif Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,chkf,...) then
		res=true
	else
		local g=Group.CreateGroup()
		res=sg:IsExists(Auxiliary.FCheckMixRepSelected,1,nil,tp,mg,sg,g,fc,sub,chkf,...)
	end
	sg:RemoveCard(c)
	return res
end
--Fusion monster, name + name
function Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
--Fusion monster, name + name + name
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
--Fusion monster, name + name + name + name
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
--Fusion monster, name * n
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local code={}
	for i=1,cc do
		code[i]=code1
	end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.material_count=1
		mt.material={code1}
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(code))
end
--Fusion monster, name * minc to maxc
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
--Fusion monster, name + condition * n
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,table.unpack(fun))
end
--Fusion monster, condition + condition
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
--Fusion monster, condition * n
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--Fusion monster, condition * minc to maxc
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
--Fusion monster, condition1 + condition2 * n
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f2
	end
	Auxiliary.AddFusionProcMix(c,false,insf,f1,table.unpack(fun))
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
--Fusion monster, name + condition * minc to maxc
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
--Fusion monster, name + name + condition * minc to maxc
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
function Auxiliary.AddContactFusion(c,group,op,sumcon,condition,sumtype)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local t={}
	if mt.contactfus then
		t=mt.contactfus
	end
	t[c]=true
	mt.contactfus=t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if sumtype then
		e1:SetValue(sumtype)
	end
	e1:SetCondition(Auxiliary.ContactCon(group,condition))
	e1:SetTarget(Auxiliary.ContactTg(group))
	e1:SetOperation(Auxiliary.ContactOp(op))
	c:RegisterEffect(e1)
	if sumcon then
		--spsummon condition
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EFFECT_SPSUMMON_CONDITION)
		if type(sumcon)=='function' then
			e2:SetValue(sumcon)
		end
		c:RegisterEffect(e2)
	end
end
function Auxiliary.ContactCon(f,fcon)
	return function(e,c)
		if c==nil then return true end
		local m=f(e:GetHandlerPlayer())
		local chkf=c:GetControler()+0x1000
		return c:CheckFusionMaterial(m,nil,chkf) and (not fcon or fcon(e:GetHandlerPlayer()))
	end
end
function Auxiliary.ContactTg(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local m=f(tp)
		local chkf=tp+0x1000
		local sg=Duel.SelectFusionMaterial(tp,e:GetHandler(),m,nil,chkf)
		if sg:GetCount()>0 then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
function Auxiliary.ContactOp(f)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		f(g,tp,c)
		g:DeleteGroup()
	end
end
--Fusion monster, any number of name/condition * n - fixed
function Auxiliary.AddFusionProcMixN(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local t={}
	local n={}
	if #val%2~=0 then return end
	for i=1,#val do
		if i%2~=0 then
			table.insert(t,val[i])
		else
			table.insert(n,val[i])
		end
	end
	if #t~=#n then return end
	local fun={}
	for i=1,#t do
		for j=1,n[i] do
			table.insert(fun,t[i])
		end
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(fun))
end

--Procedure for Union monster equip/unequip
--c: Union monster
--f: Potential targets
--oldrule: Uses old rules
function Auxiliary.AddUnionProcedure(c,f,oldrule)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(Auxiliary.UnionTarget(f,oldrule))
	e1:SetOperation(Auxiliary.UnionOperation(f))
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(Auxiliary.UnionSumCondition)
	e2:SetTarget(Auxiliary.UnionSumTarget(oldrule))
	e2:SetOperation(Auxiliary.UnionSumOperation(oldrule))
	c:RegisterEffect(e2)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(Auxiliary.UnionReplace(oldrule))
	c:RegisterEffect(e3)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(Auxiliary.UnionLimit(f))
	c:RegisterEffect(e4)
	--auxiliary function compatibility
	if oldrule then
		local m=_G["c"..c:GetOriginalCode()]
		m.old_union=true
	end
end
function Auxiliary.UnionFilter(c,f,oldrule)
	local ct1,ct2=c:GetUnionCount()
	if c:IsFaceup() and (not f or f(c)) then
		if oldrule then
			return ct1==0
		else
			return ct2==0
		end
	else
		return false
	end
end
function Auxiliary.UnionTarget(f,oldrule)
	return function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and Auxiliary.UnionFilter(c,f,oldrule) end
		if chk==0 then return e:GetHandler():GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(Auxiliary.UnionFilter,tp,LOCATION_MZONE,0,1,c,f,oldrule) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectTarget(tp,Auxiliary.UnionFilter,tp,LOCATION_MZONE,0,1,1,c,f,oldrule)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
		c:RegisterFlagEffect(code,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function Auxiliary.UnionOperation(f)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if not tc:IsRelateToEffect(e) or (f and not f(tc)) then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		if not Duel.Equip(tp,c,tc,false) then return end
		aux.SetUnionState(c)
	end
end
function Auxiliary.UnionSumCondition()
	return function (e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetFlagEffect(11743119)==0
	end
end
function Auxiliary.UnionSumTarget(oldrule)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetCode()
		local pos=POS_FACEUP
		if oldrule then pos=POS_FACEUP_ATTACK end
		if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,pos) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		c:RegisterFlagEffect(code,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function Auxiliary.UnionSumOperation(oldrule)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local pos=POS_FACEUP
		if oldrule then pos=POS_FACEUP_ATTACK end
		if Duel.SpecialSummon(c,0,tp,tp,true,false,pos)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false,pos) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end
function Auxiliary.UnionReplace(oldrule)
	return function (e,re,r,rp)
		if oldrule then
			return bit.band(r,REASON_BATTLE)~=0
		else
			return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
		end
	end
end
function Auxiliary.UnionLimit(f)
	return function (e,c)
		return (not f or f(c)) or e:GetHandler():GetEquipTarget()==c 
	end
end
function Auxiliary.IsUnionState(effect)
	local c=effect:GetHandler()
	return c:IsHasEffect(EFFECT_UNION_STATUS)
end
function Auxiliary.SetUnionState(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNION_STATUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	if c.old_union then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_OLDUNION_STATUS)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.CheckUnionEquip(uc,tc)
	ct1,ct2=tc:GetUnionCount()
	if uc.old_union then return ct1==0
	else return ct2==0 end
end
--Ritual Summon, geq fixed lv
function Auxiliary.AddRitualProcGreater(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPGTarget(filter))
	e1:SetOperation(Auxiliary.RPGOperation(filter))
	c:RegisterEffect(e1)
end
function Auxiliary.RPGFilter(c,filter,e,tp,m,ft)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
	else
		return mg:IsExists(Auxiliary.RPGFilterF,1,nil,tp,mg,c)
	end
end
function Auxiliary.RPGFilterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetOriginalLevel(),rc)
	else return false end
end
function Auxiliary.RPGTarget(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					return ft>-1 and Duel.IsExistingMatchingCard(Auxiliary.RPGFilter,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg,ft)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function Auxiliary.RPGOperation(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPGFilter,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg,ft)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,Auxiliary.RPGFilterF,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function Auxiliary.AddRitualProcGreaterCode(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	Auxiliary.AddRitualProcGreater(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1))
end
--Ritual Summon, equal to fixed lv
function Auxiliary.AddRitualProcEqual(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPETarget(filter))
	e1:SetOperation(Auxiliary.RPEOperation(filter))
	c:RegisterEffect(e1)
end
function Auxiliary.RPEFilter(c,filter,e,tp,m,ft)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetOriginalLevel(),1,99,c)
	else
		return mg:IsExists(Auxiliary.RPEFilterF,1,nil,tp,mg,c)
	end
end
function Auxiliary.RPEFilterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetOriginalLevel(),0,99,rc)
	else return false end
end
function Auxiliary.RPETarget(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					return ft>-1 and Duel.IsExistingMatchingCard(Auxiliary.RPEFilter,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg,ft)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function Auxiliary.RPEOperation(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPEFilter,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg,ft)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),1,99,tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,Auxiliary.RPEFilterF,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),0,99,tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function Auxiliary.AddRitualProcEqualCode(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	Auxiliary.AddRitualProcEqual(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1))
end
--Ritual Summon, equal to monster lv
function Auxiliary.AddRitualProcEqual2(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPETarget2(filter))
	e1:SetOperation(Auxiliary.RPEOperation2(filter))
	c:RegisterEffect(e1)
end
function Auxiliary.RPEFilter2(c,filter,e,tp,m,ft)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return mg:IsExists(Auxiliary.RPEFilter2F,1,nil,tp,mg,c)
	end
end
function Auxiliary.RPEFilter2F(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function Auxiliary.RPETarget2(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					return ft>-1 and Duel.IsExistingMatchingCard(Auxiliary.RPEFilter2,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg,ft)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
end
function Auxiliary.RPEOperation2(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPEFilter2,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg,ft)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,Auxiliary.RPEFilter2F,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function Auxiliary.AddRitualProcEqual2Code(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1))
end
function Auxiliary.AddRitualProcEqual2Code2(c,code1,code2)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1,code2}
	end
	Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2))
end
--add procedure to Pendulum monster, also allows registeration of activation effect
function Auxiliary.EnablePendulumAttribute(c,reg)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(Auxiliary.PendCondition())
	e1:SetOperation(Auxiliary.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.PConditionFilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function Auxiliary.PendCondition()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale)
			end
end
function Auxiliary.PendOperation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp)
				local ft=Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				local loc=0
				if ft1>0 then loc=loc+LOCATION_HAND end
				if ft2>0 then loc=loc+LOCATION_EXTRA end
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale)
				else
					tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
				end
				ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
				ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				while true do
					local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
					local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					local ct=ft
					if ct1>ft1 then ct=math.min(ct,ft1) end
					if ct2>ft2 then ct=math.min(ct,ft2) end
					if ct<=0 then break end
					if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=tg:Select(tp,1,ct,nil)
					tg:Sub(g)
					sg:Merge(g)
					if g:GetCount()<ct then ft=0 break end
					ft=ft-g:GetCount()
					ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
					ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
				end
				if ft>0 then
					local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
					local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
					if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
						local ct=math.min(ft1,ft)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g=tg1:Select(tp,1,ct,nil)
						sg:Merge(g)
					end
					if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
						local ct=math.min(ft2,ft)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g=tg2:Select(tp,1,ct,nil)
						sg:Merge(g)
					end
				end
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
			end
end
--Link Summon
function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12989604,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=99 end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function Auxiliary.LConditionFilter(c,f,lc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink() 
	elseif c:IsType(TYPE_PHASM) and c:GetVigor()>1 then
		return 1+0x10000*c:GetVigor()
	else return 1 end
end
function Auxiliary.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,gf)
		or (ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,gf)
	return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
end
function Auxiliary.LinkCondition(f,minc,maxc,gf)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc,gf) and (usingsanctuary==false)
			end
end
function Auxiliary.LinkOperation(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
	
				local g=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local mg=g:Filter(Auxiliary.LConditionFilter,nil,f,c,tp)
				
				local sg=Group.CreateGroup()
				local sgcodes={}
				
				for i=0,maxc-1 do
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					if cg:GetCount()==0 then break end
					local minct=1
					if Auxiliary.LCheckGoal(tp,sg,c,minc,i,gf) then
						if not Duel.SelectYesNo(tp,210) then break end
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local g=cg:Select(tp,minct,1,nil)
					local gc=g:GetFirst()
					if c:IsType(TYPE_LINK) and c:IsSetCard(0x119) then table.insert(sgcodes,gc:GetCode()) end
					if g:GetCount()==0 then break end
					sg:Merge(g)
				end
				c:SetMaterial(sg)
				Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
				--local g2=sg:GetMaterial()
				if c:IsType(TYPE_LINK) and c:IsSetCard(0x119) and has_value(sgcodes,c:GetCode()) then c:RegisterFlagEffect(1295111,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TEMP_REMOVE,0,1) end
	  end
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

--Link Summon
-- function Auxiliary.AddSanctuaryLinkProcedure(c,f,min,max,gf)
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_SPSUMMON_PROC)
	-- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e1:SetRange(LOCATION_EXTRA)
	-- if max==nil then max=99 end
	-- e1:SetCondition(Auxiliary.LinkSancCondition(f,min,max,gf))
	-- e1:SetOperation(Auxiliary.LinkSancOperation(f,min,max,gf))
	-- e1:SetValue(SUMMON_TYPE_LINK)
	-- c:RegisterEffect(e1)
-- end
-- function Auxiliary.LinkSancCondition(f,minc,maxc,gf)
	-- return Duel.IsEnvironment(1295111) and (Duel.GetFlagEffect(tp,1295111)==0)
-- end
-- function s.lmsancfilter(c,lc,tp)
    -- return c:IsSetCard(0x119) and c:IsType(TYPE_LINK) and c:IsFaceup()
       -- and c:IsCode(c:GetID()) and c:IsCanBeLinkMaterial(lc,tp)
-- end
-- function Auxiliary.LinkSancOperation(f,minc,maxc,gf)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,c)
	
				-- local g=Duel.GetMatchingGroup(Auxiliary.lmsancfilter,tp,LOCATION_MZONE,0,nil,c,tp)
				-- --local mg=g:Filter(Auxiliary.LConditionFilter,nil,f,c,tp)
				
				-- c:SetMaterial(g)
				-- Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				-- Duel.RegisterFlagEffect(tp,1295111,RESET_PHASE+PHASE_END,0,1)
			-- end
-- end
function Auxiliary.AddSanctuaryLinkProcedure(c,min,max,code,using)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1295111,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	--usingsanctuary=false
	if max==nil then max=99 end
    e1:SetCondition(Auxiliary.LinkSancCondition(f,min,max,code))
	e1:SetOperation(Auxiliary.LinkSancOperation(f,min,max,using))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)

end
function Auxiliary.SanctuaryCheck(c,e,code)
    return c:IsCode(e:GetCode())
end
function Auxiliary.LinkSancCondition(f,minc,maxc,code)
    return	function(e,c)
	            
				if c==nil then return true end
				--if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.SanctuaryCheck,tp,LOCATION_MZONE,0,nil,c,e)
				--local sg=Group.CreateGroup()
				return Duel.IsEnvironment(1295111) and (Duel.GetFlagEffect(tp,1295111)==0) and (mg:GetCount()>0)
			end 
end
function Auxiliary.SanctuaryFunction(c,e,f,lc)
    return c:IsCode(e:GetCode())
end
function Auxiliary.LinkSancOperation(f,minc,maxc,using)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
	        local g=Duel.GetMatchingGroup(Auxiliary.SanctuaryFunction,tp,LOCATION_MZONE,0,nil,c,e,tp)
            --if Duel.IsEnvironment(1295111) and (Duel.GetFlagEffect(tp,1295111)==0) and (g:GetCount()>0) then
				
				--local mg=g:Filter(Auxiliary.LConditionFilter,nil,f,c,tp)
				local g1=g:Select(tp,1,1,nil)
				c:SetMaterial(g1)
				Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
				Duel.RegisterFlagEffect(tp,1295111,RESET_PHASE+PHASE_END,0,1)
				c:RegisterFlagEffect(1295111,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TEMP_REMOVE,0,1)
				--usingsanctuary=using
				--end
			end
end




--check for Spirit Elimination
function Auxiliary.SpElimFilter(c,mustbefaceup,includemzone)
	--includemzone - contains MZONE in original requirement
	--NOTE: Should only check LOCATION_MZONE+LOCATION_GRAVE
	if c:IsType(TYPE_MONSTER) then
		if mustbefaceup and c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
		if includemzone then return c:IsLocation(LOCATION_MZONE) or not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) end
		if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
			return c:IsLocation(LOCATION_MZONE)
		else
			return c:IsLocation(LOCATION_GRAVE)
		end
	else
		return includemzone or c:IsLocation(LOCATION_GRAVE)
	end
end

--add procedure to equip spells equipping by rule
function Auxiliary.AddEquipProcedure(c,p,f,eqlimit,cost,tg,op,con)
	--Note: p==0 is check equip spell controler, p==1 for opponent's, PLAYER_ALL for both player's monsters
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	if con then
		e1:SetCondition(con)
	end
	if cost~=nil then
		e1:SetCost(cost)
	end
	e1:SetTarget(Auxiliary.EquipTarget(tg,p,f))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if eqlimit~=nil then
		e2:SetValue(eqlimit)
	else
		e2:SetValue(Auxiliary.EquipLimit(f))
	end
	c:RegisterEffect(e2)
end
function Auxiliary.EquipLimit(f)
	return function(e,c)
				return not f or f(c,e,e:GetHandlerPlayer())
			end
end
function Auxiliary.EquipFilter(c,p,f,e,tp)
	return (p==PLAYER_ALL or c:IsControler(p)) and c:IsFaceup() and (not f or f(c,e,tp))
end
function Auxiliary.EquipTarget(tg,p,f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=nil
				if p==0 then
					player=tp
				elseif p==1 then
					player=1-tp
				elseif p==PLAYER_ALL or p==nil then
					player=PLAYER_ALL
				end
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and Auxiliary.EquipFilter(chkc,player,f,e,tp) end
				if chk==0 then return player~=nil and Duel.IsExistingTarget(Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,player,f,e,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g=Duel.SelectTarget(tp,Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,player,f,e,tp)
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst()) end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_SOLVING)
				e1:SetReset(RESET_CHAIN)
				e1:SetLabel(Duel.GetCurrentChain())
				e1:SetLabelObject(e)
				e1:SetOperation(Auxiliary.EquipEquip)
				Duel.RegisterEffect(e1,tp)
				Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
			end
end
function Auxiliary.EquipEquip(e,tp,eg,ep,ev,re,r,rp)
	if re~=e:GetLabelObject() then return end
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS):GetFirst()
	if tc and c:IsRelateToEffect(re) and tc:IsRelateToEffect(re) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function Auxiliary.EquipByEffectLimit(e,c)
	if e:GetOwner()~=c then return false end
	-- local eff={c:GetCardEffect(89785779+EFFECT_EQUIP_LIMIT)}
	-- for _,te in ipairs(eff) do
		-- if te==e:GetLabelObject() then return true end
	-- end
	return true
end
--register for "Equip to this card by its effect"
function Auxiliary.EquipByEffectAndLimitRegister(c,e,tp,tc,code,mustbefaceup)
	local up=false or mustbefaceup
	if not Duel.Equip(tp,tc,c,up) then return false end
	--Add Equip limit
	if code then
		tc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,0)
	end
	local te=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(Auxiliary.EquipByEffectLimit)
	e1:SetLabelObject(te)
	tc:RegisterEffect(e1)
	return true
end

--add procedure to persistent traps
function Auxiliary.AddPersistentProcedure(c,p,f,category,property,hint1,hint2,con,cost,tg,op,anypos)
	--Note: p==0 is check persistent trap controler, p==1 for opponent's, PLAYER_ALL for both player's monsters
	--anypos is check for face-up/any
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	if category then
		e1:SetCategory(category)
	end
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if hint1 or hint2 then
		if hint1==hint2 then
			e1:SetHintTiming(hint1)
		elseif hint1 and not hint2 then
			e1:SetHintTiming(hint1,0)
		elseif hint2 and not hint1 then
			e1:SetHintTiming(0,hint2)
		else
			e1:SetHintTiming(hint1,hint2)
		end
	end
	if property then
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+property)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if con then
		e1:SetCondition(con)
	end
	if cost then
		e1:SetCost(cost)
	end
	e1:SetTarget(Auxiliary.PersistentTarget(tg,p,f))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(Auxiliary.PersistentTgCon)
	e2:SetOperation(Auxiliary.PersistentTgOp(anypos))
	c:RegisterEffect(e2)
end
function Auxiliary.PersistentFilter(c,p,f,e,tp,tg,eg,ep,ev,re,r,rp)
	return (p==PLAYER_ALL or c:IsControler(p)) and (not f or f(c,e,tp)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,c,0))
end
function Auxiliary.PersistentTarget(tg,p,f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=nil
				if p==0 then
					player=tp
				elseif p==1 then
					player=1-tp
				elseif p==PLAYER_ALL or p==nil then
					player=PLAYER_ALL
				end
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and Auxiliary.PersistentFilter(chkc,player,f,e,tp) end
				if chk==0 then return Duel.IsExistingTarget(Auxiliary.PersistentFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,player,f,e,tp,tg,eg,ep,ev,re,r,rp)
					and player~=nil end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local g=Duel.SelectTarget(tp,Auxiliary.PersistentFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,player,f,e,tp)
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst(),1) end
			end
end
function Auxiliary.PersistentTgCon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function Auxiliary.PersistentTgOp(anypos)
	return function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
			if c:IsRelateToEffect(re) and tc and (anypos or tc:IsFaceup()) and tc:IsRelateToEffect(re) then
				c:SetCardTarget(tc)
			end
		end
end
function Auxiliary.PersistentTargetFilter(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end
--Help functions for the Salamangreats' effects
function Card.IsReincarnationSummoned(c)
	return c:GetFlagEffect(1295111)~=0
end
function Auxiliary.EnableCheckReincarnation(c)
	local m=_G["c"..1295111]
	if not m then
		m=_G["c"..c:GetCode()]
	end
	if m and not m.global_check then
		m.global_check=true
        local e1=Effect.GlobalEffect()
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_MATERIAL_CHECK)
        e1:SetValue(Auxiliary.ReincarnationCheckValue)
        local ge1=Effect.GlobalEffect()
        ge1:SetType(EFFECT_TYPE_FIELD)
        ge1:SetLabelObject(e1)
        ge1:SetTargetRange(0xff,0xff)
        ge1:SetTarget(Auxiliary.ReincarnationCheckTarget)
        Duel.RegisterEffect(ge1,0)
	end
end
function Auxiliary.ReincarnationCheckTarget(e,c)
	return c:IsType(TYPE_FUSION+TYPE_RITUAL+TYPE_LINK)
end
function Auxiliary.ReincarnationRitualFilter(c,id,tp)
	return c:IsCode(id) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function Auxiliary.ReincarnationCheckValue(e,c)
	local g=c:GetMaterial()
	local id=c:GetCode()
	local rc=false
	if c:IsType(TYPE_LINK) then
		rc=g:IsExists(Card.IsCode,1,nil,id)
	elseif c:IsType(TYPE_FUSION) then
		rc=g:IsExists(Card.IsFusionCode,1,nil,id)
	elseif c:IsType(TYPE_RITUAL) then
		rc=g:IsExists(aux.ReincarnationRitualFilter,1,nil,id,c:GetControler())
	end
	if rc then
		c:RegisterFlagEffect(1295111,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TEMP_REMOVE,0,1)
	end
end
--Filter for "If a [filter] monster is Special Summoned to a zone this card points to"
--Includes non-trivial handling of self-destructing Burning Abyss monsters
function Auxiliary.zptfilter(filter)
    return function(c,ec,tp)
        if filter and not filter(c,tp) then return false end
        if c:IsLocation(LOCATION_MZONE) then
            return ec:GetLinkedGroup():IsContains(c)
        else
            return (ec:GetLinkedZone(c:GetPreviousControler()))
        end
    end
end
--Condition for "If a [filter] monster is Special Summoned to a zone this card points to"
--Includes non-trivial handling of self-destructing Burning Abyss monsters
--Passes tp so you can check control
function Auxiliary.zptcon(filter)
    return function(e,tp,eg,ep,ev,re,r,rp)
        return eg:IsExists(Auxiliary.zptfilter(filter),1,nil,e:GetHandler(),tp)
    end
end
--used for Material Types Filter Bool (works for IsRace, IsAttribute, IsType)
function Auxiliary.FilterBoolFunctionEx(f,value)
	return	function(target,scard,sumtype,tp)
				return f(target,value,scard,sumtype,tp)
			end
end
function Auxiliary.FilterBoolFunction(f,a,b,c)
	return	function(target)
				return f(target,a,b,c)
			end
end
Auxiliary.ProcCancellable=false
function Auxiliary.IsMaterialListCode(c,code)
	if not c.material then return false end
	for i,mcode in ipairs(c.material) do
		if code==mcode then return true end
	end
	return false
end
-- function Auxiliary.IsMaterialListSetCard(c,setcode)
	-- return c.material_setcode and c.material_setcode==setcode
-- end
-- function Auxiliary.IsCodeListed(c,code)
	-- if not c.card_code_list then return false end
	-- for i,ccode in ipairs(c.card_code_list) do
		-- if code==ccode then return true end
	-- end
	-- return false
-- end
--card effect disable filter(target)
function Auxiliary.disfilter1(c)
	return c:IsFaceup() and not c:IsDisabled() and (not c:IsType(TYPE_NORMAL) or bit.band(c:GetOriginalType(),TYPE_EFFECT)~=0)
end
--condition of EVENT_BATTLE_DESTROYING
function Auxiliary.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster
function Auxiliary.bdocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
--condition of EVENT_BATTLE_DESTROYING + to_grave
function Auxiliary.bdgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster + to_grave
function Auxiliary.bdogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_TO_GRAVE + destroyed_by_opponent_from_field
function Auxiliary.dogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY) and rp~=tp
end
--condition of "except the turn this card was sent to the Graveyard"
function Auxiliary.exccon(e)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
--flag effect for spell counter
function Auxiliary.chainreg(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then
		e:GetHandler():RegisterFlagEffect(1,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end
--default filter for EFFECT_CANNOT_BE_BATTLE_TARGET
function Auxiliary.imval1(e,c)
	return not c:IsImmuneToEffect(e)
end
--filter for EFFECT_CANNOT_BE_EFFECT_TARGET + opponent
function Auxiliary.tgoval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
--filter for non-zero ATK
function Auxiliary.nzatk(c)
	return c:IsFaceup() and c:GetAttack()>0
end
--filter for non-zero DEF
function Auxiliary.nzdef(c)
	return c:IsFaceup() and c:GetDefense()>0
end
--flag effect for summon/sp_summon turn
function Auxiliary.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local code=e:GetLabel()
	while tc do
		if tc:GetOriginalCode()==code then
			tc:RegisterFlagEffect(code,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
--sp_summon condition for fusion monster
function Auxiliary.fuslimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--sp_summon condition for ritual monster
function Auxiliary.ritlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
--sp_summon condition for synchro monster
function Auxiliary.synlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
--sp_summon condition for xyz monster
function Auxiliary.xyzlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
--sp_summon condition for pendulum monster
function Auxiliary.penlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--effects inflicting damage to tp
function Auxiliary.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) then
		return true
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)
end
--filter for the immune effect of qli monsters
function Auxiliary.qlifilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
--utility entry for SelectUnselect loops
--returns bool if chk==0, returns Group if chk==1
function Auxiliary.SelectUnselectLoop(c,sg,mg,e,tp,minc,maxc,rescon)
	local res
	if sg:GetCount()>=maxc then return false end
	sg:AddCard(c)
	if sg:GetCount()<minc then
		res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	elseif sg:GetCount()<maxc then
		res=(not rescon or rescon(sg,e,tp,mg)) or mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	else
		res=(not rescon or rescon(sg,e,tp,mg))
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,cancelcon,breakcon)
	local minc=minc and minc or 1
	local maxc=maxc and maxc or 99
	if chk==0 then return g:IsExists(Auxiliary.SelectUnselectLoop,1,nil,Group.CreateGroup(),g,e,tp,minc,maxc,rescon) end
	local hintmsg=hintmsg and hintmsg or 0
	local sg=Group.CreateGroup()
	while true do
		local cancel=sg:GetCount()>=minc and (not cancelcon or cancelcon(sg,e,tp,g))
		local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,g,e,tp,minc,maxc,rescon)
		if (breakcon and breakcon(sg,e,tp,mg)) or mg:GetCount()<=0 or sg:GetCount()>=maxc then break end
		Duel.Hint(HINT_SELECTMSG,seltp,hintmsg)
		local tc=mg:SelectUnselect(sg,seltp,cancel,cancel)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
	end
	-- local sg=Duel.SelectMatchingCard(tp,g,g,g,seltp,minc,maxc,nil,e,tp)
	
	return sg
end

-- --Link Summon
-- function Auxiliary.AddLinkProcedure(c,f,min,max,special)
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_SPSUMMON_PROC)
	-- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e1:SetRange(LOCATION_EXTRA)
	-- if max==nil then max=c:GetLink() end
	-- e1:SetCondition(Auxiliary.LinkCondition(f,min,max,special))
	-- e1:SetTarget(Auxiliary.LinkTarget(f,min,max,special))
	-- e1:SetOperation(Auxiliary.LinkOperation(f,min,max,special))
	-- e1:SetValue(SUMMON_TYPE_LINK)
	-- c:RegisterEffect(e1)
-- end
-- function Auxiliary.LConditionFilter(c,f,lc)
	-- return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
-- end
-- function Auxiliary.GetLinkCount(c)
	-- if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		-- return 1+0x10000*c:GetLink()
	-- else return 1 end
-- end
-- function Auxiliary.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,f,special)
	-- sg:AddCard(c)
	-- ct=ct+1
	-- local res=Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,f,special)
		-- or (ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,f,special))
	-- sg:RemoveCard(c)
	-- ct=ct-1
	-- return res
-- end
-- function Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,f,special)
	-- return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
-- end
-- function Auxiliary.LinkCondition(f,minc,maxc,special)
	-- return	function(e,c)
				-- if c==nil then return true end
				-- if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				-- local tp=c:GetControler()
				-- local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				-- local sg=Group.CreateGroup()
				-- return mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc,f,special)
			-- end
-- end
-- function Auxiliary.LinkTarget(f,minc,maxc,special)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				-- local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				-- local sg=Group.CreateGroup()
				-- local cancel=false
				-- while sg:GetCount()<maxc do
					-- local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,sg:GetCount(),minc,maxc,f,special)
					-- if cg:GetCount()==0 then break end
					-- if sg:GetCount()>=minc and sg:GetCount()<=maxc and Auxiliary.LCheckGoal(tp,sg,c,minc,sg:GetCount(),f,special) then
						-- cancel=true 
					-- else 
						-- cancel=false
					-- end
					-- local tc=Group.SelectUnselect(cg,sg,tp,cancel,sg:GetCount()==0 or cancel,1,1)
					-- -- local tc=Group.Select(tp,sg,1,nil)
					-- -- local tc=g
					-- if not tc then break end
					-- if not sg:IsContains(tc) then
						-- sg:AddCard(tc)
					-- else
						-- sg:RemoveCard(tc)
					-- end
				-- end
				-- if sg:GetCount()>0 then
					-- sg:KeepAlive()
					-- e:SetLabelObject(sg)
					-- return true
				-- else return false end
			-- end
-- end
-- function Auxiliary.LinkOperation(f,min,max,special)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				-- local g=e:GetLabelObject()
				-- c:SetMaterial(g)
				-- Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				-- g:DeleteGroup()
			-- end
-- end


-- --Link Summon
-- function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_SPSUMMON_PROC)
	-- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e1:SetRange(LOCATION_EXTRA)
	-- if max==nil then max=99 end
	-- e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	-- e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	-- e1:SetValue(SUMMON_TYPE_LINK)
	-- c:RegisterEffect(e1)
-- end
-- function Auxiliary.LConditionFilter(c,f,lc)
	-- return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
-- end
-- function Auxiliary.GetLinkCount(c)
	-- if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		-- return 1+0x10000*c:GetLink() 
	-- elseif c:IsType(TYPE_PHASM) and c:GetVigor()>1 then
		-- return 1+0x10000*c:GetVigor()
	-- else return 1 end
-- end
-- function Auxiliary.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	-- sg:AddCard(c)
	-- ct=ct+1
	-- local res=Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,gf)
		-- or (ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf))
	-- sg:RemoveCard(c)
	-- ct=ct-1
	-- return res
-- end
-- function Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,gf)
	-- return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
-- end
-- function Auxiliary.LinkCondition(f,minc,maxc,gf)
	-- return	function(e,c)
				-- if c==nil then return true end
				-- if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				-- local tp=c:GetControler()
				-- local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				-- local sg=Group.CreateGroup()
				-- return mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc,gf)
			-- end
-- end
-- function Auxiliary.LinkOperation(f,minc,maxc,gf)
	-- return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				-- local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				-- local sg=Group.CreateGroup()
				-- local cancel=false
				-- while sg:GetCount()<maxc do
					-- local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,sg:GetCount(),minc,maxc,f,gf)
					-- if cg:GetCount()==0 then break end
					-- if sg:GetCount()>=minc and sg:GetCount()<=maxc and Auxiliary.LCheckGoal(tp,sg,c,minc,sg:GetCount(),f,gf) then
						-- cancel=true 
					-- else 
						-- cancel=false
					-- end
					-- local tc=Select(tp,minc,1,nil)
					-- if not tc then break end
					-- if not sg:IsContains(tc) then
						-- sg:AddCard(tc)
					-- else
						-- sg:RemoveCard(tc)
					-- end
				-- end
				-- if sg:GetCount()>0 then
					-- sg:KeepAlive()
					-- e:SetLabelObject(sg)
					-- return true
				-- else return false end
			-- end
				-- c:SetMaterial(sg)
				-- Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
			-- end


--start of synchro shit

--Special Summon limit for the Evil HEROes
function Auxiliary.EvilHeroLimit(e,se,sp,st)
	local chk=SUMMON_TYPE_FUSION+0x10
	local can=false
	if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),72043279) then
		chk=SUMMON_TYPE_FUSION
		can=true
	end
	return can or st==chk
end

--Shortcut for functions that also check whether a card is face-up
function Auxiliary.FilterFaceupFunction(f,...)
	local params={...}
	return 	function(target)
				return target:IsFaceup() and f(target,table.unpack(params))
			end
end

--sp_summon condition for gladiator beast monsters
function Auxiliary.gbspcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+100) and st<(SUMMON_TYPE_SPECIAL+150)
end
--sp_summon condition for evolsaur monsters
function Auxiliary.evospcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+150) and st<(SUMMON_TYPE_SPECIAL+180)
end
--filter for necro_valley test
function Auxiliary.NecroValleyFilter(f)
	return	function(target,...)
				return f(target,...) and not (target:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0))
			end
end
--shortcut for self-banish costs
function Auxiliary.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

--add a anounce digit by digit
function Auxiliary.ComposeNumberDigitByDigit(tp,min,max)
	if min>max then min,max=max,min end
	local mindc=#tostring(min)
	local maxdc=#tostring(max)
	local dbdmin={}
	local dbdmax={}
	local mi=maxdc-1
	local aux=min
	for i=1,maxdc do
		dbdmin[i]=math.floor(aux/(10^mi))
		aux=aux%(10^mi)
		mi=mi-1
	end
	aux=max
	mi=maxdc-1
	for i=1,maxdc do
		dbdmax[i]=math.floor(aux/(10^mi))
		aux=aux%(10^mi)
		mi=mi-1
	end
	local chku=true
	local chkl=true
	local dbd={}
	mi=maxdc-1
	for i=1,maxdc do
		local maxval=9
		local minval=0
		if chku and i>1 and dbd[i-1]<dbdmax[i-1] then
			chku=false
		end
		if chkl and i>1 and dbd[i-1]>dbdmin[i-1] then
			chkl=false
		end
		if chku then
			maxval=dbdmax[i]
		end
		if chkl then
			minval=dbdmin[i]
		end
		local r={}
		local j=1
		for k=minval,maxval do
			r[j]=k
			j=j+1
		end
		dbd[i]=Duel.AnnounceNumber(tp,table.unpack(r))
		mi=mi-1
	end
	local number=0
	mi=maxdc-1
	for i=1,maxdc do
		number=number+dbd[i]*10^mi
		mi=mi-1
	end
	return number
end
function Auxiliary.ResetEffects(g,eff)
	for c in aux.Next(g) do
		local effs={c:GetCardEffect(eff)}
		for _,v in ipairs(effs) do
			v:Reset()
		end
	end
end
function Auxiliary.LinkMarkerLeft(c)
	return c:GetDefense()==40
end

--check for free Zone for monsters to be Special Summoned except from Extra Deck
function Auxiliary.MZFilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp)
end
--check for Free Monster Zones
function Auxiliary.ChkfMMZ(sumcount)
	return	function(sg,e,tp,mg)
				return sg:FilterCount(Auxiliary.MZFilter,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=sumcount
			end
end

function GetID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local scard=_G[str]
    local s_id=tonumber(string.sub(str,2))
    return scard,s_id
end

function Auxiliary.GetMustBeMaterialGroup(tp,eg,sump,sc,g,r)
	--- eg all default materials, g - valid materials
	local eff={Duel.GetPlayerEffect(tp,EFFECT_MUST_BE_MATERIAL)}
	local sg=Group.CreateGroup()
	for _,te in ipairs(eff) do
		if te:GetCode()==EFFECT_MUST_BE_MATERIAL then
			local val=type(te:GetValue())=='function' and te:GetValue()(te,eg,sump,sc,g) or te:GetValue()
			if val and r>0 then
				sg:AddCard(te:GetHandler())
			end
		end
	end
	return sg
end

function Auxiliary.GetExtraMaterials(tp,mustg,sc,summon_type)
	local tg=Group.CreateGroup()
	mustg = mustg or Group.CreateGroup()
	local eff={Duel.GetPlayerEffect(tp,EFFECT_EXTRA_MATERIAL)}
	local t={}
	for _,te in ipairs(eff) do
		if te:GetCode()==EFFECT_EXTRA_MATERIAL then
			local eg=te:GetValue()(0,summon_type,te,tp,sc)-mustg
			eg:KeepAlive()
			tg=tg+eg
			local efun=te:GetOperation() and te:GetOperation() or aux.TRUE
			table.insert(t,{eg,efun,te})
		end
	end
	return t,tg
end

--Link Summon For Code Talkers
function Auxiliary.AddLinkProcedureCT(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=99 end
	e1:SetCondition(Auxiliary.LinkConditionCT(f,min,max,gf))
	e1:SetOperation(Auxiliary.LinkOperationCT(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function Auxiliary.LinkConditionCT(f,minc,maxc,gf)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg1=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local sg=Group.CreateGroup()
				if Duel.IsExistingMatchingCard(Auxiliary.Codecon,tp,LOCATION_MZONE,0,1,nil,mg1,sg) and sg:GetCount()<2 then 
				if codeGenerator ~= 30114823 then 
				local tg1=Duel.GetMatchingGroup(Auxiliary.CodeGeneratorMaterial,tp,LOCATION_HAND,0,nil,f,c)
				if(tg1:GetCount()>0) then 
				local tc1=tg1:GetFirst()
				mg1:AddCard(tc1)
				     end
				  end
				if microCoder ~= 2347477 then 
				local tg2=Duel.GetMatchingGroup(Auxiliary.MicroCoderMaterial,tp,LOCATION_HAND,0,nil,f,c)
				if(tg2:GetCount()>0) then 
				local tc2=tg2:GetFirst()
				mg1:AddCard(tc2)
				    end
				 end
				if codeRadiator ~= 75130221 then 
				local tg3=Duel.GetMatchingGroup(Auxiliary.CodeRadiatorMaterial,tp,LOCATION_HAND,0,nil,f,c)
				if(tg3:GetCount()>0) then 
				local tc3=tg3:GetFirst()
				mg1:AddCard(tc3)
				   end
				  end
				 end
				return mg1:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg1,c,0,minc,maxc,gf)
			end
end
function Auxiliary.CodeExtraMaterial(c,f,lc)
	return c:IsCode(30114823) and c:IsCode(2347477) and c:IsCode(75130221)
end
function Auxiliary.CodeGeneratorMaterial(c,f,lc)
	if codeGenerator ~= 30114823 then return c:IsCode(30114823) and c:IsCanBeLinkMaterial(lc) and (not f or f(c)) end
end
function Auxiliary.MicroCoderMaterial(c,f,lc)
	if microCoder ~= 2347477 then return c:IsCode(2347477) and c:IsCanBeLinkMaterial(lc) and (not f or f(c)) end
end
function Auxiliary.CodeRadiatorMaterial(c,f,lc)
	if codeRadiator ~= 75130221 then return c:IsCode(75130221) and c:IsCanBeLinkMaterial(lc) and (not f or f(c)) end
end
function Auxiliary.CodeMaterialOnField(c,f,lc)
    if c:IsCode(30114823) and c:IsLocation(LOCATION_MZONE) then return true end
	if c:IsCode(2347477) and c:IsLocation(LOCATION_MZONE) then return true end
	if c:IsCode(75130221) and c:IsLocation(LOCATION_MZONE) then return true end
end
function Auxiliary.ResetCodeMaterial(c,f,lc)
    codeGenerator = 0
	microCoder = 0
	codeRadiator = 0
end
function Auxiliary.Codecon(c,e,tp,sg,mg)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function Auxiliary.Codeone(c,e,tp,sg,mg)
	return c:IsCode(30114823)
end
function Auxiliary.Codetwo(c,e,tp,sg,mg)
	return c:IsCode(2347477)
end
function Auxiliary.Codethree(c,e,tp,sg,mg)
	return c:IsCode(75130221)
end
function Auxiliary.LCodeCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:AddCard(c)
	ct=ct+1
	local res=(ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.LinkOperationCT(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)

				local g=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local mg=g:Filter(Auxiliary.LConditionFilter,nil,f,c,tp)
				local tg1=Duel.GetMatchingGroup(Auxiliary.CodeGeneratorMaterial,tp,LOCATION_HAND,0,nil,f,c)
				local tg2=Duel.GetMatchingGroup(Auxiliary.MicroCoderMaterial,tp,LOCATION_HAND,0,nil,f,c)
				local tg3=Duel.GetMatchingGroup(Auxiliary.CodeRadiatorMaterial,tp,LOCATION_HAND,0,nil,f,c)
				
				local sg=Group.CreateGroup()
				-- mg:Merge(tg1)
				-- mg:Merge(tg2)
				-- mg:Merge(tg3)
				mzoneMonster = 0
				
				for i=0,maxc-1 do
				    local cg=nil
				    if (mzoneMonster ~= 1) then cg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c) end
					if (mzoneMonster == 1) then 
					
					mg:Remove(Card.IsCode,nil,30114823)
					mg:Remove(Card.IsCode,nil,2347477)
					mg:Remove(Card.IsCode,nil,75130221)
					
					mg:Merge(tg1)
				    mg:Merge(tg2)
				    mg:Merge(tg3)
					
					cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf) 
					if Duel.IsExistingMatchingCard(Auxiliary.Codecon,tp,LOCATION_MZONE,0,1,nil,mg,sg) and sg:GetCount()<2 and (mzoneMonster == 1) then 
					if(codeGenerator ~= 30114823) and Duel.IsExistingMatchingCard(Auxiliary.Codeone,tp,LOCATION_HAND,0,1,nil,mg,sg) then 
					local cg2=tg1:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					cg:Merge(cg2)
					  end
					if(microCoder ~= 2347477) and Duel.IsExistingMatchingCard(Auxiliary.Codetwo,tp,LOCATION_HAND,0,1,nil,mg,sg) then
					local cg3=tg2:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					cg:Merge(cg3)
					  end
					if (codeRadiator ~= 75130221) and Duel.IsExistingMatchingCard(Auxiliary.Codethree,tp,LOCATION_HAND,0,1,nil,mg,sg) then 
					local cg4=tg3:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					cg:Merge(cg4)
					  end
				    end
				end
					-- if (maxc > 1) and (mzoneMonster ~= 1) then 
					-- cg:Remove(Card.IsCode,nil,30114823) 
					-- cg:Remove(Card.IsCode,nil,2347477) 
					-- cg:Remove(Card.IsCode,nil,75130221) 
					-- end
					-- cg:Merge(cg2)
					
					-- cg2:Merge(cg3)
					
					-- cg2:Merge(cg4)
					-- cg:Merge(cg2)
					-- if Duel.IsExistingMatchingCard(Auxiliary.Codecon,tp,LOCATION_MZONE,0,1,nil,mg,sg) then 
					-- if(codeGenerator ~= 30114823) then 
					-- local cg2=tg1:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					-- cg:Merge(cg2)
					  -- end
					-- if(microCoder ~= 2347477) then
					-- local cg3=tg2:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					-- cg:Merge(cg3)
					  -- end
					-- if (codeRadiator ~= 75130221) then 
					-- local cg4=tg3:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					-- cg:Merge(cg4)
					  -- end
				    -- end
					if cg:GetCount()==0 then break end
					local minct=1
					if Auxiliary.LCheckGoal(tp,sg,c,minc,i,gf) then
						if not Duel.SelectYesNo(tp,210) then break end
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local g=cg:Select(tp,minct,1,nil)
					local tc=g:GetFirst()
					if tc:IsLocation(LOCATION_MZONE) then 
					 mzoneMonster = 1
				  end
					if tc:IsCode(30114823) and tc:IsLocation(LOCATION_HAND) then 
					 tg1:Remove(Card.IsCode,nil,tc:GetCode()) 	
					 -- if(mzoneMonster == 0) and (maxc == 2) then tg2:Remove(Card.IsCode,nil,2347477) tg3:Remove(Card.IsCode,nil,75130221) end
                     codeGenerator = 30114823
					 -- local e2=Effect.CreateEffect(tc)
	                 -- e2:SetDescription(aux.Stringid(30114823,0))
	                 -- e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	                 -- e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
					 -- e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	                 -- e2:SetCode(EVENT_PHASE+PHASE_END)
	                 -- e2:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_SZONE)
	                 -- e2:SetCountLimit(1)
	                 -- e2:SetOperation(Auxiliary.ResetCodeMaterial)
	                 -- tc:RegisterEffect(e2)
					 if Auxiliary.CodeMaterialOnField(tc) then 
					 local tgx=Duel.GetMatchingGroup(Auxiliary.CodeExtraMaterial,tp,LOCATION_MZONE,0,nil,f,c)
					 local cg3=tgx:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					 cg:Merge(cg3)
					 end
				   end
				   if tc:IsCode(2347477) and tc:IsLocation(LOCATION_HAND) then 
					 tg2:Remove(Card.IsCode,nil,tc:GetCode()) 	
					 -- if(mzoneMonster == 0) and (maxc == 2) then tg1:Remove(Card.IsCode,nil,30114823) tg3:Remove(Card.IsCode,nil,75130221) end
                     microCoder = 2347477
					 -- local e2=Effect.CreateEffect(tc)
	                 -- e2:SetDescription(aux.Stringid(2347477,0))
	                 -- e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	                 -- e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
					 -- e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	                 -- e2:SetCode(EVENT_PHASE+PHASE_END)
	                 -- e2:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_SZONE)
	                 -- e2:SetCountLimit(1)
	                 -- e2:SetOperation(Auxiliary.ResetCodeMaterial)
	                 -- tc:RegisterEffect(e2)
					 if Auxiliary.CodeMaterialOnField(tc) then 
					 local tgx=Duel.GetMatchingGroup(Auxiliary.CodeExtraMaterial,tp,LOCATION_MZONE,0,nil,f,c)
					 local cg3=tgx:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					 cg:Merge(cg3)
					 end
				   end
				   if tc:IsCode(75130221) and tc:IsLocation(LOCATION_HAND) then 
					 tg3:Remove(Card.IsCode,nil,tc:GetCode()) 	
					 -- if(mzoneMonster == 0) and (maxc == 2) then tg1:Remove(Card.IsCode,nil,30114823) tg2:Remove(Card.IsCode,nil,2347477) end
                     codeRadiator = 75130221
					 -- local e2=Effect.CreateEffect(tc)
	                 -- e2:SetDescription(aux.Stringid(75130221,0))
	                 -- e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	                 -- e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
					 -- e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	                 -- e2:SetCode(EVENT_PHASE+PHASE_END)
	                 -- e2:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_SZONE)
	                 -- e2:SetCountLimit(1)
	                 -- e2:SetOperation(Auxiliary.ResetCodeMaterial)
	                 -- tc:RegisterEffect(e2)
					 if Auxiliary.CodeMaterialOnField(tc) then 
					 local tgx=Duel.GetMatchingGroup(Auxiliary.CodeExtraMaterial,tp,LOCATION_MZONE,0,nil,f,c)
					 local cg3=tgx:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					 cg:Merge(cg3)
					 end
				   end
					if g:GetCount()==0 then break end
					sg:Merge(g)
				end
				c:SetMaterial(sg)
				mzoneMonster = 0
				Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
				
			end
end

--check for Eyes Restrict equip limit
function Auxiliary.AddEREquipLimit(c,con,equipval,equipop,linkedeff,prop,resetflag,resetcount)
	local finalprop=EFFECT_FLAG_CANNOT_DISABLE
	-- if prop~=nil then
		-- finalprop=finalprop
	-- end
	local e1=Effect.CreateEffect(c)
	if con then
		e1:SetCondition(con)
	end
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(finalprop)
	e1:SetCode(89785779)
	e1:SetLabelObject(linkedeff)
	if resetflag and resetcount then
		e1:SetReset(resetflag,resetcount)
	elseif resetflag then
		e1:SetReset(resetflag)
	end
	e1:SetValue(function(ec,c,tp) return equipval(ec,c,tp) end)
	e1:SetOperation(function(c,e,tp,tc) equipop(c,e,tp,tc) end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(finalprop)
	e2:SetCode(89785779+EFFECT_EQUIP_LIMIT)
	if resetflag and resetcount then
		e2:SetReset(resetflag,resetcount)
	elseif resetflag then
		e2:SetReset(resetflag)
	end
	c:RegisterEffect(e2)
	linkedeff:SetLabelObject(e2)
end

--Checks for cards with different names (to be used with Aux.SelectUnselectGroup)
function Auxiliary.dncheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==sg:GetCount()
end

function Auxiliary.EquipByEffectLimit(e,c)
	if e:GetOwner()~=c then return false end
	local eff={c:GetCardEffect(89785779+EFFECT_EQUIP_LIMIT)}
	for _,te in ipairs(eff) do
		if te==e:GetLabelObject() then return true end
	end
	return false
end
--register for "Equip to this card by its effect"
function Auxiliary.EquipByEffectAndLimitRegister(c,e,tp,tc,code,mustbefaceup)
	local up=false or mustbefaceup
	if not Duel.Equip(tp,tc,c,up) then return false end
	--Add Equip limit
	if code then
		tc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,0)
	end
	local te=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(Auxiliary.EquipByEffectLimit)
	e1:SetLabelObject(te)
	tc:RegisterEffect(e1)
	return true
end

function Auxiliary.HakaiExFilter(c,lr)
   return c:IsType(TYPE_LINK)  and c:IsAttribute(ATTRIBUTE_DARK) and (c:GetLink()<=(lr + 1))
end

function Auxiliary.HakaiMatfilter(c)
   return c:IsFaceup()
end

function Auxiliary.HakaiTarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local oc=e:GetHandler()
    local mg=Duel.GetMatchingGroup(Auxiliary.HakaiMatfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	mg:AddCard(oc)
	local lr=1
	if chk==0 then return Duel.IsExistingMatchingCard(Auxiliary.HakaiExFilter,tp,LOCATION_EXTRA,0,1,nil,lr) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function Auxiliary.HakaiOperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local oc=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Auxiliary.HakaiMatfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	local tc1=Duel.SelectTarget(tp,Auxiliary.HakaiMatfilter,tp,0,LOCATION_MZONE,1,1,nil)
	mg:AddCard(oc)
	local fg=Group.CreateGroup()
	fg:AddCard(oc)
	fg:AddCard(tc1:GetFirst())
	local lr=1
	if oc:IsType(TYPE_LINK) then lr=oc:GetLink() end
	local lr2=0
	if tc1:GetFirst():IsType(TYPE_LINK) then lr2=tc1:GetFirst():GetLink() lr=(lr+lr2) end
	local g=Duel.SelectMatchingCard(tp,Auxiliary.HakaiExFilter,tp,LOCATION_EXTRA,0,1,1,nil,lr)
	local tc=g:GetFirst()
	if tc then
	    Duel.SendtoGrave(fg,REASON_MATERIAL+REASON_RULE)
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

-- function Auxiliary.HopFilter(c,hc)
   -- local mg=Group.FromCards(c,hc)
   -- return c:IsFaceup() and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK) and and not c:IsType(TYPE_TUNER)
   -- and  Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
-- end

-- function Auxiliary.HopEaredSquadCond(e,tp,eg,ep,ev,re,r,rp)
	-- local c=e:GetHandler()
	-- return Duel.IsExistingTarget(s.HopFilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
-- end

function loadutility(file)
	local f1 = loadfile("expansions/live2017mr4/script/"..file)
	local f2 = loadfile("expansions/script/"..file)
	if(f1 == nil and f2== nil) then
		dofile("script/"..file)
	elseif(f1 == nil) then
		f2()
	else
		f1()
	end
end
