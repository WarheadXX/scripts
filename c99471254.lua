--The Phantom Knights of Old Axe
function c99471254.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG2_XMDETACH)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c99471254.descost)
	e1:SetTarget(c99471254.destg)
	e1:SetOperation(c99471254.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99471254,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c99471254.spcon)
	e2:SetTarget(c99471254.sptg)
	e2:SetOperation(c99471254.spop)
	c:RegisterEffect(e2)
end

function c99471254.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c99471254.filter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c99471254.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c99471254.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c99471254.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99471254.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c99471254.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return Duel.IsChainNegatable(ev) or Duel.IsChainDisablable(ev)
end
function c99471254.filter2(c,e,tp,rk)
	return c:IsRankBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsSetCard(0x48) and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99471254.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99471254.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99471254.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99471254.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
	    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	    e1:SetType(EFFECT_TYPE_IGNITION)
	    e1:SetProperty(EFFECT_FLAG2_XMDETACH)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCountLimit(1)
	    e1:SetCost(c99471254.descost2)
	    e1:SetTarget(c99471254.destg2)
	    e1:SetOperation(c99471254.desop2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
	    e2:SetDescription(aux.Stringid(99471254,0))
	    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	    e2:SetRange(LOCATION_MZONE)
	    e2:SetCode(EVENT_CHAINING)
		e2:SetCountLimit(1,99471254)
	    e2:SetCondition(c99471254.spcon2)
	    e2:SetTarget(c99471254.sptg2)
	    e2:SetOperation(c99471254.spop2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		--code
	    local e3=Effect.CreateEffect(c)
	    e3:SetType(EFFECT_TYPE_SINGLE)
	    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e3:SetCode(EFFECT_CHANGE_CODE)
	    e3:SetRange(LOCATION_MZONE)
	    e3:SetValue(99471254)
		e3:SetReset(RESET_EVENT+0x1fe0000)
	    sc:RegisterEffect(e3,true)
		if not sc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e4,true)
		end
		sc:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end
end

function c99471254.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c99471254.filter3(c)
	return c:IsRace(RACE_WARRIOR)
end
function c99471254.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c99471254.filter3,tp,LOCATION_REMOVED,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c99471254.filter3,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99471254.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c99471254.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return Duel.IsChainNegatable(ev) or Duel.IsChainDisablable(ev)
end
function c99471254.filter4(c,e,tp,rk)
	return c:IsRankBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsSetCard(0x48) and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99471254.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99471254.filter4,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99471254.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99471254.filter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
	    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	    e1:SetType(EFFECT_TYPE_IGNITION)
	    e1:SetProperty(EFFECT_FLAG2_XMDETACH)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCountLimit(1)
	    e1:SetCost(c99471254.descost2)
	    e1:SetTarget(c99471254.destg2)
	    e1:SetOperation(c99471254.desop2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
	    e2:SetDescription(aux.Stringid(99471254,0))
	    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	    e2:SetRange(LOCATION_MZONE)
	    e2:SetCode(EVENT_CHAINING)
		e2:SetCountLimit(1,99471254)
	    e2:SetCondition(c99471254.spcon2)
	    e2:SetTarget(c99471254.sptg2)
	    e2:SetOperation(c99471254.spop2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		--code
	    local e3=Effect.CreateEffect(c)
	    e3:SetType(EFFECT_TYPE_SINGLE)
	    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e3:SetCode(EFFECT_CHANGE_CODE)
	    e3:SetRange(LOCATION_MZONE)
	    e3:SetValue(99471254)
		e3:SetReset(RESET_EVENT+0x1fe0000)
	    sc:RegisterEffect(e3,true)
		if not sc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e4,true)
		end
		sc:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end
end