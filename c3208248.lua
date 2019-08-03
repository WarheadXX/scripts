--Wrath of the Divine Sign
function c3208248.initial_effect(c)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c3208248.cost)
	e1:SetTarget(c3208248.target)
	e1:SetOperation(c3208248.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c3208248.reptg)
	e2:SetValue(c3208248.repval)
	e2:SetOperation(c3208248.repop)
	c:RegisterEffect(e2)
end

function c3208248.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c3208248.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c3208248.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,lv)
		and Duel.IsExistingMatchingCard(c3208248.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function c3208248.filter2(c,e,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsCanBeEffectTarget(e)
end
function c3208248.filter3(c)
	return c:IsType(TYPE_XYZ) 
end
function c3208248.spfilter(c,e,tp,lv)
		return c:IsType(TYPE_XYZ) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
function c3208248.spfilter2(c,e,tp,lv,g)
	return c:IsType(TYPE_XYZ) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3208248.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c3208248.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c3208248.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local g1=Duel.SelectMatchingCard(tp,c3208248.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	local lv=g1:GetFirst():GetLevel()
	e:SetLabel(lv)
	local g=Duel.GetMatchingGroup(c3208248.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,lv)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:Select(tp,1,99,nil)
		g1:Merge(sg)
		Duel.SetTargetCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	local g=Duel.SelectMatchingCard(tp,c3208248.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,mg0)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards())
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c3208248.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c3208248.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c3208248.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(3208248,0))
end
function c3208248.repval(e,c)
	return c3208248.repfilter(c,e:GetHandlerPlayer())
end
function c3208248.repop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.Damage(tp,1000,REASON_EFFECT)
end