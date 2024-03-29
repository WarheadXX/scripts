--闇黒世界－シャドウ・ディストピア－
--Lair of Darkness
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--tribute substitute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetCode(id)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	--e3:SetCondition(s.condition)
	e3:SetCode(EFFECT_LAIR_RELEASE)
	e3:SetProperty(EFFECT_FLAG_COUNT_LIMIT)
	e3:SetCountLimit(1)
	--e3:SetCountLimit(1)
	--e3:SetReset(RESET_PHASE+PHASE_END)
	--e3:SetOperation(s.operation)
	--e3:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	--tribute substitute
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetDescription(aux.Stringid(id,0))
	-- e3:SetType(EFFECT_TYPE_FIELD)
	-- e3:SetCode(59160188)
	-- e3:SetRange(LOCATION_FZONE)
	-- e3:SetTargetRange(0,LOCATION_MZONE)
	-- e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	-- e3:SetCondition(s.condition)
	-- c:RegisterEffect(e3)
	-- local e4=e3:Clone()
	-- e4:SetType(EFFECT_TYPE_SINGLE)
	-- e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	-- c:RegisterEffect(e4)
	-- local e4=e3:Clone()
	-- e4:SetType(EFFECT_TYPE_SINGLE)
	-- e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	-- c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_RELEASE)
	e6:SetLabelObject(e5)
	e6:SetRange(LOCATION_FZONE)
	e6:SetOperation(s.regop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e7:SetOperation(s.clearop)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD_P)
	e8:SetOperation(s.clearop)
	c:RegisterEffect(e8)
end
LAIR = 0
function s.condition(e,tp)
	return e:GetHandler():GetFlagEffect(id)==0 and LAIR == 0
	--return Duel.SelectYesNo(tp,aux.Stringid(id,0))
	--if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return true end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
	LAIR = 1
    -- local c=e:GetHandler()
    -- local d1=Effect.CreateEffect(e:GetHandler())
	-- d1:SetType(EFFECT_TYPE_FIELD)
	-- d1:SetRange(LOCATION_FZONE)
	-- d1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	-- d1:SetTargetRange(0,LOCATION_MZONE)
    -- d1:SetCode(EFFECT_LAIR_RELEASE)
	-- c:RegisterEffect(d1)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_EXTRA_RELEASE)
	-- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	--e1:SetTargetRange(1,1)
	-- e1:SetCountLimit(1)
	--e1:SetTarget(s.splimit)
	-- e1:SetReset(RESET_PHASE+PHASE_END)
	-- Duel.RegisterEffect(e1,tp)
	-- local g=Duel.GetMatchingGroup(Card.IsType,tp,nil,LOCATION_MZONE,nil,TYPE_MONSTER)
	-- local tc=g:GetFirst()
	-- while tc do
		-- local e1=Effect.CreateEffect(e:GetHandler())
		-- e1:SetType(EFFECT_TYPE_SINGLE)
		-- e1:SetCode(EFFECT_EXTRA_RELEASE)
		-- e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		-- tc:RegisterEffect(e1)
		-- tc=g:GetNext()
	-- end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ec>0 then
		local val=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(val+ec)
	end	
end
function s.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	if ct==0 or not e:GetHandler():IsRelateToEffect(e) 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,1000,1000,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,p) then return end
	local ct=math.min(Duel.GetLocationCount(p,LOCATION_MZONE),e:GetLabel())
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=math.min(1,ct) end
	if ct==0 then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
