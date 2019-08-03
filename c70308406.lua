--Madolche Candy Village
function c70308406.initial_effect(c)
	c:EnableCounterPermit(0x92)
	c:SetUniqueOnField(1,0,70308406)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add Counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60470713,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c70308406.ccon)
	e2:SetOperation(c70308406.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27918963,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c70308406.drcost)
	e4:SetTarget(c70308406.drtg)
	e4:SetOperation(c70308406.drop)
	c:RegisterEffect(e4)
end


function c70308406.cfilter(c,tp)
	return c:IsControler(tp) and c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_GRAVE) or (c:IsPreviousLocation(LOCATION_ONFIELD) 
		or (c:IsPreviousLocation(LOCATION_DECK))))
		and c:IsSetCard(0x71) and not c:IsLocation(LOCATION_EXTRA) and not c:IsReason(REASON_DRAW)
end
function c70308406.ccon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(c70308406.cfilter,1,nil,tp)
end
function c70308406.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x92,1)
end

function c70308406.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x92,1,REASON_COST)end
	local ct=e:GetHandler():GetCounter(0x92)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x92,ct,REASON_COST)
end
function c70308406.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x92)>0 and Duel.IsPlayerCanDraw(tp,c:GetCounter(0x92)) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c70308406.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end



