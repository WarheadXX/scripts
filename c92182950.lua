--Synchro Nova
function c92182950.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c92182950.target)
	e1:SetOperation(c92182950.activate)
	c:RegisterEffect(e1)
end
function c92182950.spfilter(c,e,tp,ft,rg)
	local lv=c:GetLevel()
	return lv>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and rg:CheckWithSumEqual(Card.GetLevel,lv,ft,99) and c:IsType(TYPE_SYNCHRO)
end
function c92182950.rmfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGrave() and c:IsFaceup()
end
function c92182950.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then ft=-ft+1 else ft=1 end
	if chk==0 then
		local rg=Duel.GetMatchingGroup(c92182950.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		return Duel.IsExistingTarget(c92182950.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ft,rg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c92182950.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c92182950.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92182950.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ft,rg)
	local tc=g:GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	if ft<=0 then ft=-ft+1 else ft=1 end
	local rg=Duel.GetMatchingGroup(c92182950.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lv=tc:GetLevel()
	if rg:CheckWithSumEqual(Card.GetLevel,lv,ft,99) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,ft,99)
		Duel.SendtoGrave(rm,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()	
	end
end
