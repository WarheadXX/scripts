--Divine Sign of the Zodiac Dragon
function c27101832.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27101832.target)
	e1:SetOperation(c27101832.activate)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27101832,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)
	e2:SetCondition(c27101832.actcon)
	e2:SetCost(c27101832.actcost)
	e2:SetOperation(c27101832.actop)
	c:RegisterEffect(e2)
end

function c27101832.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c27101832.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,rk)
		and Duel.IsExistingMatchingCard(c27101832.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk)
end
function c27101832.filter2(c,e,rk)
	return c:IsType(TYPE_XYZ)
end
function c27101832.filter3(c)
	return c:IsType(TYPE_XYZ)
end
function c27101832.spfilter(c,e,tp,rk)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(49697902)
	end
function c27101832.spfilter2(c,e,tp,rk,g) 
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsCode(49697902)
	end
function c27101832.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c27101832.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.GetMatchingGroup(c27101832.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,rk)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,99,nil)
		Duel.SetTargetCard(sg)
	end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27101832.activate(e,tp,eg,ep,ev,re,r,rp)
	local rk=e:GetLabel()
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27101832.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk,mg0)
	local sc=g:GetFirst()
	local og=mg:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
		Duel.Overlay(sc,og)end
		sc:SetMaterial(Group.FromCards(sc))
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
end

function c27101832.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c27101832.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c27101832.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

	