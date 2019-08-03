--Dark Retaliation Dragon
function c95808696.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3)
	c:EnableReviveLimit()
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c95808696.val)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47017574,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c95808696.discost)
	e2:SetTarget(c95808696.distg)
	e2:SetOperation(c95808696.disop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c95808696.sptg)
	e3:SetOperation(c95808696.spop)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35952884,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c95808696.sumcon)
	e4:SetTarget(c95808696.sumtg)
	e4:SetOperation(c95808696.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
	--special summon
	local t1=Effect.CreateEffect(c)
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_SPSUMMON_PROC)
	t1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	t1:SetRange(LOCATION_EXTRA)
	t1:SetTargetRange(POS_FACEUP_ATTACK,0)
	c:RegisterEffect(t1)
end

function c95808696.val(e,c)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_XYZ)
	return math.max(0,ct-1)
end

function c95808696.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.SendtoGrave(c:GetOverlayGroup(),REASON_COST)
end
function c95808696.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c95808696.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
	    e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		if tc:IsType(TYPE_MONSTER) then
		   local e6=Effect.CreateEffect(c)
		    e6:SetType(EFFECT_TYPE_SINGLE)
		    e6:SetCode(EFFECT_UPDATE_ATTACK)
		    e6:SetReset(RESET_EVENT+0x1ff0000)
		    e6:SetValue(tc:GetAttack())
		    c:RegisterEffect(e6)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_SET_ATTACK_FINAL)
			e5:SetValue(0)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e5)
		end
		tc=g:GetNext()
	end
end

function c95808696.filter(c,e,tp)
	return c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c95808696.mtfilter(c)
	return (c:IsLocation(LOCATION_REMOVED))
end
function c95808696.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c95808696.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95808696.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95808696.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95808696.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c95808696.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		if g2:GetCount()>0 then
		Duel.Overlay(tc,g2)
		Duel.SpecialSummonComplete()
	end
end
end

function c95808696.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c95808696.spfilter(c,e,tp)
	return c:IsCode(16195942) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95808696.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95808696.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c95808696.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c95808696.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c95808696.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,2,nil,e,tp)
		if g2:GetCount()>0 then
		Duel.Overlay(tg,g2)
		Duel.SpecialSummonComplete()
	end
end
end
