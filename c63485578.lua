--Convert Ghost
function c63485578.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,63485578)
	e1:SetCondition(c63485578.condition)
	e1:SetCost(c63485578.cost)
	e1:SetTarget(c63485578.target)
	e1:SetOperation(c63485578.activate)
	c:RegisterEffect(e1)
end
function c63485578.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3013) or c:IsCode(63468625) or c:IsCode(38522377)
end
function c63485578.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c63485578.cfilter,tp,LOCATION_MZONE,0,1,nil) and rp~=tp 
end
function c63485578.costfilter1(c)
	return  c:IsSetCard(19) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c63485578.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63485578.costfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREMOVE)
	local g=Duel.SelectMatchingCard(tp,c63485578.costfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c63485578.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c63485578.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end