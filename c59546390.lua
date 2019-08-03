--Celestial Sword - Eatos
function c59546390.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c59546390.target)
	e1:SetOperation(c59546390.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55569674,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c59546390.atkcon)
	e4:SetTarget(c59546390.atktg)
	e4:SetOperation(c59546390.atkop)
	c:RegisterEffect(e4)
	--ATK Increase and Banish All Opponent's Monsters
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(74123169,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c59546390.rmcon)
	e5:SetCost(c59546390.rmcost)
	e5:SetTarget(c59546390.rmtg)
	e5:SetOperation(c59546390.rmop)
	c:RegisterEffect(e5)
end

function c59546390.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c59546390.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c59546390.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c59546390.filter(c)
	return c:IsFaceup() and c:IsCode(34022290)
end
function c59546390.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c59546390.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59546390.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59546390.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59546390.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c59546390.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c59546390.atkfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500*ct)
		tc:RegisterEffect(e1)
	end
end

function c59546390.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) 
end
function c59546390.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59546390.rmfilter(c)
	return c:IsFaceup() and c:IsCode(34022290)
end
function c59546390.rmfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c59546390.rmfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()>0 and c:IsAbleToRemove()
end
function c59546390.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c59546390.rmfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59546390.rmfilter,tp,LOCATION_MZONE,0,1,nil) and 
	Duel.IsExistingTarget(c59546390.rmfilter1,tp,0,LOCATION_GRAVE,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c59546390.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59546390.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tc1=Duel.GetMatchingGroup(c59546390.rmfilter2,tp,0,LOCATION_GRAVE,tc)
	local sum=0
		Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
	local sum=Duel.GetOperatedGroup():GetSum(Card.GetAttack)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(sum)
	tc:RegisterEffect(e1)
end


