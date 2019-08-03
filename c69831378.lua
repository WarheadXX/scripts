--Zeradias, Fiend of Abyss
function c69831378.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69831378,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c69831378.cost)
	e1:SetTarget(c69831378.target)
	e1:SetOperation(c69831378.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c69831378.destg)
	e2:SetValue(c69831378.repval)
	c:RegisterEffect(e2)
end

function c69831378.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c69831378.filter(c)
	return c:IsCode(7982776) and c:IsAbleToHand()
end
function c69831378.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c69831378.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69831378.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c69831378.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c69831378.rfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsCode(7982776)
end
function c69831378.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c69831378.rfilter,1,e:GetHandler()) end
	if Duel.SelectYesNo(tp,aux.Stringid(69831378,1)) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c69831378.repval(e,c)
	return c:IsFaceup() and c:IsCode(7982776) and c~=e:GetHandler() 
end