-- Backup Gardna
function c36182445.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7088744,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c36182445.spcon)
	c:RegisterEffect(e1)
	--Redirect Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c36182445.eqtg)
	e2:SetOperation(c36182445.eqop)
	c:RegisterEffect(e2)
    --Negate attacks
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCost(c36182445.indcost)
	e3:SetOperation(c36182445.indop)
	c:RegisterEffect(e3)
end

function c36182445.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c36182445.filter1(c,tp)
	return c:IsFaceup() and c:GetEquipTarget()
		and Duel.IsExistingTarget(c36182445.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c)
end
function c36182445.filter2(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function c36182445.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c36182445.filter1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c36182445.filter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local eqc=g1:GetFirst()
	e:SetLabelObject(eqc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c36182445.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,eqc:GetEquipTarget(),eqc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
end
function c36182445.eqop(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==eqc then tc=g:GetNext() end
	if not eqc:IsRelateToEffect(e) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(eqc,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,eqc,tc)
end
function c36182445.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c36182445.indop(e,tp,eg,ep,ev,re,r,rp)
Duel.NegateAttack()
end
