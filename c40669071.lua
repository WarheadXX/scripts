--エクスコード・トーカー
--Excode Talker
--Scripted by Eerie Code
function c40669071.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedureCT(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2)
	--lock zones
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40669071,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40669071)
	e1:SetCondition(c40669071.lzcon)
	e1:SetTarget(c40669071.lztg)
	e1:SetOperation(c40669071.lzop)
	c:RegisterEffect(e1)
	--atk up/indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c40669071.tgtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	-- local e3=e2:Clone()
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_FIELD)
	-- e3:SetCode(EFFECT_UPDATE_ATTACK)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	-- -- e3:SetCondition(c40669071.atkcon)
	-- e3:SetTarget(c40669071.atktg)
	-- e3:SetValue(500)
	-- c:RegisterEffect(e3)
	local e3=e2:Clone()
	e3:SetProperty(0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
function c40669071.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40669071.lzfilter(c)
	return c:GetSequence()>4
end
function c40669071.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c40669071.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct end
	local dis=Duel.SelectDisableField(tp,ct,LOCATION_MZONE,LOCATION_MZONE,0)
	e:SetLabel(dis)
end
function c40669071.lzop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c40669071.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetLabel(e:GetLabel())
	e:GetHandler():RegisterEffect(e1)
end
function c40669071.disop(e,tp)
	return e:GetLabel()
end
function c40669071.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
-- function c40669071.atkcon(e)
	-- return e:GetHandler():GetLinkedGroup()>0
-- end
-- function c40669071.atktg(e,c)
	-- local g=e:GetHandler():GetLinkedGroup()
	-- return c==e:GetHandler() or g:IsContains(c)
-- end
