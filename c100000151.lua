--ダーク・フラット・トップ
function c100000151.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	c100000151.tuner_filter=function(mc) return mc and mc:IsSetCard(0x301) end
	c100000151.nontuner_filter=function(mc) return true end
	c100000151.minntct=1
	c100000151.maxntct=1
	c100000151.sync=true
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c100000151.syncon)
	e1:SetOperation(c100000151.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000151,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100000151.target)
	e2:SetOperation(c100000151.activate)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x301)
	c:RegisterEffect(e3)
end
function c100000151.tmatfilter(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c100000151.ntmatfilter(c,syncard)	
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard) and c:IsNotTuner()
end
function c100000151.synfilter1(c,lv,tuner,syncard,pe,tc,ft)
	if c:GetFlagEffect(100000147)==0 then
		return tuner:IsExists(c100000151.synfilter2,1,c,true,lv,c,syncard,pe,tc,ft)
	else
		return tuner:IsExists(c100000151.synfilter2,1,c,false,lv,c,syncard,pe,tc,ft)
	end
end
function c100000151.synfilter2(c,add,lv,nontuner,syncard,pe,tc,ft)
	if ft<=0 and not Group.FromCards(nontuner,c):IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return false end
	if pe and not Group.FromCards(nontuner,c):IsContains(pe:GetOwner()) then return false end
	if tc and not Group.FromCards(nontuner,c):IsContains(tc) then return false end
	if c.tuner_filter and not c.tuner_filter(nontuner) then return false end
	if nontuner.tuner_filter and not nontuner.tuner_filter(c) then return false end
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) and nontuner:IsLocation(LOCATION_HAND) then return false end
	if not nontuner:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsLocation(LOCATION_HAND) then return false end
	if (nontuner:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO)) and c:IsLocation(LOCATION_HAND) 
		and nontuner:IsLocation(LOCATION_HAND) then return false end
	local ntlv=nontuner:GetSynchroLevel(syncard)
	local lv1=bit.band(ntlv,0xffff)
	local lv2=bit.rshift(ntlv,16)
	if add then
		return c:GetSynchroLevel(syncard)==lv+lv1 or c:GetSynchroLevel(syncard)==lv+lv2
	else
		return c:GetSynchroLevel(syncard)==lv-lv1 or c:GetSynchroLevel(syncard)==lv-lv2
	end
end
function c100000151.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local tunerg=Duel.GetMatchingGroup(c100000151.tmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local nontuner=Duel.GetMatchingGroup(c100000151.ntmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	return nontuner:IsExists(c100000151.synfilter1,1,nil,8,tunerg,c,pe,tuner,Duel.GetLocationCount(tp,LOCATION_MZONE))
end
function c100000151.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local tun=Duel.GetMatchingGroup(c100000151.tmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local nont=Duel.GetMatchingGroup(c100000151.ntmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local nontmat=nont:FilterSelect(tp,c100000151.synfilter1,1,1,nil,8,tun,c,pe,tuner,ft)
	local mat1=nontmat:GetFirst()
	g:AddCard(mat1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t
	if mat1:GetFlagEffect(100000147)==0 then
		t=tun:FilterSelect(tp,c100000151.synfilter2,1,1,mat1,true,8,mat1,c,pe,tuner,ft)
	else
		t=tun:FilterSelect(tp,c100000151.synfilter2,1,1,mat1,false,8,mat1,c,pe,tuner,ft)
	end
	g:Merge(t)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c100000151.filter(c,e,tp)
	return c:GetLevel()==8 and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000151.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100000151.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000151.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000151.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000151.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
