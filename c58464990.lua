--Gaiasaber, the Video Knight
function c58464990.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    local l1=Effect.CreateEffect(c)
	l1:SetDescription(aux.Stringid(52894680,0))
    l1:SetType(EFFECT_TYPE_FIELD)
    l1:SetCode(EFFECT_SPSUMMON_PROC)
    l1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l1:SetTargetRange(POS_FACEUP_ATTACK,0)
    l1:SetRange(LOCATION_EXTRA)
    l1:SetCondition(c58464990.linkcon)
    l1:SetOperation(c58464990.linkop)
    l1:SetValue(0x4f000000)
    c:RegisterEffect(l1)
    --Link Summon with Link Monster
    c:EnableReviveLimit()
    local l2=Effect.CreateEffect(c)
	l2:SetDescription(aux.Stringid(52894680,1))
    l2:SetType(EFFECT_TYPE_FIELD)
    l2:SetCode(EFFECT_SPSUMMON_PROC)
    l2:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l2:SetTargetRange(POS_FACEUP_ATTACK,0)
    l2:SetRange(LOCATION_EXTRA)
    l2:SetCondition(c58464990.linkcon2)
    l2:SetOperation(c58464990.linkop2)
    l2:SetValue(0x4f000000)
    c:RegisterEffect(l2)
	--Keep in Attack Position
	local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(2273734,0))
	l3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	l3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	l3:SetCode(EVENT_SUMMON_SUCCESS)
	l3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	l3:SetTarget(c58464990.atttg)
	l3:SetOperation(c58464990.attop)
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
end

function c58464990.matfilter1(c)
    return (c:IsFaceup() and c:IsType(TYPE_MONSTER)) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c58464990.matfilter2(c)
    return (c:IsFaceup() and c:IsType(TYPE_MONSTER)) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c58464990.linkfilter1(c)
    return c58464990.matfilter1(c) and Duel.IsExistingMatchingCard(c58464990.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c58464990.linkcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c58464990.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c58464990.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c58464990.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c58464990.matfilter2,c:GetControler(),LOCATION_MZONE,0,2,2,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end


function c58464990.matfilter3(c)
    return c:GetBaseDefense()==2 and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c58464990.matfilter4(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_MONSTER)  and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c58464990.linkfilter2(c)
    return c58464990.matfilter3(c) and Duel.IsExistingMatchingCard(c58464990.matfilter4,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c58464990.linkcon2(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c58464990.linkfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c58464990.linkop2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c58464990.linkfilter2,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c58464990.matfilter4,c:GetControler(),LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c58464990.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c58464990.attop(e,tp,eg,ep,ev,re,r,rp)
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
