--破械神の禍霊
--Hakaishin no Magatama
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)
    --link summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id)
    --e2:AddHakaiLinkEffect(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e2:SetTarget(aux.HakaiTarget)
	e2:SetOperation(aux.HakaiOperation)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,id+100)
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end
s.listed_series={0x230}
----------
function s.exfilter(c,mg,lr)
	return c:IsType(TYPE_LINK)  and c:IsAttribute(ATTRIBUTE_DARK) and (c:GetLink()<=(lr + 1)) --and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function s.matfilter(c,mg,lc)
	return c:IsFaceup() --and c:IsCanBeLinkMaterial(lc)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local oc=e:GetHandler()
	--local lc=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
    local mg=Duel.GetMatchingGroup(s.matfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	mg:AddCard(oc)
	local lr=1
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,mg,lr) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local oc=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	local tc1=Duel.SelectTarget(tp,s.matfilter,tp,0,LOCATION_MZONE,1,1,nil,mg)
	mg:AddCard(oc)
	local fg=Group.CreateGroup()
	fg:AddCard(oc)
	fg:AddCard(tc1:GetFirst())
	--local lr=(oc:GetLink() + tc1:GetFirst():GetLink())
	local lr=1
	local lr2=0
	if tc1:GetFirst():IsType(TYPE_LINK) then lr2=tc1:GetFirst():GetLink() lr=(1+lr2) end
	Duel.SendtoGrave(fg,REASON_MATERIAL+REASON_RULE)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg,lr)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
----------
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x230)*300
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c,e,tp)
    return c:IsSetCard(0x230) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
