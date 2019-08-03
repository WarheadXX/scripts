--The Power of Good&Evil Unleashed!!!
function c24709767.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c24709767.target)
	e1:SetOperation(c24709767.activate)
	c:RegisterEffect(e1)
	--Material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24709767,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c24709767.target2)
	e2:SetOperation(c24709767.operation2)
	c:RegisterEffect(e2)
	if not c24709767.global_check then
		c24709767.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,24709767))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
end
end

function c24709767.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c24709767.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,rk)
		and Duel.IsExistingMatchingCard(c24709767.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk)
end
function c24709767.filter2(c,e,rk)
	return c:IsType(TYPE_XYZ)
end
function c24709767.filter3(c)
	return c:IsType(TYPE_XYZ)
end
function c24709767.spfilter(c,e,tp,rk)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(10509545)
	end
function c24709767.spfilter2(c,e,tp,rk,g) 
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsCode(10509545)
	end
function c24709767.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c24709767.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.GetMatchingGroup(c24709767.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,rk)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,99,nil)
		Duel.SetTargetCard(sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24709767.activate(e,tp,eg,ep,ev,re,r,rp)
	local rk=e:GetLabel()
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24709767.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk,mg0)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(sc))
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c24709767.mtfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c24709767.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c24709767.mtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24709767.mtfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c70263801.mtfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c24709767.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end