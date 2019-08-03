--Fairy Guardian Taera
function c67449877.initial_effect(c)
	--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c67449877.spcon)
	c:RegisterEffect(e1)
	--special summon 2 monsters from deck w/downsides
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67449877,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67449877)
	e2:SetCondition(c67449877.spcon2)
	e2:SetCost(c67449877.spcost)
	e2:SetTarget(c67449877.sptg)
	e2:SetOperation(c67449877.spop)
	c:RegisterEffect(e2)
	--Add "Guardian" Spell/Trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67449877,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,67449878)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c67449877.thcon)
	e3:SetCost(c67449877.thcost)
	e3:SetTarget(c67449877.thtg)
	e3:SetOperation(c67449877.thop)
	c:RegisterEffect(e3)
end

function c67449877.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(82)
end
function c67449877.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67449877.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c67449877.spcon2(e,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c67449877.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67449877.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(82) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67449877.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67449877.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c67449877.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67449877.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local t1=g:GetFirst()
		local t2=g:GetNext()
		Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP)
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
			Duel.SpecialSummonStep(t2,0,tp,tp,false,false,POS_FACEUP)
			local e3=e1:Clone()
			t2:RegisterEffect(e3)
			local e4=e2:Clone()
			t2:RegisterEffect(e4)
		end
		Duel.SpecialSummonComplete()
	end
end

function c67449877.thcfilter(c)
	return c:IsFaceup() and (c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS or c:GetType()==TYPE_SPELL+TYPE_EQUIP)
end
function c67449877.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67449877.thcfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c67449877.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c67449877.thfilter(c)
	return c:IsSetCard(82) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c67449877.thfilter2(c)
	return c:IsSetCard(82) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67449877.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67449877.thfilter,tp,LOCATION_DECK,0,1,nil) 
	and Duel.IsExistingMatchingCard(c67449877.thcfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67449877.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67449877.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if Duel.IsExistingMatchingCard(c67449877.thfilter2,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler(tp)) and Duel.SelectYesNo(tp,aux.Stringid(67449877,2))then
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c67449877.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler(tp))
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
end
end
end
