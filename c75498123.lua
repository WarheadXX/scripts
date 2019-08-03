--Stellar Xyz Overlay
function c75498123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75498123.xyztg)
	e1:SetOperation(c75498123.xyzop)
	c:RegisterEffect(e1)
	--Attach Materials
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,75498123)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c75498123.cost)
	e2:SetTarget(c75498123.target)
	e2:SetOperation(c75498123.activate)
	c:RegisterEffect(e2)
end

function c75498123.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c75498123.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75498123.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,1,1,tp,LOCATION_EXTRA)
end
function c75498123.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75498123.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

function c75498123.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c75498123.filter(c)
	return c:IsType(TYPE_XYZ)
end
function c75498123.mtfilter(c)
	return (c:IsLocation(LOCATION_GRAVE))
end
function c75498123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c75498123.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c75498123.mtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil,e:GetHandler(tp)) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75498123,1))
	local g1=Duel.SelectTarget(tp,c75498123.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75498123,2))
end
function c75498123.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g2=Duel.SelectMatchingCard(tp,c75498123.mtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,2,nil,e,tp)
		if g2:GetCount()>0 then
		Duel.Overlay(tc,g2)
		end
	local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.IsPlayerCanDraw(tp,1)then
			Duel.Draw(tp,1,REASON_EFFECT)
	end	
end