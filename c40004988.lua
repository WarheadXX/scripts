--Radiant Xyz Beacon
function c40004988.initial_effect(c)
	--XYZ FROM THE DECK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40004988)
	e1:SetCost(c40004988.cost)
	e1:SetTarget(c40004988.target)
	e1:SetOperation(c40004988.operation)
	c:RegisterEffect(e1)
	--Search RUM
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,40004988)
	e2:SetCondition(c40004988.thcon)
	e2:SetCost(c40004988.thcost)
	e2:SetTarget(c40004988.thtg)
	e2:SetOperation(c40004988.thop)
	c:RegisterEffect(e2)
end

function c40004988.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c40004988.filter(c,e,tp)
	return Duel.IsExistingMatchingCard(c40004988.filter2,tp,LOCATION_DECK,0,2,c,c:GetLevel())
		and Duel.IsExistingMatchingCard(c40004988.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function c40004988.filter2(c,lv,code)
	return c:GetLevel()==lv
end
function c40004988.xyzfilter(c,e,tp,lv)
	return c:GetRank()==lv and c.xyz_count==2 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c40004988.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40004988.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c40004988.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local g=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c40004988.filter2,tp,LOCATION_DECK,0,1,1,g,g:GetLevel())
	g:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local x=Duel.SelectMatchingCard(tp,c40004988.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g:GetLevel())
	local xyz=x:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(c40004988.xyzop)
	e1:SetReset(RESET_CHAIN)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetLabelObject(g1)
	xyz:RegisterEffect(e1)
	Duel.XyzSummon(tp,xyz,nil)
end
function c40004988.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mat=e:GetLabelObject()
	c:SetMaterial(mat)
	Duel.Overlay(c,mat)
end

function c40004988.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c40004988.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
	and Duel.IsExistingMatchingCard(c40004988.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c40004988.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and 
	Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c40004988.thfilter(c)
	return c:IsSetCard(149) and c:IsAbleToHand()
end
function c40004988.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40004988.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40004988.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40004988.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


