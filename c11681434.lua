--Meklord Emperor Creation
function c11681434.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c11681434.condition)
	e1:SetCost(c11681434.cost)
	e1:SetTarget(c11681434.target)
	e1:SetOperation(c11681434.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11681434.decon)
	e2:SetTarget(c11681434.destg)
	e2:SetValue(c11681434.value)
	e2:SetOperation(c11681434.desop)
	c:RegisterEffect(e2)
end
function c11681434.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(63468625)
end
function c11681434.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11681434.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
end
function c11681434.costfilter(c,code)
	return c:IsSetCard(19) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c11681434.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c11681434.costfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11681434.costfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11681434.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11681434.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11681434.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c11681434.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=tc:GetFirst()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c11681434.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)		
		c:RegisterEffect(e1)
	end
end
function c11681434.eqlimit(e,c)
	return c:GetCode()==63468625
end
function c11681434.cosqli(c)
	return c:IsAbleToRemove() and c:IsSetCard(19)
end
function c11681434.cosqli2(c,e)
	return c==e:GetHandler():GetEquipTarget()
end
function c11681434.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c11681434.cosqli,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c11681434.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c11681434.cosqli2,1,nil,e)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(100000068,0))
end
function c11681434.value(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
function c11681434.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(c:GetControler(),c11681434.cosqli,c:GetControler(),LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end