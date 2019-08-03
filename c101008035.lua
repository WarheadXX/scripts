--星杯の神子イヴ
--Ib the World Chalice Miko
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	-- aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99,s.matfilter)
	-- aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,99)
	local s1=Effect.CreateEffect(c)
	s1:SetDescription(aux.Stringid(80896940,0))
	s1:SetType(EFFECT_TYPE_FIELD)
	s1:SetCode(EFFECT_SPSUMMON_PROC)
	s1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	s1:SetRange(LOCATION_EXTRA)
	s1:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	s1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	s1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),1,99))
	s1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(s1)
	local s2=s1:Clone()
	s2:SetDescription(aux.Stringid(80896940,1))
	s2:SetCondition(s.syncon)
	s2:SetTarget(s.syntg)
	s2:SetOperation(s.synop)
	s2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(s2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.matfilter(c,scard,sumtype,tp)
	return (c:IsType(TYPE_NORMAL) and c:IsSetCard(0xfd))
end

function s.matfilter1(c,syncard)
	return  (c:IsType(TYPE_NORMAL) and c:IsSetCard(0xfd)) and c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
		and Duel.IsExistingMatchingCard(s.matfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c,syncard)
end
function s.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function s.synfilter(c,syncard,lv,g2,minc)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local g=g2:Clone()
	g:RemoveCard(c)
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,minc-1,63,syncard)
end
function s.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(s.matfilter1,nil,c)
		g2=mg:Filter(s.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		return s.synfilter(tuner,c,lv,g2,minc)
	end
	if not pe then
		return g1:IsExists(s.synfilter,1,nil,c,lv,g2,minc)
	else
		return s.synfilter(pe:GetOwner(),c,lv,g2,minc)
	end
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(s.matfilter1,nil,c)
		g2=mg:Filter(s.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1,minc-1,63,c)
		g:Merge(m2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner=nil
		if not pe then
			local t1=g1:FilterSelect(tp,s.synfilter,1,1,nil,c,lv,g2,minc)
			tuner=t1:GetFirst()
		else
			tuner=pe:GetOwner()
			Group.FromCards(tuner):Select(tp,1,1,nil)
		end
		tuner:RegisterFlagEffect(80896940,RESET_EVENT+0x1fe0000,0,1)
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1,minc-1,63,c)
		g:Merge(m2)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end



function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.thfilter(c)
	return c:IsSetCard(0xfe) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xfd) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end