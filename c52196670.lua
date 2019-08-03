--Onslaught of the Ascended
function c52196670.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c52196670.target)
	e1:SetOperation(c52196670.activate)
	c:RegisterEffect(e1)
	--From Grave, To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,52196670)
	e2:SetCost(c52196670.thcost)
	e2:SetTarget(c52196670.thtg)
	e2:SetOperation(c52196670.thop)
	c:RegisterEffect(e2)
end

function c52196670.filter(c)
	return c:IsSetCard(0x73) and c:IsAbleToHand()
end
function c52196670.filter2(c)
	return c:IsFaceup() and c:IsRankAbove(10) and c:IsType(TYPE_XYZ)
end
function c52196670.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52196670.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52196670.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c52196670.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	if Duel.IsExistingMatchingCard(c52196670.filter2,tp,LOCATION_MZONE,1,1,nil,e:GetHandler(tp)) then
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,c52196670.filter2,tp,LOCATION_MZONE,nil,1,1,nil,e:GetHandler(tp))
			local ov=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
				Duel.ConfirmCards(tp,ov)
				ov=ov:Filter(Card.IsType,c,TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
			if ov:GetCount()>0 and c:IsLocation(LOCATION_ONFIELD) then
			local mg=ov:GetFirst():GetOverlayGroup()
			local tc=g:GetFirst()
				if mg:GetCount()>0 then
			 	Duel.Overlay(tc,mg)end
			 	Duel.BreakEffect()
				Duel.Overlay(tc,ov)
			if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
end
end
end
end

function c52196670.thfilter(c)
	return c:IsSetCard(115) and c:IsAbleToHand()
end
function c52196670.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c52196670.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c52196670.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c52196670.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c52196670.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c52196670.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end