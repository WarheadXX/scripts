--Good and Evil of the Angelic Guardian
function c94749323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94749323,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c94749323.condition)
	e1:SetTarget(c94749323.target)
	e1:SetOperation(c94749323.operation)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94749323,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,94749322)
	e2:SetCondition(c94749323.rmcon)
	e2:SetCost(c94749323.rmcost)
	e2:SetTarget(c94749323.rmtg)
	e2:SetOperation(c94749323.rmop)
	c:RegisterEffect(e2)	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94749323,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,94749323)
	e3:SetCondition(c94749323.spcon)
	e3:SetOperation(c94749323.spop)
	c:RegisterEffect(e3)
	--Add
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(94749323,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,94749324)
	e4:SetCondition(c94749323.thcon)
	e4:SetTarget(c94749323.thtg)
	e4:SetOperation(c94749323.thop)
	c:RegisterEffect(e4)
	--tofield
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(94716825,4))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,94749325+EFFECT_COUNT_CODE_DUEL)
	e5:SetCondition(c94749323.setcon)
	e5:SetTarget(c94749323.settg)
	e5:SetOperation(c94749323.setop)
	c:RegisterEffect(e5)
end

function c94749323.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(82)
end
function c94749323.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c94749323.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c94749323.filter(c)
	return c:IsFaceup()
end
function c94749323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c94749323.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c94749323.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c94749323.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c94749323.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end

function c94749323.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c94749323.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c94749323.costfilter(c)
	return c:IsCode(34022290) and not c:IsPublic()
end
function c94749323.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94749323.costfilter,tp,LOCATION_HAND,0,1,nil) and 
	Duel.IsExistingMatchingCard(c94749323.rmfilter,tp,LOCATION_GRAVE,1,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c94749323.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c94749323.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c94749323.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94749323.rmfilter,tp,LOCATION_GRAVE,1,1,nil) end  
	local g=Duel.GetMatchingGroup(c94749323.rmfilter,tp,LOCATION_GRAVE,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function c94749323.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c94749323.rmfilter,tp,LOCATION_GRAVE,nil,nil)
	 Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	 Duel.BreakEffect()
	--Effects cannot be activated bro 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetTargetRange(1,0)
	e1:SetValue(c94749323.aclimit)
	Duel.RegisterEffect(e1,tp)
	 --Return during end phase
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(g:GetCount())
	e2:SetTarget(c94749323.retg)
	e2:SetOperation(c94749323.reop)
	Duel.RegisterEffect(e2,tp)
end
function c94749323.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return (loc==LOCATION_REMOVED) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c94749323.refilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c94749323.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94749323.refilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local sg=Duel.GetMatchingGroup(c94749323.refilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),PLAYER_ALL,LOCATION_REMOVED)
end
function c94749323.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c94749323.refilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(g,nil,2,REASON_EFFECT)
end

function c94749323.spcfilter(c,e,tp,id)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(82) and (c:GetTurnID()==id or c:GetTurnID()==id-1 or c:GetTurnID()==id-2) 
	and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsCode(18175965)
end
function c94749323.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c94749323.spcfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount())
end
function c94749323.spfilter(c,e,tp,id)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(82) and (c:GetTurnID()==id or c:GetTurnID()==id-1 or c:GetTurnID()==id-2) 
	and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsCode(18175965)
end
function c94749323.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c94749323.spfilter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		Duel.Damage(tp,g:GetCount()*1000,REASON_EFFECT)
		local t1=g:GetFirst()
		local t2=g:GetNext()
		local t3=g:GetNext()
		local t4=g:GetNext()
		local t5=g:GetNext()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		t1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		t1:RegisterEffect(e2)
		if t2 then
			local e3=e1:Clone()
			t2:RegisterEffect(e3)
			local e4=e2:Clone()
			t2:RegisterEffect(e4)
		if t3 then
			local e5=e1:Clone()
			t3:RegisterEffect(e5)
			local e6=e2:Clone()
			t3:RegisterEffect(e6)
		if t4 then
			local e7=e1:Clone()
			t4:RegisterEffect(e7)
			local e8=e2:Clone()
			t4:RegisterEffect(e8)
		if t5 then
			local e9=e1:Clone()
			t5:RegisterEffect(e9)
			local e10=e2:Clone()
			t5:RegisterEffect(e10)
		end
end
end
end
end
end

function c94749323.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(82)
end
function c94749323.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c94749323.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c94749323.thfilter(c)
	return c:IsSetCard(82) and c:IsAbleToHand() and not c:IsCode(94749323)
end
function c94749323.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.IsExistingMatchingCard(c94749323.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c94749323.desfilter(c)
	return c:IsSetCard(82) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c94749323.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c94749323.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then 
		Duel.ConfirmCards(1-tp,g)
		local g=Duel.GetMatchingGroup(c94749323.desfilter,tp,LOCATION_MZONE,0,e:GetHandler())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end

function c94749323.sfilter(c)
	return c:IsFaceup() and c:IsCode(17052477)
end
function c94749323.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c94749323.sfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c94749323.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c94749323.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end