--Brave Protectors of the Imperial Tombs
function c73821767.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c73821767.actcon)
	e1:SetTarget(c73821767.target)
	e1:SetOperation(c73821767.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c73821767.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2e)
end
function c73821767.cfilter2(c)
	return c:IsFaceup() and c:IsCode(47355498)
end
function c73821767.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c73821767.cfilter1,tp,LOCATION_MZONE,1,1,nil)
		and (Duel.IsExistingMatchingCard(c73821767.cfilter2,tp,LOCATION_ONFIELD,1,1,nil)
		or Duel.IsEnvironment(47355498))
end
function c73821767.filter(c,tp)
	return c:IsAttackPos()
end
function c73821767.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2e)
end
function c73821767.filter3(c,tp)
	return c:GetSummonPlayer()==tp
end
function c73821767.sfilter(c)
	return c:IsSetCard(145) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c73821767.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73821767.filter,tp,0,LOCATION_MZONE,1,nil) and
	eg:IsExists(c73821767.filter3,1,nil,1-tp)end
	local g=Duel.GetMatchingGroup(c73821767.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_SENDTOGRAVE,g,g:GetCount(),0,0)
end
function c73821767.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c73821767.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c73821767.filter2,tp,LOCATION_MZONE,3,3,nil,e:GetHandler(tp)) 
	and Duel.SelectYesNo(tp,aux.Stringid(73821767,0)) then
	local g=Duel.SelectMatchingCard(tp,c73821767.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)	
end
end
end
