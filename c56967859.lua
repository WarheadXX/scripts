--Felix, Swiftblade Strategist
function c56967859.initial_effect(c)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89463537,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,56967859)
	e1:SetCost(c56967859.cost)
	e1:SetTarget(c56967859.target)
	e1:SetOperation(c56967859.operation)
	c:RegisterEffect(e1)
	--NegateEffect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,56967860)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c56967859.condition2)
	e2:SetTarget(c56967859.target2)
	e2:SetOperation(c56967859.operation2)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
end

function c56967859.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c56967859.filter(c)
	return c:IsSetCard(1000) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c56967859.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c56967859.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c56967859.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c56967859.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c56967859.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c56967859.filter2(c)
	return c:IsSetCard(1000) and c:IsType(TYPE_MONSTER)
end
function c56967859.condition2(e,tp,eg,ep,ev,re,r,rp,rc)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return Duel.IsExistingMatchingCard(c56967859.filter2,c:GetControler(),LOCATION_MZONE,0,2,c) and
		rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c56967859.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c56967859.operation2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(e) then
		Duel.ChangePosition(rc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
