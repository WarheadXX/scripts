--Opaque Ocelot
function c4540526.initial_effect(c)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4540526,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,4540526)
	e1:SetCost(c4540526.thcost)
	e1:SetTarget(c4540526.thtg)
	e1:SetOperation(c4540526.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4540526,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,4540527)
	e2:SetCost(c4540526.spcost)
	e2:SetTarget(c4540526.sptg)
	e2:SetOperation(c4540526.spop)
	c:RegisterEffect(e2)
end

function c4540526.mat_filter(c)
	return not c:IsCode(4540526)
end
function c4540526.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c4540526.thfilter(c)
	return c:IsType(TYPE_RITUAL) and not c:IsCode(4540526) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c4540526.thfilter2(c)
	return c:IsType(TYPE_RITUAL) and not c:IsCode(4540526) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c4540526.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4540526.thfilter,tp,LOCATION_DECK,0,1,nil) and 
	Duel.IsExistingMatchingCard(c4540526.thfilter2,tp,LOCATION_DECK,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4540526.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c4540526.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c4540526.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end

function c4540526.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c4540526.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c4540526.filter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c4540526.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c4540526.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,2,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,4540526)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c4540526.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,2,2,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c4540526.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,4540526) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GetMatchingGroup(c4540526.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,2,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
end
