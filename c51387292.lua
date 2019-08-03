--Firewall Dragon
function c51387292.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    local l1=Effect.CreateEffect(c)
	l1:SetDescription(aux.Stringid(51387292,0))
    l1:SetType(EFFECT_TYPE_FIELD)
    l1:SetCode(EFFECT_SPSUMMON_PROC)
    l1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l1:SetTargetRange(POS_FACEUP_ATTACK,0)
    l1:SetRange(LOCATION_EXTRA)
    l1:SetCondition(c51387292.linkcon)
    l1:SetOperation(c51387292.linkop)
    l1:SetValue(0x4f000000)
    c:RegisterEffect(l1)
    --Link Summon with Link Monster
    c:EnableReviveLimit()
    local l2=Effect.CreateEffect(c)
	l2:SetDescription(aux.Stringid(51387292,1))
    l2:SetType(EFFECT_TYPE_FIELD)
    l2:SetCode(EFFECT_SPSUMMON_PROC)
    l2:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l2:SetTargetRange(POS_FACEUP_ATTACK,0)
    l2:SetRange(LOCATION_EXTRA)
    l2:SetCondition(c51387292.linkcon2)
    l2:SetOperation(c51387292.linkop2)
    l2:SetValue(0x4f000000)
    c:RegisterEffect(l2)
	--Link Summon with 2 Link 2
    c:EnableReviveLimit()
    local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(51387292,2))
    l3:SetType(EFFECT_TYPE_FIELD)
    l3:SetCode(EFFECT_SPSUMMON_PROC)
    l3:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l3:SetTargetRange(POS_FACEUP_ATTACK,0)
    l3:SetRange(LOCATION_EXTRA)
    l3:SetCondition(c51387292.linkcon3)
    l3:SetOperation(c51387292.linkop3)
    l3:SetValue(0x4f000000)
    c:RegisterEffect(l3)
	--Link Summon with Link 3
    c:EnableReviveLimit()
    local l4=Effect.CreateEffect(c)
	l4:SetDescription(aux.Stringid(51387292,3))
    l4:SetType(EFFECT_TYPE_FIELD)
    l4:SetCode(EFFECT_SPSUMMON_PROC)
    l4:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l4:SetTargetRange(POS_FACEUP_ATTACK,0)
    l4:SetRange(LOCATION_EXTRA)
    l4:SetCondition(c51387292.linkcon4)
    l4:SetOperation(c51387292.linkop4)
    l4:SetValue(0x4f000000)
    c:RegisterEffect(l4)
	--Keep in Attack Position
	local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(2273734,0))
	l3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	l3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	l3:SetCode(EVENT_SUMMON_SUCCESS)
	l3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	l3:SetTarget(c51387292.atttg)
	l3:SetOperation(c51387292.attop)
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
	--cannot be target
	local l7=Effect.CreateEffect(c)
	l7:SetType(EFFECT_TYPE_SINGLE)
	l7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	l7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	l7:SetRange(LOCATION_MZONE)
	l7:SetValue(c51387292.efilter)
	c:RegisterEffect(l7)
	--special summon
	local t1=Effect.CreateEffect(c)
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_SPSUMMON_PROC)
	t1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	t1:SetRange(LOCATION_EXTRA)
	t1:SetTargetRange(POS_FACEUP_ATTACK,0)
	c:RegisterEffect(t1)
	-- Bounce to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39188539,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c51387292.thcon)
	e1:SetTarget(c51387292.thtg)
	e1:SetOperation(c51387292.thop)
	c:RegisterEffect(e1)
	--Special Summon from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51387292,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c51387292.spcon)
	e2:SetTarget(c51387292.sptg)
	e2:SetOperation(c51387292.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c51387292.spcon2)
	c:RegisterEffect(e3)
end

function c51387292.matfilter1(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c51387292.matfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c51387292.linkfilter1(c)
    return c51387292.matfilter1(c) and Duel.IsExistingMatchingCard(c51387292.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,3,c)
end
function c51387292.linkcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c51387292.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c51387292.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c51387292.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c51387292.matfilter2,c:GetControler(),LOCATION_MZONE,0,3,3,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end


function c51387292.matfilter3(c)
    return c:GetBaseDefense()==2 and c:IsFaceup()
end
function c51387292.matfilter4(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c51387292.linkfilter2(c)
    return c51387292.matfilter3(c) and Duel.IsExistingMatchingCard(c51387292.matfilter4,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c51387292.linkcon2(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c51387292.linkfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c51387292.linkop2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c51387292.linkfilter2,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c51387292.matfilter4,c:GetControler(),LOCATION_MZONE,0,2,2,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end


function c51387292.matfilter5(c)
    return c:IsFaceup() and c:GetBaseDefense()==2
end
function c51387292.matfilter6(c)
    return c:IsFaceup() and c:GetBaseDefense()==2
end
function c51387292.linkfilter3(c)
    return c51387292.matfilter5(c) and Duel.IsExistingMatchingCard(c51387292.matfilter6,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c51387292.linkcon3(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c51387292.linkfilter3,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c51387292.linkop3(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c51387292.linkfilter3,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c51387292.matfilter6,c:GetControler(),LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c51387292.matfilter7(c)
    return c:IsFaceup() and c:GetBaseDefense()==3
end
function c51387292.matfilter8(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)  and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c51387292.linkfilter4(c)
    return c51387292.matfilter7(c) and Duel.IsExistingMatchingCard(c51387292.matfilter8,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c51387292.linkcon4(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c51387292.linkfilter4,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c51387292.linkop4(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c51387292.linkfilter4,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c51387292.matfilter8,c:GetControler(),LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c51387292.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c51387292.attop(e,tp,eg,ep,ev,re,r,rp)
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

function c51387292.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c51387292.discon(e)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,2,nil)
end
function c51387292.discon2(e)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,LOCATION_MZONE,0,3,nil)
end

function c51387292.efilter(e,re,rp)
	return re:GetHandler():IsCode(14087893)
end

function c51387292.ctfilter(c,e)
	return c:IsCode(51387292) or c:IsCode(32129317) or c:IsCode(52894680) or c:IsCode(895727) or c:IsCode(58464990) or c:IsCode(76028167)
end
function c51387292.ctfilter2(c,e)
	return c:IsType(TYPE_MONSTER)
end
function c51387292.ctfilter3(c,e)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c51387292.cfilter(c,seq)
	return c:IsFaceup() and (c:IsCode(32129317) or c:IsCode(51387292) or c:IsCode(58464990) or c:IsCode(76028167)) and c:GetSequence()==seq
end
function c51387292.cfilter2(c,seq)
	return (c:IsCode(52894680) or  c:IsCode(51387292)) and c:GetSequence()==seq
end
function c51387292.cfilter3(c,seq)
	return c:IsFaceup() and (c:IsCode(32129317) or c:IsCode(51387292) or c:IsCode(58464990)) and c:GetSequence()==seq
end
function c51387292.thcon(e)
	local p=1-e:GetHandlerPlayer()
	return (Duel.IsExistingMatchingCard(c51387292.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()+1) or Duel.IsExistingMatchingCard(c51387292.cfilter3,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()-1) 
	or Duel.IsExistingMatchingCard(c51387292.cfilter2,p,LOCATION_MZONE,0,1,nil,4-e:GetHandler():GetSequence()))
end
function c51387292.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return  Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c51387292.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ct>3 then
	local g=Duel.SelectTarget(tp,c51387292.ctfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,3,nil) end
	if ct<4 then
	local g=Duel.SelectTarget(tp,c51387292.ctfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
end
function c51387292.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c51387292.filter(c,tp)
    return c:IsReason(REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c51387292.filter2(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c51387292.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51387292.filter,1,nil,tp) and (Duel.IsExistingMatchingCard(c51387292.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()+1) or Duel.IsExistingMatchingCard(c51387292.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()-1) 
	or Duel.IsExistingMatchingCard(c51387292.cfilter2,p,0,LOCATION_MZONE,1,nil,4-e:GetHandler():GetSequence()) or Duel.IsExistingMatchingCard(c51387292.cfilter,tp,LOCATION_SZONE,0,1,nil,e:GetHandler():GetSequence()))
end
function c51387292.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51387292.filter2,1,nil,tp) and (Duel.IsExistingMatchingCard(c51387292.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()+1) or Duel.IsExistingMatchingCard(c51387292.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()-1) 
	or Duel.IsExistingMatchingCard(c51387292.cfilter2,p,0,LOCATION_MZONE,1,nil,4-e:GetHandler():GetSequence()) or Duel.IsExistingMatchingCard(c51387292.ctfilter3,tp,LOCATION_SZONE,0,1,nil,e:GetHandler():GetSequence()))
end
function c51387292.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51387292.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c51387292.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51387292.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c51387292.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end