Auxiliary={}
aux=Auxiliary
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE
RACE_CYBERSE=RACE_CYVERSE

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
function Auxiliary.TargetEqualFunction(f,value,a,b,c)
	return	function(effect,target)
				return f(target,a,b,c)==value
			end
end
function Auxiliary.TargetBoolFunction(f,a,b,c)
	return	function(effect,target)
				return f(target,a,b,c)
			end
end
function Auxiliary.FilterEqualFunction(f,value,a,b,c)
	return	function(target)
				return f(target,a,b,c)==value
			end
end
function Auxiliary.FilterBoolFunction(f,a,b,c)
	return	function(target)
				return f(target,a,b,c)
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
--Synchro monster, m-n tuners + m-n monsters
function Auxiliary.AddSynchroProcedure(c,...)
	--parameters (f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm)
	if c.synchro_type==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.synchro_type=1
		mt.synchro_parameters={...}
		if type(mt.synchro_parameters[2])=='function' then
			Debug.Message("Old Synchro Procedure detected in c"..code..".lua")
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1063)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynCondition(...))
	e1:SetTarget(Auxiliary.SynTarget(...))
	e1:SetOperation(Auxiliary.SynOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynchroCheckFilterChk(c,f1,f2,sub1,sub2,sc,tp)
	local te=c:GetCardEffect(EFFECT_SYNCHRO_CHECK)
	if not te then return false end
	local f=te:GetValue()
	local reset=false
	if f(te,c) then
		reset=true
	end
	local res=(c:IsType(TYPE_TUNER,sc,SUMMON_TYPE_SYNCHRO,tp) and (not f1 or f1(c,sc,SUMMON_TYPE_SYNCHRO,tp))) or not f2 or f2(c,sc,SUMMON_TYPE_SYNCHRO,tp) or (sub1 and sub1(c,sc,SUMMON_TYPE_SYNCHRO,tp)) or (sub2 and sub2(c,sc,SUMMON_TYPE_SYNCHRO,tp))
	if reset then
		Duel.AssumeReset()
	end
	return res
end
function Auxiliary.TunerFilter(c,f1,sub1,sc,tp)
	return (c:IsType(TYPE_TUNER,sc,SUMMON_TYPE_SYNCHRO,tp) and (not f1 or f1(c,sc,SUMMON_TYPE_SYNCHRO,tp))) or (sub1 and sub1(c,sc,SUMMON_TYPE_SYNCHRO,tp))
end
function Auxiliary.NonTunerFilter(c,f2,sub2,sc,tp)
	return not f2 or f2(c,sc,SUMMON_TYPE_SYNCHRO,tp) or (sub2 and sub2(c,sc,SUMMON_TYPE_SYNCHRO,tp))
end
function Auxiliary.SynCondition(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm)
	return	function(e,c,smat,mg)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local dg
				local lv=c:GetLevel()
				local g
				local mgchk
				if mg then
					dg=mg
					g=mg:Filter(Card.IsCanBeSynchroMaterial,c,c)
					mgchk=true
				else
					dg=Duel.GetMatchingGroup(function(mc) return mc:IsFaceup() and (mc:IsControler(tp) or mc:IsCanBeSynchroMaterial(c)) end,tp,LOCATION_MZONE,LOCATION_MZONE,c)
					g=dg:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=false
				end
				local pg=Auxiliary.GetMustBeMaterialGroup(tp,dg,tp,c,g,REASON_SYNCHRO)
				if not g:Includes(pg) or pg:IsExists(aux.NOT(Card.IsCanBeSynchroMaterial),1,nil,c) then return false end
				if smat then
					if smat.KeepAlive then
						if smat:IsExists(aux.NOT(Card.IsCanBeSynchroMaterial),1,nil,c) then return false end
						pg:Merge(smat)
						g:Merge(smat)
					else
						if not smat:IsCanBeSynchroMaterial(c) then return false end
						pg:AddCard(smat)
						g:AddCard(smat)
					end
				end
				if g:IsExists(Auxiliary.SynchroCheckFilterChk,1,nil,f1,f2,sub1,sub2,c,tp) then
					--if there is a monster with EFFECT_SYNCHRO_CHECK (Genomix Fighter/Mono Synchron)
					local g2=g:Clone()
					if not mgchk then
						local thg=g2:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
						local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
						for thc in aux.Next(thg) do
							local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
							local val=te:GetValue()
							local ag=hg:Filter(function(mc) return val(te,mc,c) end,nil) --tuner
							g2:Merge(ag)
						end
					end
					local res=g2:IsExists(Auxiliary.SynchroCheckP31,1,nil,g2,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
					local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					aux.ResetEffects(hg,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					Duel.AssumeReset()
					return res
				else
					--no race change
					local tg
					local ntg
					if mgchk then
						tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1,c,tp)
						ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2,c,tp)
					else
						tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1,c,tp)
						ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2,c,tp)
						local thg=tg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
						thg:Merge(ntg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO))
						local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
						for thc in aux.Next(thg) do
							local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
							local val=te:GetValue()
							local thag=hg:Filter(function(mc) return Auxiliary.TunerFilter(mc,f1,sub1,c,tp) and val(te,mc,c) end,nil) --tuner
							local nthag=hg:Filter(function(mc) return Auxiliary.NonTunerFilter(mc,f2,sub2,c,tp) and val(te,mc,c) end,nil) --non-tuner
							tg:Merge(thag)
							ntg:Merge(nthag)
						end
					end
					local lv=c:GetLevel()
					local res=tg:IsExists(Auxiliary.SynchroCheckP41,1,nil,tg,ntg,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
					local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					aux.ResetEffects(hg,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					return res
				end
				return false
			end
end
function Auxiliary.SynchroCheckP31(c,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
		local teg={c:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
		for i=1,#teg do
			local te=teg[i]
			local val=te:GetValue()
			local tg=g:Filter(function(mc) return val(te,mc) end,nil)
			rg=tg:Filter(function(mc) return not Auxiliary.TunerFilter(mc,f1,sub1,sc,tp) and not Auxiliary.NonTunerFilter(mc,f2,sub2,sc,tp) end,nil)
		end
	end
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg1=g:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg1)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
		end
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i=1,#teg do
				local te=teg[i]
				local tgchk=te:GetTarget()
				local res,trg,ntrg2=tgchk(te,c,sg,g,g,tsg,ntsg)
				--if not res then return false end
				if res then
					rg:Merge(trg)
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		for tc in aux.Next(g2) do
			local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for _,te in ipairs(eff) do
				if te:GetTarget()(te,nil,sg,g,g,tsg,ntsg) then
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
	end
	g:Sub(rg)
	tsg:AddCard(c)
	sg:AddCard(c)
	if tsg:GetCount()<min1 then
		res=g:IsExists(Auxiliary.SynchroCheckP31,1,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	elseif tsg:GetCount()<max1 then
		res=g:IsExists(Auxiliary.SynchroCheckP31,1,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,pg,mgchk) 
			or (tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1,sc,tp) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) 
				and g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk))
	else
		res=tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1,sc,tp) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) 
			and g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	end
	g:Merge(rg)
	tsg:RemoveCard(c)
	sg:RemoveCard(c)
	if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
		Duel.AssumeReset()
	end
	return res
end
function Auxiliary.SynchroCheckP32(c,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
		local teg={c:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
		for i=1,#teg do
			local te=teg[i]
			local val=te:GetValue()
			local tg=g:Filter(function(mc) return val(te,mc) end,nil)
			rg=tg:Filter(function(mc) return not Auxiliary.NonTunerFilter(mc,f2,sub2,sc,tp) end,nil)
		end
	end
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg2=g:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg2)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
		end
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i=1,#teg do
				local te=teg[i]
				local tgchk=te:GetTarget()
				local res,trg2,ntrg2=tgchk(te,c,sg,Group.CreateGroup(),g,tsg,ntsg)
				--if not res then return false end
				if res then
					rg:Merge(ntrg2)
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		for tc in aux.Next(g2) do
			local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for _,te in ipairs(eff) do
				if te:GetTarget()(te,nil,sg,Group.CreateGroup(),g,tsg,ntsg) then
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
	end
	g:Sub(rg)
	ntsg:AddCard(c)
	sg:AddCard(c)
	if ntsg:GetCount()<min2 then
		res=g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	elseif ntsg:GetCount()<max2 then
		res=g:IsExists(Auxiliary.SynchroCheckP32,1,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk) 
			or ((not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
				and ntsg:IsExists(Auxiliary.NonTunerFilter,ntsg:GetCount(),nil,f2,sub2,sc,tp) 
				and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp))
	else
		res=(not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
			and ntsg:IsExists(Auxiliary.NonTunerFilter,ntsg:GetCount(),nil,f2,sub2,sc,tp)
			and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp)
	end
	g:Merge(rg)
	ntsg:RemoveCard(c)
	sg:RemoveCard(c)
	if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
		Duel.AssumeReset()
	end
	return res
end
function Auxiliary.SynchroCheckP41(c,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	local res
	local trg=Group.CreateGroup()
	local ntrg=Group.CreateGroup()
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg1=tg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			local sg2=ntg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			trg:Merge(sg1)
			ntrg:Merge(sg2)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
		end
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for _,te in ipairs(teg) do
				local tgchk=te:GetTarget()
				local res,trg2,ntrg2=tgchk(te,c,sg,tg,ntg,tsg,ntsg)
				--if not res then return false end
				if res then
					trg:Merge(trg2)
					ntrg:Merge(ntrg2)
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for _,te in ipairs(eff) do
				if te:GetTarget()(te,nil,sg,tg,ntg,tsg,ntsg) then
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
	end
	tg:Sub(trg)
	ntg:Sub(ntrg)
	tsg:AddCard(c)
	sg:AddCard(c)
	if tsg:GetCount()<min1 then
		res=tg:IsExists(Auxiliary.SynchroCheckP41,1,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	elseif tsg:GetCount()<max1 then
		res=tg:IsExists(Auxiliary.SynchroCheckP41,1,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,sc,tp,pg,mgchk) 
			or ((not req1 or tsg:IsExists(req1,reqct1,nil,tp)) and ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk))
	else
		res=(not req1 or tsg:IsExists(req1,reqct1,nil,tp)) 
			and ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	end
	tg:Merge(trg)
	ntg:Merge(ntrg)
	tsg:RemoveCard(c)
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SynchroCheckP42(c,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	local res
	local ntrg=Group.CreateGroup()
	--c has the synchro limit
	if c:IsHasEffect(73941492+TYPE_SYNCHRO) then
		local eff={c:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then return false end
			local sg2=ntg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			ntrg:Merge(sg2)
		end
	end
	--A card in the selected group has the synchro lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_SYNCHRO)
	for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(73941492+TYPE_SYNCHRO)}
		for _,f in ipairs(eff) do
			if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then return false end
		end
	end
	if not mgchk then
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for i=1,#teg do
				local te=teg[i]
				local tgchk=te:GetTarget()
				local res,trg2,ntrg2=tgchk(te,c,sg,Group.CreateGroup(),ntg,tsg,ntsg)
				--if not res then return false end
				if res then
					ntrg:Merge(ntrg2)
					hanchk=true
					break
				end
				if not hanchk then return false end
			end
		end
		g2=sg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		for tc in aux.Next(g2) do
			local eff={tc:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for _,te in ipairs(eff) do
				if te:GetTarget()(te,nil,sg,Group.CreateGroup(),ntg,tsg,ntsg) then
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
	end
	ntg:Sub(ntrg)
	ntsg:AddCard(c)
	sg:AddCard(c)
	if ntsg:GetCount()<min2 then
		res=ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk)
	elseif ntsg:GetCount()<max2 then
		res=ntg:IsExists(Auxiliary.SynchroCheckP42,1,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,sc,tp,pg,mgchk) 
			or ((not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
				and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp))
	else
		res=(not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
			and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp)
	end
	ntg:Merge(ntrg)
	ntsg:RemoveCard(c)
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SynchroCheckLabel(c,label)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:GetCardEffect(EFFECT_HAND_SYNCHRO):GetLabel()==label
end
function Auxiliary.SynchroCheckHand(c,sg)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for _,te in ipairs(teg) do
		if sg:IsExists(Auxiliary.SynchroCheckLabel,1,c,te:GetLabel()) then return false end
	end
	return true
end
function Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,sc,tp)
	if sg:IsExists(Auxiliary.SynchroCheckHand,1,nil,sg) then return false end
	--[[for c in aux.Next(sg) do
		if c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then
			local teg={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
			local hanchk=false
			for _,te in ipairs(teg) do
				if te:GetTarget()(te,c,sg,Group.CreateGroup(),Group.CreateGroup(),tsg,ntsg) then
					hanchk=true
					break
				end
			end
			if not hanchk then return false end
		end
	end]]
	local lvchk=false
	if sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_MATERIAL_CUSTOM) then
		local g=sg:Filter(Card.IsHasEffect,nil,EFFECT_SYNCHRO_MATERIAL_CUSTOM)
		for tc in aux.Next(g) do
			local teg={tc:GetCardEffect(EFFECT_SYNCHRO_MATERIAL_CUSTOM)}
			for _,te in ipairs(teg) do
				local op=te:GetOperation()
				local ok,tlvchk=op(te,tg,ntg,sg,lv,sc,tp)
				if not ok then return false end
				lvchk=lvchk or tlvchk
			end
		end
	end
	return (lvchk or sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,sg:GetCount(),sg:GetCount(),sc))
	and ((sc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0)
		or (not sc:IsLocation(LOCATION_EXTRA) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(Auxiliary.FConditionCheckF,nil,tp))))
end
function Auxiliary.SynTarget(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg)
				local sg=Group.CreateGroup()
				local lv=c:GetLevel()
				local mgchk
				local g
				local dg
				if mg then
					mgchk=true
					dg=mg
					g=mg:Filter(Card.IsCanBeSynchroMaterial,c,c)
				else
					mgchk=false
					dg=Duel.GetMatchingGroup(function(mc) return mc:IsFaceup() and (mc:IsControler(tp) or mc:IsCanBeSynchroMaterial(c)) end,tp,LOCATION_MZONE,LOCATION_MZONE,c)
					g=dg:Filter(Card.IsCanBeSynchroMaterial,nil,c)
				end
				local pg=Auxiliary.GetMustBeMaterialGroup(tp,dg,tp,c,g,REASON_SYNCHRO)
				if smat then
					if smat.KeepAlive then
						pg:Merge(smat)
						g:Merge(smat)
					else
						pg:AddCard(smat)
						g:AddCard(smat)
					end
				end
				local tg
				local ntg
				if mgchk then
					tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1,c,tp)
					ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2,c,tp)
				else
					tg=g:Filter(Auxiliary.TunerFilter,nil,f1,sub1,c,tp)
					ntg=g:Filter(Auxiliary.NonTunerFilter,nil,f2,sub2,c,tp)
					local thg=tg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
					thg:Merge(ntg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO))
					local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
					for thc in aux.Next(thg) do
						local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
						local val=te:GetValue()
						local thag=hg:Filter(function(mc) return Auxiliary.TunerFilter(mc,f1,sub1,c,tp) and val(te,mc,c) end,nil) --tuner
						local nthag=hg:Filter(function(mc) return Auxiliary.NonTunerFilter(mc,f2,sub2,c,tp) and val(te,mc,c) end,nil) --non-tuner
						tg:Merge(thag)
						ntg:Merge(nthag)
					end
				end
				local lv=c:GetLevel()
				local tsg=Group.CreateGroup()
				if g:IsExists(Auxiliary.SynchroCheckFilterChk,1,nil,f1,f2,sub1,sub2,c,tp) then
					local ntsg=Group.CreateGroup()
					local tune=true
					local g2=Group.CreateGroup()
					while ntsg:GetCount()<max2 do
						local cancel=false
						if tune then
							cancel=not mgchk and Duel.GetCurrentChain()<=0 and tsg:GetCount()==0
							local g3=ntg:Filter(Auxiliary.SynchroCheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							g2=g:Filter(Auxiliary.SynchroCheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							if g3:GetCount()>0 and tsg:GetCount()>=min1 and tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1,c,tp) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if tsg:GetCount()>=min1 and tsg:IsExists(Auxiliary.TunerFilter,tsg:GetCount(),nil,f1,sub1,c,tp) and (not req1 or tsg:IsExists(req1,reqct1,nil,tp))
									and ntg:Filter(Auxiliary.SynchroCheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,c,tp,pg,mgchk):GetCount()>0 then tune=false
								else
									return false
								end
							end
							if not sg:IsContains(tc) then
								if g3:IsContains(tc) then
									ntsg:AddCard(tc)
									tune = false
								else
									tsg:AddCard(tc)
								end
								sg:AddCard(tc)
								if tc:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
									local teg={tc:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
									for i=1,#teg do
										local te=teg[i]
										local tg=g:Filter(function(mc) return te:GetValue()(te,mc) end,nil)
									end
								end
							else
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
								if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
									Duel.AssumeReset()
								end
							end
							if g:FilterCount(Auxiliary.SynchroCheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)==0 or tsg:GetCount()>=max2 then
								tune=false
							end
						else
							if (ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
								and ntsg:IsExists(Auxiliary.NonTunerFilter,ntsg:GetCount(),nil,f2,sub2,c,tp)
								and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp)) or (not mgchk and Duel.GetCurrentChain()<=0) then
									cancel=true
							end
							g2=g:Filter(Auxiliary.SynchroCheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							if g2:GetCount()==0 then break end
							local g3=g:Filter(Auxiliary.SynchroCheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							if g3:GetCount()>0 and ntsg:GetCount()==0 and tsg:GetCount()<max1 then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp)) 
									and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp) then break end
								return false
							end
							if not tsg:IsContains(tc) then
								if not sg:IsContains(tc) then
									ntsg:AddCard(tc)
									sg:AddCard(tc)
									if tc:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
										local teg={tc:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
										for i=1,#teg do
											local te=teg[i]
											local tg=g:Filter(function(mc) return te:GetValue()(te,mc) end,nil)
										end
									end
								else
									ntsg:RemoveCard(tc)
									sg:RemoveCard(tc)
									if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
										Duel.AssumeReset()
									end
								end
							elseif ntsg:GetCount()==0 then
								tune=true
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
						end
					end
					Duel.AssumeReset()
				else
					local ntsg=Group.CreateGroup()
					local tune=true
					local g2=Group.CreateGroup()
					while ntsg:GetCount()<max2 do
						cancel=false
						if tune then
							cancel=not mgchk and Duel.GetCurrentChain()<=0 and tsg:GetCount()==0
							local g3=ntg:Filter(Auxiliary.SynchroCheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							g2=tg:Filter(Auxiliary.SynchroCheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							if g3:GetCount()>0 and tsg:GetCount()>=min1 and (not req1 or tsg:IsExists(req1,reqct1,nil,tp)) then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if tsg:GetCount()>=min1 and (not req1 or tsg:IsExists(req1,reqct1,nil,tp))
									and ntg:Filter(Auxiliary.SynchroCheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,c,tp,pg,mgchk):GetCount()>0 then tune=false
								else
									return false
								end
							else
								if not sg:IsContains(tc) then
									if g3:IsContains(tc) then
										ntsg:AddCard(tc)
										tune = false
									else
										tsg:AddCard(tc)
									end
									sg:AddCard(tc)
								else
									tsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							end
							if tg:FilterCount(Auxiliary.SynchroCheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)==0 or tsg:GetCount()>=max1 then
								tune=false
							end
						else
							if ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp))
								and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp) then
								cancel=true
							end
							g2=ntg:Filter(Auxiliary.SynchroCheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							if g2:GetCount()==0 then break end
							local g3=tg:Filter(Auxiliary.SynchroCheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,reqct1,req2,reqct2,reqm,lv,c,tp,pg,mgchk)
							if g3:GetCount()>0 and ntsg:GetCount()==0 and tsg:GetCount()<max1 then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,cancel,cancel)
							if not tc then
								if ntsg:GetCount()>=min2 and (not req2 or ntsg:IsExists(req2,reqct2,nil,tp)) and (not reqm or sg:IsExists(reqm,1,nil,tp))
									and sg:Includes(pg) and Auxiliary.SynchroCheckP43(tsg,ntsg,sg,lv,c,tp) then break end
								return false
							end
							if not tsg:IsContains(tc) then
								if not sg:IsContains(tc) then
									ntsg:AddCard(tc)
									sg:AddCard(tc)
								else
									ntsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							elseif ntsg:GetCount()==0 then
								tune=true
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
						end
					end
				end
				local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
				aux.ResetEffects(hg,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
				if sg then
					local subtsg=tsg:Filter(function(c) return sub1 and sub1(c) and ((f1 and not f1(c)) or not c:IsType(TYPE_TUNER)) end,nil)
					local subc=subtsg:GetFirst()
					while subc do
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_ADD_TYPE)
						e1:SetValue(TYPE_TUNER)
						e1:SetReset(RESET_EVENT+0x1fe0000)
						subc:RegisterEffect(e1,true)
						subc=subtsg:GetNext()
					end
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
Auxiliary.SynchroSend=0
function Auxiliary.SynOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if Auxiliary.SynchroSend==1 then
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_RETURN)
	elseif Auxiliary.SynchroSend==2 then
		Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==3 then
		Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==4 then
		Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==5 then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
	elseif Auxiliary.SynchroSend==6 then
		Duel.Destroy(g,REASON_MATERIAL+REASON_SYNCHRO)
	else
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	end
	g:DeleteGroup()
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
				local ct=-ft
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
	return c:IsHasEffect(EFFECT_TUNE_MAGICIAN_F) and sg:IsExists(c.fuslimit,1,c)
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
				return mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc,gf)
			end
end
function Auxiliary.LinkOperation(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local sg=Group.CreateGroup()
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
					if g:GetCount()==0 then break end
					sg:Merge(g)
				end
				c:SetMaterial(sg)
				Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
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
function Auxiliary.IsMaterialListSetCard(c,setcode)
	return c.material_setcode and c.material_setcode==setcode
end
function Auxiliary.IsCodeListed(c,code)
	if not c.card_code_list then return false end
	for i,ccode in ipairs(c.card_code_list) do
		if code==ccode then return true end
	end
	return false
end
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
