--Zeleste, Sacred of Ascension
function c39612004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c39612004.imcon)
	e1:SetValue(c39612004.tgvalue)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c39612004.tgvalue)
	c:RegisterEffect(e2)
	--Negate Spell/Trap, Then make material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(39612004,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c39612004.discon)
	e3:SetTarget(c39612004.distg)
	e3:SetOperation(c39612004.disop)
	c:RegisterEffect(e3)
	--Negate Monster Effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(39612004,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)	
	e4:SetCondition(c39612004.discon2)
	e4:SetCost(c39612004.discost2)
	e4:SetTarget(c39612004.distg2)
	e4:SetOperation(c39612004.disop2)
	c:RegisterEffect(e4)
	--XYZ GAINS A DRAW ONCE EFFECT, THEN ABSORBS SPELL/TRAPS
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c39612004.efcon)
	e5:SetOperation(c39612004.efop)
	c:RegisterEffect(e5)
end
function c39612004.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c39612004.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c39612004.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_SZONE
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) 
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not re:SetCode(39612004)
end
function c39612004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c39612004.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
function c39612004.discon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c39612004.discost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c39612004.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c39612004.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
	end
function c39612004.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c39612004.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(39612004,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(39612004)
	e1:SetCondition(c39612004.drcon2)
	e1:SetTarget(c39612004.drtg2)
	e1:SetOperation(c39612004.drop2)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	Duel.RaiseSingleEvent(rc,39612004,e,r,rp,ep,0)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
end
end
function c39612004.filter(c)
	return
end
function c39612004.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c39612004.drtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c39612004.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if  Duel.Draw(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(39612004,2))then
			local c=e:GetHandler()
			local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
				Duel.ConfirmCards(tp,g)
				g=g:Filter(Card.IsType,c,TYPE_SPELL+TYPE_TRAP)
			if g:GetCount()>0 and c:IsLocation(LOCATION_ONFIELD) then
				Duel.BreakEffect()
				Duel.Overlay(c,g)
		
end
end
end