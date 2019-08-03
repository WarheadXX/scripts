--Ｓｉｎ Ｓｅｌｅｃｔｏｒ
--Malefic Selector
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.filter(c,g)
	return c:IsSetCard(0x23) and not c:IsCode(id) and c:IsAbleToHand() and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.rescon(sg,e,tp,mg)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,sg)
	return g:GetClassCount(Card.GetCode)>1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,tp)
	-- if chk==0 then return aux.SelectUnselectGroupCost(g,e,tp,2,2,s.rescon,0) end
	-- local rg=aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,1,tp,HINTMSG_REMOVE)
	if g:GetClassCount(Card.GetCode)<2 then return end
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	Duel.Remove(tg1,POS_FACEUP,REASON_COST)
	tg1:KeepAlive()
	e:SetLabelObject(tg1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	local hg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,rg)
	-- local g=aux.SelectUnselectGroup(hg,e,tp,2,2,aux.dncheck,1,tp,HINTMSG_ATOHAND)
	local tg1=hg:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg2=hg:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg1)
	end
end
