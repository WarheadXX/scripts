--魂の開封
--Soul Unseal
--Scripted by AlphaKretin
-- local s,id=GetID()
function c100237002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100237002.thcon)
	e1:SetTarget(c100237002.thtg)
	e1:SetOperation(c100237002.thop)
	c:RegisterEffect(e1)
end
function c100237002.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c100237002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>0 
		and Duel.IsExistingMatchingCard(c100237002.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100237002.thfilter(c)
	return c:IsType(TYPE_NORMAL) and (c:IsAbleToHand() or c:IsAbleToRemove())
end
function c100237002.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsAbleToHand,nil)>0 
		and sg:FilterCount(Card.IsAbleToRemove,nil)>3
end
function c100237002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100237002.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,5,5,c100237002.rescon,chk) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,0,0)
end
function c100237002.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100237002.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local sg=Duel.SelectMatchingCard(tp,c100237002.thfilter,tp,LOCATION_DECK,0,5,5,nil,e,tp)
	local rg=Group.CreateGroup(sg)
	local sc=rg:Select(tp,1,1,nil)
	if sg:GetCount()>0 and Duel.SendtoHand(sc,nil,REASON_EFFECT)==0 then
		Duel.SendtoGrave(sc,REASON_RULE)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
