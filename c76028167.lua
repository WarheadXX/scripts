--Link Spider
function c76028167.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    local l1=Effect.CreateEffect(c)
	l1:SetDescription(aux.Stringid(32129317,0))
    l1:SetType(EFFECT_TYPE_FIELD)
    l1:SetCode(EFFECT_SPSUMMON_PROC)
    l1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l1:SetTargetRange(POS_FACEUP_ATTACK,0)
    l1:SetRange(LOCATION_EXTRA)
    l1:SetCondition(c76028167.linkcon)
    l1:SetOperation(c76028167.linkop)
    l1:SetValue(0x4f000001)
	c:RegisterEffect(l1)
	--Keep in Attack Position
	local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(2273734,0))
	l3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	l3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	l3:SetCode(EVENT_SUMMON_SUCCESS)
	l3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	l3:SetTarget(c76028167.atttg)
	l3:SetOperation(c76028167.attop)
	c:RegisterEffect(l3)
	local l4=l3:Clone()
	l4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(l4)
	local l5=l3:Clone()
	l5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(l5)
	--Cannot be in Defense Position
	local l6=Effect.CreateEffect(c)
	l6:SetType(EFFECT_TYPE_SINGLE)
	l6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	l6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	l6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(l6)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10591919,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c76028167.spcon)
	e1:SetTarget(c76028167.tga)
	e1:SetOperation(c76028167.opa)
	c:RegisterEffect(e1)
end

function c76028167.matfilter1(c)
    return c:IsType(TYPE_NORMAL)
	and c:IsFaceup() and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c76028167.linkfilter1(c)
    return Duel.IsExistingMatchingCard(c76028167.matfilter1,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c76028167.linkcon(e,c)
	 if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c76028167.matfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c76028167.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectMatchingCard(tp,c76028167.matfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c76028167.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c76028167.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsDefensePos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
	end
end

function c76028167.ctfilter(c,seq)
	return c:IsType(TYPE_MONSTER) and c:GetSequence()==seq
end
function c76028167.spcon(e)
	local p=e:GetHandlerPlayer()
	local seq=e:GetHandler():GetSequence()
	return Duel.IsExistingMatchingCard(c76028167.ctfilter,p,LOCATION_MZONE,0,1,nil,seq-1)
end
function c76028167.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76028167.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c76028167.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c76028167.opa(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
	and not Duel.IsExistingMatchingCard(c76028167.ctfilter,tp,LOCATION_MZONE,0,1,e:GetHandler():GetSequence()-1) then return end
	local seq=e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76028167.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
