--RUM Transcendence Force*
function c93397988.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c93397988.cost)
	e1:SetTarget(c93397988.target)
	e1:SetOperation(c93397988.activate)
	c:RegisterEffect(e1)
	--RANK UP FROM BEYOND
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c93397988.cost2)
	e2:SetTarget(c93397988.tg2)
	e2:SetOperation(c93397988.act2)
	c:RegisterEffect(e2)
end
function c93397988.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c93397988.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c93397988.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,lv)
		and Duel.IsExistingMatchingCard(c93397988.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function c93397988.filter2(c,e,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsCanBeEffectTarget(e)
end
function c93397988.filter3(c)
	return c:IsType(TYPE_XYZ) 
end
function c93397988.spfilter(c,e,tp,lv)
		return c:IsType(TYPE_XYZ) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
function c93397988.spfilter2(c,e,tp,lv,g)
	return c:IsType(TYPE_XYZ) and c:GetRank()==lv and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93397988.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c93397988.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c93397988.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	local lv=g1:GetFirst():GetLevel()
	e:SetLabel(lv)
	local g=Duel.GetMatchingGroup(c93397988.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,lv)
	g:Sub(g1)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(93397988,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,99,nil)
		Duel.SetTargetCard(sg)
		g1:Merge(sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c93397988.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93397988.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,mg0)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(sc))
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c93397988.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c93397988.rumfilter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and Duel.IsExistingMatchingCard(c93397988.rumfilter2,tp,LOCATION_EXTRA,0,1,nil,rk+1,e,tp,c:GetCode())
end
function c93397988.rumfilter2(c,rk,e,tp,code)
    if c:IsCode(6165656) and code~=48995978 then return false end
	return c:IsType(TYPE_XYZ) and (c:GetRank()==rk or c:GetRank()==rk+1) and c:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c93397988.rumfilter3(c,rk)
	return c:IsFaceup() and c:GetRank()>rk
end
function c93397988.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c93397988.rumfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c93397988.rumfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c93397988.rumfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c93397988.act2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93397988.rumfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank()+1,e,tp,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

