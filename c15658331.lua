--Zophia, Queen of Ascension
function c15658331.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--Unaffected by Opponent Card Effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c15658331.uncon)
	e1:SetValue(c15658331.unval)
	c:RegisterEffect(e1)
	--Negate, Then make material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15658331,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c15658331.discon)
	e2:SetTarget(c15658331.distg)
	e2:SetOperation(c15658331.disop)
	c:RegisterEffect(e2)
	--Special Summon from Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15658331,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetTarget(c15658331.sptg)
	e3:SetOperation(c15658331.spop)
	c:RegisterEffect(e3)
	--To Grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15658331,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c15658331.sgcost)
	e4:SetTarget(c15658331.sgtg)
	e4:SetOperation(c15658331.sgop)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c15658331.winop)
	c:RegisterEffect(e5)
end

function c15658331.uncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c15658331.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c15658331.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.IsChainNegatable(ev)  
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not re:SetCode(15658331)
end
function c15658331.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c15658331.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if re:GetHandler():IsRelateToEffect(re) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
	local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
		Duel.Overlay(c,rc:GetOverlayGroup())end
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
function c15658331.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15658331.mtfilter(c)
	return (c:IsLocation(LOCATION_GRAVE))
end
function c15658331.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c15658331.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c15658331.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c15658331.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c15658331.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local ct=tc.xyz_count
		local og=Duel.SelectMatchingCard(tp,c15658331.mtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.Overlay(tc,og)
	end
end

function c15658331.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.SendtoGrave(c:GetOverlayGroup(),REASON_COST)
end
function c15658331.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c15658331.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SendtoGrave(g,REASON_EFFECT)
end

function c15658331.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_ZOPHIA,_QUEEN_OF_ASCENSION=0x54
	if e:GetHandler():GetOverlayCount()>9 then
		Duel.Win(tp,0x54)
	end
end
