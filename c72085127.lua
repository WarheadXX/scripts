--Rescue Ferret
function c72085127.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72081527)
	e1:SetCondition(c72085127.spcon)
	e1:SetCost(c72085127.spcost)
	e1:SetTarget(c72085127.sptg)
	e1:SetOperation(c72085127.spop)
	c:RegisterEffect(e1)
end
function c72085127.ctfilter(c,e)
	return c:IsCode(51387292) or c:IsCode(32129317) or c:IsCode(52894680) or c:IsCode(895727) or c:IsCode(58464990) or c:IsCode(76028167)
end
function c72085127.cfilter(c,seq)
	return c:IsFaceup() and (c:IsCode(32129317) or c:IsCode(51387292) or c:IsCode(58464990)) and c:GetSequence()~=seq
end
function c72085127.cfilter3(c,seq)
	return c:IsFaceup() and (c:IsCode(32129317) or c:IsCode(51387292) or c:IsCode(58464990) or c:IsCode(895727)) and c:GetSequence()~=seq
end
function c72085127.spcon(e)
	return (Duel.IsExistingMatchingCard(c72085127.ctfilter,tp,LOCATION_MZONE,0,1,nil) or 
	Duel.IsExistingMatchingCard(c72085127.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()+1) or Duel.IsExistingMatchingCard(c72085127.cfilter3,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()-1))
end
function c72085127.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c72085127.spfilter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and lv<6 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c72085127.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp,6-lv) and not c:IsCode(72085127)
end
function c72085127.spfilter2(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(72085127)
end
function c72085127.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72085127.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72085127.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72085127.spfilter1),tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72085127.spfilter2),tp,LOCATION_DECK,0,1,1,tc1,e,tp,6-tc1:GetLevel())
	g1:Merge(g2)
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
end
