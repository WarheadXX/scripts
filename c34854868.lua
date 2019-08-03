--Synonymsis
function c34854868.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c34854868.cost)
	e1:SetTarget(c34854868.target)
	e1:SetOperation(c34854868.activate)
	c:RegisterEffect(e1)
end
function c34854868.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c34854868.spfilter2(c,e,tp)
	return c:IsLevelAbove(7) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c34854868.spfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel(),c:GetAttack(),c:GetDefence(),c:GetRace(),c:GetAttribute())
end
function c34854868.spfilter3(c,e,tp,lv,atk,def,race,att)
	return c:IsLevelAbove(7) and c:IsAbleToHand()
		and c:GetLevel()==lv and c:GetAttack()==atk and c:GetDefence()==def and not c:IsRace(race) and not c:IsAttribute(att)
end
function c34854868.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34854868.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c34854868.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c34854868.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c34854868.spfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetLevel(),g1:GetFirst():GetAttack(),g1:GetFirst():GetDefence(),g1:GetFirst():GetRace(),g1:GetFirst():GetAttribute())
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(2-tp,g1)
	end
