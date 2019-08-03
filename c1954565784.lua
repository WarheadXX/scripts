--Linking Magician
--Scripted by WarheadXX
function c1954565784.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,3)
	--POP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1954565784,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1954565783)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1954565784.setcon)
	e1:SetTarget(c1954565784.settg)
	e1:SetOperation(c1954565784.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local t1=Effect.CreateEffect(c)
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_SPSUMMON_PROC)
	t1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	t1:SetRange(LOCATION_EXTRA)
	t1:SetTargetRange(POS_FACEUP_ATTACK,0)
	c:RegisterEffect(t1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c1954565784.spcon)
	e3:SetTarget(c1954565784.sptg)
	e3:SetOperation(c1954565784.spop)
	c:RegisterEffect(e3)
end
function c1954565784.setcfilter(c,tp,lg)
	return c:IsFaceup() and c:IsControler(tp) and (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WARRIOR)) and lg:IsContains(c)
end
function c1954565784.setcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c1954565784.setcfilter,1,nil,tp,lg)
end
function c1954565784.desfilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c1954565784.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c1954565784.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1954565784.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1954565784.setop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.SelectMatchingCard(tp,c1954565784.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c1954565784.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0
end
function c1954565784.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(1954565784)
end
function c1954565784.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1954565784.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1954565784.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1954565784.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

