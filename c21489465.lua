--SkyDusk Dragon
function c21489465.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9748752,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c21489465.condition)
	e1:SetTarget(c21489465.target)
	e1:SetOperation(c21489465.operation)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

function c21489465.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c21489465.damfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c21489465.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)>0 end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetChainLimit(aux.FALSE)
end
function c21489465.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21489465.damfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=g:GetCount()*500
	Duel.Damage(1-tp,ct,REASON_EFFECT)
end
