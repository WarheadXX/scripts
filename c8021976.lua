--Swiftblade Witch of the Magical Forest
function c8021976.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,8021976)
	e1:SetTarget(c8021976.sptg)
	e1:SetOperation(c8021976.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91812341,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetOperation(c8021976.spop2)
	c:RegisterEffect(e2)
	--From Grave with cheese
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23064604,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCost(c8021976.thcost)
	e3:SetOperation(c8021976.thop)
	c:RegisterEffect(e3)
end

function c8021976.filter(c)
	return c:IsOnField()
end
function c8021976.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c8021976.filter,tp,LOCATION_ONFIELD,2,2,nil) end
end
function c8021976.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c8021976.filter,tp,LOCATION_ONFIELD,1,2,2,nil)
	if Duel.Destroy(g,REASON_EFFECT)==2 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
end

function c8021976.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end


function c8021976.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c8021976.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8021976.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c8021976.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c8021976.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
