--Accel Synchro Stealth Tunnel
function c45856727.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCost(c45856727.cost)
	e2:SetTarget(c45856727.sctg)
	e2:SetOperation(c45856727.scop)
	c:RegisterEffect(e2)
	--Immune destruction
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c45856727.tgvalue)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,45856727)
	e4:SetCondition(c45856727.discon)
	e4:SetTarget(c45856727.distg)
	e4:SetOperation(c45856727.disop)
	c:RegisterEffect(e4)
end

function c45856727.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(45856727)==0 end
	c:RegisterFlagEffect(45856727,RESET_CHAIN,0,1)
end
function c45856727.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c45856727.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end

function c45856727.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end	

function c45856727.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsType(TYPE_SYNCHRO) 
end
function c45856727.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c45856727.cfilter,1,nil,tp)
end
function c45856727.disfilter(c,code)
	return c:IsType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) or c:IsType(FACE_DOWN)
end
function c45856727.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45856727.disfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c45856727.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local sg=Duel.GetMatchingGroup(c45856727.disfilter,tp,0,LOCATION_ONFIELD,nil)
		local tc=sg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(0,LOCATION_ONFIELD)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		tc=sg:GetNext()
	end
end