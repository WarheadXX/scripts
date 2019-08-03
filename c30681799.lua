--Eerian of Negativity
function c30781799.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c30781799.spcon)
	c:RegisterEffect(e1)
	--lv up or down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30681799,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c30781799.lvop)
	c:RegisterEffect(e2)
end

function c30781799.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c30781799.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c30781799.cfilter,tp,LOCATION_MZONE,0,1,nil)
end


function c30781799.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(30681799,1),aux.Stringid(30681799,2))
	elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(30681799,3))
	elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(30681799,4))+1 end
	if op=0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	elseif op=1 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
end
