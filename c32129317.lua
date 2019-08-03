--Honeybot
function c32129317.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    local l1=Effect.CreateEffect(c)
	l1:SetDescription(aux.Stringid(32129317,0))
    l1:SetType(EFFECT_TYPE_FIELD)
    l1:SetCode(EFFECT_SPSUMMON_PROC)
    l1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l1:SetTargetRange(POS_FACEUP_ATTACK,0)
    l1:SetRange(LOCATION_EXTRA)
    l1:SetCondition(c32129317.linkcon)
    l1:SetOperation(c32129317.linkop)
    l1:SetValue(0x4f000001)
    c:RegisterEffect(l1)
	--Link Type
	local l2=Effect.CreateEffect(c)
	l2:SetCode(EFFECT_CHANGE_TYPE)
	l2:SetType(EFFECT_TYPE_SINGLE)
	l2:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	l2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	l2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	c:RegisterEffect(l2)
	--Keep in Attack Position
	local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(2273734,0))
	l3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	l3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	l3:SetCode(EVENT_SUMMON_SUCCESS)
	l3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	l3:SetTarget(c32129317.atttg)
	l3:SetOperation(c32129317.attop)
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
	--cannot be target/battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c32129317.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e2)
end

function c32129317.matfilter1(c)
    return c:IsRace(268435456)
	and c:IsFaceup() and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c32129317.matfilter2(c)
   return c:IsRace(268435456)
	and c:IsFaceup() and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c32129317.linkfilter1(c)
    return c32129317.matfilter1(c) and Duel.IsExistingMatchingCard(c32129317.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c32129317.linkcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c32129317.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c32129317.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c32129317.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c32129317.matfilter2,c:GetControler(),LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c32129317.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c32129317.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsDefensePos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
	end
end

function c32129317.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c32129317.discon(e)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,2,nil)
end
function c32129317.discon2(e)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,LOCATION_MZONE,0,3,nil)
end



function c32129317.indfilter(c,tp,e)
	return Duel.GetFieldCard(tp,LOCATION_MZONE,4-c:GetSequence()+1)
end
function c32129317.indfilter2(c,tp,e)
	return Duel.GetFieldCard(tp,LOCATION_MZONE,4-c:GetSequence()-1)
end
function c32129317.indcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(c32129317.indfilter,tp,LOCATION_MZONE,1,nil)) or (Duel.IsExistingMatchingCard(c32129317.indfilter2,tp,LOCATION_MZONE,1,nil))
end
function c32129317.indtg(e,c)
	return (c==Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetHandler():GetSequence()+1)) or (c==Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetHandler():GetSequence()-1))
end

function c32129317.drfilter(c,tp,e)
	return c:IsControler(tp) and (Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()-1) or Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()+1)) 
end
function c32129317.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32129317.drfilter,1,nil,tp)
end
function c32129317.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc1=Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetHandler():GetSequence()-1)
	local tc2=Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetHandler():GetSequence()+1)
end
function c32129317.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local tc1=Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetHandler():GetSequence()+1)
	if tc1 then g:AddCard(tc1) end
	tc2=Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetHandler():GetSequence()-1)
	if tc2 then g:AddCard(tc2) end
	local t1=g:GetFirst()
	local t2=g:GetNext()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OWNER_RELATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c32129317.valcon)
	e1:SetCondition(c32129317.ctcon)
	e1:SetLabel(0)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	t1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(1)
	e2:SetCondition(c32129317.ctcon)
	t1:RegisterEffect(e2)
	if t2 then
	local e3=e1:Clone()
	t2:RegisterEffect(e3)
	local e4=e2:Clone()
	t2:RegisterEffect(e4)
end
end

function c32129317.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)
end
function c32129317.cfilter(c,seq)
	return c:IsFaceup() and c:IsCode(32129317) and c:GetSequence()==seq
end
function c32129317.ctcon(e)
	return Duel.IsExistingMatchingCard(c32129317.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()+1) or Duel.IsExistingMatchingCard(c32129317.cfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence()-1)
end
