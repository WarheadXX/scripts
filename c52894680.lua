--Decode Talker
function c52894680.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    local l1=Effect.CreateEffect(c)
	l1:SetDescription(aux.Stringid(52894680,0))
    l1:SetType(EFFECT_TYPE_FIELD)
    l1:SetCode(EFFECT_SPSUMMON_PROC)
    l1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	l1:SetTargetRange(POS_FACEUP_ATTACK,0)
    l1:SetRange(LOCATION_EXTRA)
    l1:SetCondition(c52894680.linkcon)
    l1:SetOperation(c52894680.linkop)
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
    l2:SetCondition(c52894680.linkcon2)
    l2:SetOperation(c52894680.linkop2)
    l2:SetValue(0x4f000000)
    c:RegisterEffect(l2)
	--Keep in Attack Position
	local l3=Effect.CreateEffect(c)
	l3:SetDescription(aux.Stringid(2273734,0))
	l3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	l3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	l3:SetCode(EVENT_SUMMON_SUCCESS)
	l3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	l3:SetTarget(c52894680.atttg)
	l3:SetOperation(c52894680.attop)
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
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c52894680.atkcon)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c52894680.atkcon2)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c52894680.atkcon3)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	 --Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c52894680.ncost)
	e4:SetCondition(c52894680.ncon)
	e4:SetTarget(c52894680.ntg)
	e4:SetOperation(c52894680.nop)
	c:RegisterEffect(e4)
end

function c52894680.matfilter1(c)
    return (c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c52894680.matfilter2(c)
    return (c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)) and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c52894680.linkfilter1(c)
    return c52894680.matfilter1(c) and Duel.IsExistingMatchingCard(c52894680.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c52894680.linkcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c52894680.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c52894680.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c52894680.linkfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c52894680.matfilter2,c:GetControler(),LOCATION_MZONE,0,2,2,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end


function c52894680.matfilter3(c)
    return c:GetBaseDefense()==2 and c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c52894680.matfilter4(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)  and (c:GetBaseDefense()~=2 and c:GetBaseDefense()~=3 and c:GetBaseDefense()~=4)
end
function c52894680.linkfilter2(c)
    return c52894680.matfilter3(c) and Duel.IsExistingMatchingCard(c52894680.matfilter4,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c52894680.linkcon2(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c52894680.linkfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c52894680.linkop2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c52894680.linkfilter2,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c52894680.matfilter4,c:GetControler(),LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,nil,REASON_MATERIAL+0x100000000)
end

function c52894680.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c52894680.attop(e,tp,eg,ep,ev,re,r,rp)
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

function c52894680.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c52894680.discon(e)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,2,nil)
end
function c52894680.discon2(e)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,LOCATION_MZONE,0,3,nil)
end


function c52894680.drfilter(c,tp,e)
	return c:IsControler(1-tp) and Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-c:GetSequence()) 
end
function c52894680.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c52894680.drfilter,1,nil,tp)
end
function c52894680.drfilter2(c,tp,e)
	return c:IsControler(tp) and (Duel.GetFieldCard(tp,LOCATION_SZONE,3-c:GetSequence()) or Duel.GetFieldCard(tp,LOCATION_SZONE,5-c:GetSequence())) 
end
function c52894680.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c52894680.drfilter,1,nil,tp)
end
function c52894680.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-e:GetHandler():GetSequence()) 
end
function c52894680.desop(e,tp,eg,ep,ev,re,r,rp)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(500)
	c:RegisterEffect(e1)
end


function c52894680.atkfil(c,tp,e)
	return c:GetSequence()==seq
end
function c52894680.atkfil2(c,tp,e)
	return Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()+1)
end
function c52894680.atkfil3(c,tp,e)
	return Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()-1)
end
function c52894680.indtg(e,c)
	return (Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()))
end
function c52894680.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local p=1-e:GetHandlerPlayer()
	local seq=4-e:GetHandler():GetSequence()
	return Duel.GetFieldCard(p,LOCATION_MZONE,seq)~=nil
end
function c52894680.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(p,LOCATION_SZONE,seq+1)
end
function c52894680.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(p,LOCATION_SZONE,seq-1)
end

function c52894680.cfilter(c)
	return c:IsControler(tp)
end
function c52894680.ncon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and c52894680.cfilter(tg:GetFirst()) and Duel.IsChainNegatable(ev)
end
function c52894680.costfilter(e,tp,eg,ep,ev,re,r,rp,chk,c)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()+1) or Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()-1)
end
function c52894680.ncost(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then
		local sel=0
		if Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()+1) then sel=sel+1 end
		if Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()-1) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(52894680,2),aux.Stringid(52894680,3))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(52894680,2))
	else
		Duel.SelectOption(tp,aux.Stringid(52894680,3))
	end
	e:SetLabel(sel)
	if sel==1 then
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()+1)
	else
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()-1)
	end
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()+1)
		Duel.SendtoGrave(tc,REASON_COST)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,e:GetHandler():GetSequence()-1)
	    Duel.SendtoGrave(tc,REASON_COST)
end
end
function c52894680.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c52894680.nop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c52894680.efilter(e,te)
	return e:IsHasType(EFFECT_UPDATE_DEFENSE)
end

