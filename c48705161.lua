--Single One Force
function c48705161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,48705161)
	e1:SetCost(c48705161.cost)
	e1:SetTarget(c48705161.target)
	e1:SetOperation(c48705161.activate)
	c:RegisterEffect(e1)
end

function c48705161.costfilter(c,e,tp,c2)
	return c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c48705161.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,c,e,tp)
end
function c48705161.filter(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c48705161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c48705161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c2=e:GetHandler()
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c48705161.costfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,c2)
		else
			return Duel.IsExistingMatchingCard(c48705161.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c48705161.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp)
		Duel.SendtoDeck(g,nil,1,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c48705161.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c48705161.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
