--Koala Shaman
function c62210297.initial_effect(c)
	--Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c62210297.spcost)
	e1:SetOperation(c62210297.spop)
	c:RegisterEffect(e1)
	--ATK BOOST
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,62210297)
	e2:SetCost(c62210297.cost2)
	e2:SetTarget(c62210297.tg2)
	e2:SetOperation(c62210297.op2)
	c:RegisterEffect(e2)
end

function c62210297.costfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAbleToGraveAsCost()
end
function c62210297.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c62210297.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c62210297.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c62210297.filter2(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_BEAST) and c:CheckFusionMaterial()
end
function c62210297.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c62210297.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
end

function c62210297.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c62210297.filter(c,rk)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function c62210297.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c62210297.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c62210297.filter,tp,LOCATION_MZONE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62210297.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c62210297.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=tc:GetFirst()
		local g2=Duel.GetMatchingGroup(c62210297.filter,tp,LOCATION_MZONE,0,tc)
		local atk=g2:GetSum(Card.GetAttack)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end