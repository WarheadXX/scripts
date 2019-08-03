--Evilswarm Rajavanaj
function c3441481.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,3)
	c:EnableReviveLimit()
	--Cannot be Xyz Material for a Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3441481,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c3441481.copytg)
	e2:SetOperation(c3441481.copyop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c3441481.sumlimit)
	e3:SetCondition(c3441481.dscon)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3441481,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetHintTiming(0,0x1c0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c3441481.con)
	e4:SetCost(c3441481.cost1)
	e4:SetTarget(c3441481.drtg)
	e4:SetOperation(c3441481.drop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(3441481,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetHintTiming(0,0x1c0)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c3441481.con)
	e5:SetCost(c3441481.cost2)
	e5:SetTarget(c3441481.target2)
	e5:SetOperation(c3441481.operation2)
	c:RegisterEffect(e5)
end

function c3441481.filter(c)
	return c:IsSetCard(10) and c:IsType(TYPE_XYZ)
end
function c3441481.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and c3441481.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c3441481.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c3441481.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
end
function c3441481.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(3441481,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c3441481.rstcon)
		e1:SetOperation(c3441481.rstop)
		e1:SetLabel(cid)
		e1:SetLabelObject(e1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		Duel.Overlay(c,tc)
	end
end
function c3441481.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	return Duel.GetTurnPlayer()~=e1:GetLabel()
end
function c3441481.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c3441481.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c3441481.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLevelAbove(5) or c:IsRankAbove(5) and not c:IsSetCard(10)
end

function c3441481.con(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(Card.IsType,1,nil,TYPE_XYZ) and g:IsExists(Card.IsSetCard,1,nil,10)
end
function c3441481.cfilter(c,e,tp)
	return  c:IsSetCard(101) and c:IsAbleToRemoveAsCost()
end
function c3441481.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	and Duel.IsExistingMatchingCard(c3441481.cfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c3441481.cfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c3441481.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c3441481.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c3441481.cfilter2(c,e,tp)
	return  c:IsSetCard(10) and c:IsAbleToRemoveAsCost()
end
function c3441481.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) and c:GetFlagEffect(3441481)==0 and 
	Duel.IsExistingMatchingCard(c3441481.cfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c3441481.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c3441481.chfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c3441481.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c3441481.chfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c3441481.chfilter,tp,0,LOCATION_MZONE,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c3441481.chfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c3441481.operation2(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(50)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
