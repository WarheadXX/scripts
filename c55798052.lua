--Swiftblade Prodigy Dragon
function c55798052.initial_effect(c)
	--Make Level 4
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(4)
	c:RegisterEffect(e1)
	--special summon SkyDusk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55798052,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,55798052)
	e2:SetCost(c55798052.spcost)
	e2:SetTarget(c55798052.sptg)
	e2:SetOperation(c55798052.spop)
	c:RegisterEffect(e2)
	--spsummon from Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55798052,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,55798052)
	e3:SetCost(c55798052.spcost2)
	e3:SetTarget(c55798052.sptg2)
	e3:SetOperation(c55798052.spop2)
	c:RegisterEffect(e3)
	--spsummon from rune, pendulum, banished
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55798052,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,55798052)
	e4:SetCost(c55798052.spcost3)
	e4:SetTarget(c55798052.sptg3)
	e4:SetOperation(c55798052.spop3)
	c:RegisterEffect(e4)
end

function c55798052.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c55798052.filter(c,e,tp)
	return c:IsCode(97965070) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55798052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c55798052.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c55798052.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55798052.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
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
			--pendulum
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(86238081,0))
			e3:SetCategory(CATEGORY_DESTROY)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e3:SetCode(EVENT_DESTROYED)
			e3:SetProperty(EFFECT_FLAG_DELAY)
			e3:SetCondition(c55798052.pencon)
			e3:SetTarget(c55798052.pentg)
			e3:SetOperation(c55798052.penop)
			tc:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
end
end

function c55798052.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c55798052.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c55798052.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c55798052.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c55798052.filter2(c,e,tp)
	return c:IsSetCard(1000)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55798052.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c55798052.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c55798052.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55798052.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c55798052.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c55798052.filter3(c,e,tp)
	return c:IsSetCard(1000)
	and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55798052.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c55798052.filter2,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c55798052.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55798052.filter3,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE,0,1,1,nil,e,tp,c)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

