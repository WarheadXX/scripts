--Missus Radiant
function c895727.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    local l1=Effect.CreateEffect(c)
	l1:SetDescription(aux.Stringid(32129317,0))
    l1:SetType(EFFECT_TYPE_FIELD)
    l1:SetCode(EFFECT_SPSUMMON_PROC)
    l1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l1:SetTargetRange(POS_FACEUP_ATTACK,0)
    l1:SetRange(LOCATION_EXTRA)
    l1:SetCondition(c895727.linkcon)
    l1:SetOperation(c895727.linkop)
    l1:SetValue(0x4f000001)
    c:RegisterEffect(l1)
	--Keep in Attack Position
	local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(2273734,0))
	l3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	l3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	l3:SetCode(EVENT_SUMMON_SUCCESS)
	l3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	l3:SetTarget(c895727.atttg)
	l3:SetOperation(c895727.attop)
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
	--Add and Subtract
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(c895727.tg1)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(c895727.tg2)
	e2:SetValue(-400)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,895727)
	e3:SetCondition(c895727.thcon)
	e3:SetTarget(c895727.thtg)
	e3:SetOperation(c895727.thop)
	c:RegisterEffect(e3)
end

function c895727.matfilter1(c)
    return c:IsAttribute(ATTRIBUTE_EARTH)
	and c:IsFaceup() and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c895727.matfilter2(c)
   return c:IsAttribute(ATTRIBUTE_EARTH)
	and c:IsFaceup() and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c895727.linkfilter1(c)
    return c895727.matfilter1(c) and Duel.IsExistingMatchingCard(c895727.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c895727.linkcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c895727.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c895727.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c895727.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c895727.matfilter2,c:GetControler(),LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c895727.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c895727.attop(e,tp,eg,ep,ev,re,r,rp)
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

function c895727.tg1(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c895727.tg2(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end

function c895727.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c895727.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c895727.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c895727.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c895727.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c895727.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end