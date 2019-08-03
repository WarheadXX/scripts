--Wattoperation
function c84811347.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84811347,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,84811347)
	e2:SetCost(c84811347.spcost)
	e2:SetCondition(c84811347.spcon)
	e2:SetOperation(c84811347.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84811347,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c84811347.spcon1)
	e3:SetOperation(c84811347.spop1)
	c:RegisterEffect(e3)
end

function c84811347.spcfilter(c,e,tp,id)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(14) and (c:GetTurnID()==id)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84811347.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c84811347.spcfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount())
end
function c84811347.costfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_THUNDER)
end
function c84811347.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84811347.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c84811347.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c84811347.spfilter(c,e,tp,id)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(14) and (c:GetTurnID()==id) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84811347.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c84811347.spfilter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
end
end

function c84811347.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c84811347.spfilter1(c,e)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(14) and c:IsLevelBelow(7)
end
function c84811347.spop1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c84811347.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c84811347.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c84811347.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
end
	tc:CompleteProcedure()
end

