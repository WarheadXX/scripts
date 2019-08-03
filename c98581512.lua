--RUM the Phantom Knights of Legion
function c98581512.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98581512.target)
	e1:SetOperation(c98581512.operation)
	c:RegisterEffect(e1)
end

function c98581512.spfilter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetRank()==3 and c:IsType(TYPE_XYZ)
end
function c98581512.spfilter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetRank()==4 and c:IsType(TYPE_XYZ)
end
function c98581512.spfilter3(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetRank()==5 and c:IsType(TYPE_XYZ)
end
function c98581512.spfilter4(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and c:GetRank()==12
end
function c98581512.rfilter(c,lv)
	return c:GetLevel()==lv
end
function c98581512.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and Duel.IsExistingTarget(c98581512.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    and Duel.IsExistingTarget(c98581512.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingTarget(c98581512.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c98581512.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c98581512.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,c98581512.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c98581512.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=3 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local g1=Duel.SelectMatchingCard(tp,c98581512.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		tc:SetMaterial(g)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(tc,g)
		tc:CompleteProcedure()
	end
end