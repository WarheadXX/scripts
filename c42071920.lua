--Juggernaut Maximum
function c42071920.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2,c42071920.ovfilter,aux.Stringid(42071920,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c42071920.dscon)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c42071920.atcost)
	e2:SetOperation(c42071920.atop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(42071920,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCost(c42071920.descost)
	e3:SetTarget(c42071920.destg)
	e3:SetOperation(c42071920.desop)
	c:RegisterEffect(e3)
	--remove material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(42071920,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c42071920.rmcon)
	e4:SetTarget(c42071920.rmtg)
	e4:SetOperation(c42071920.rmop)
	c:RegisterEffect(e4)
end
function c42071920.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c42071920.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c42071920.atcost(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c42071920.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c42071920.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c42071920.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c42071920.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.Destructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,1,0,0,REASON_EFFECT)
end
end
function c42071920.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c42071920.rmcon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()~=tp
end
function c42071920.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
Duel.SetTargetPlayer(tp)
Duel.SetTargetParam(1)
Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c42071920.rmop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if not c:IsRelateToEffect(e) then return end
local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
if c:GetOverlayCount()>0 and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)~=0 then
Duel.Draw(p,d,REASON_EFFECT)
end
end		