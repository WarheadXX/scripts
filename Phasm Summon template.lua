--Swiftblade Shadowstrike Dragon
function c97965070.initial_effect(c)
    --Phasm Summon
    c:EnableReviveLimit()
    local p1=Effect.CreateEffect(c)
    p1:SetType(EFFECT_TYPE_FIELD)
    p1:SetCode(EFFECT_SPSUMMON_PROC)
    p1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	p1:SetTargetRange(POS_FACEUP_ATTACK,0)
    p1:SetRange(LOCATION_EXTRA)
    p1:SetCondition(c97965070.phascon)
    p1:SetOperation(c97965070.phasop)
    p1:SetValue(0x4f000000)
    c:RegisterEffect(p1)
	--Hyper Zone
	local p2=Effect.CreateEffect(c)
	p2:SetType(EFFECT_TYPE_SINGLE)
	p2:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	p2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	p2:SetCondition(c97965070.repcon)
	p2:SetOperation(c97965070.repop)
	c:RegisterEffect(p2)
	--Phasm Type
	local p3=Effect.CreateEffect(c)
	p3:SetCode(EFFECT_CHANGE_TYPE)
	p3:SetType(EFFECT_TYPE_SINGLE)
	p3:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	p3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	p3:SetValue(TYPE_PHASM)
	c:RegisterEffect(p3)
	--To Attack
	local p4=Effect.CreateEffect(c)
	p4:SetDescription(aux.Stringid(2273734,0))
	p4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	p4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	p4:SetCode(EVENT_SUMMON_SUCCESS)
	p4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	p4:SetTarget(c97965070.atttg)
	p4:SetOperation(c97965070.attop)
	c:RegisterEffect(p4)
	local p5=p4:Clone()
	p5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(p5)
	local p6=p4:Clone()
	p6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(p6)
	--Self-Destroy
	local p7=Effect.CreateEffect(c)
	p7:SetType(EFFECT_TYPE_SINGLE)
	p7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	p7:SetRange(LOCATION_MZONE)
	p7:SetCode(EFFECT_SELF_DESTROY)
	p7:SetCondition(c97965070.descon)
	c:RegisterEffect(p7)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23204029,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c97965070.discost)
	e1:SetTarget(c97965070.distg)
	e1:SetOperation(c97965070.disop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

function c97965070.matfilter1(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.matfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.matfilter3(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.phasfilter1(c)
    return c97965070.matfilter1(c) and Duel.IsExistingMatchingCard(c97965070.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c97965070.phascon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c97965070.phasfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function c97965070.phasop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c97965070.phasfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c97965070.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,2,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoHand(g,nil,REASON_MATERIAL+0x100000000)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.SendtoGrave(g2,REASON_COST)
end

function c97965070.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c97965070.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+97965070,e,0,tp,0,0)
end

function c97965070.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function c97965070.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_HYPER)
	c:RegisterEffect(e1)
	--Hyper Summon 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10000001)
	e2:SetCondition(c97965070.hycon1)
	e2:SetOperation(c97965070.hyop)
	e2:SetValue(0x4f0000000)
	c:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTargetRange(POS_FACEUP_ATTACK,0)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c97965070.phascon2)
    e3:SetOperation(c97965070.phasop2)
    e3:SetValue(0x4f000000)
    c:RegisterEffect(e3)
	Duel.RaiseEvent(c,EVENT_CUSTOM+97965070,e,0,tp,0,0)
end

function c97965070.hyfilter1(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_SYNCHRO)
end
function c97965070.hycon1(e,c,tp,chkc)
    return Duel.IsExistingMatchingCard(c97965070.hyfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp)
end
function c97965070.hyfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.hyop(e,tp,eg,ep,ev,re,r,rp,c)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				local tg=nil
				if og then
				tg=og:Filter(tp,c97965070.hyfilter1,nil,e,tp)
				else
					tg=Duel.GetMatchingGroup(c97965070.hyfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
				end
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and (ect<=0 or ect>ft) then ect=nil end
				if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=tg:Select(tp,1,ft,nil)
					g:Merge(g)
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
					Duel.SpecialSummonComplete()
				else
					repeat
						local ct=math.min(ft,ect)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g=tg:Select(tp,1,ct,nil)
						tg:Sub(g)
						sg:Merge(g)
						ft=ft-g:GetCount()
						ect=ect-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					until ft==0 or ect==0 or not Duel.SelectYesNo(tp,210)
					local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
					if ft>0 and ect==0 and hg:GetCount()>0 and Duel.SelectYesNo(tp,210) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g=hg:Select(tp,1,ft,nil)
						g:Merge(g)
						Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
						Duel.SpecialSummonComplete()
					end
				end
end

function c97965070.matfilter1(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.matfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.matfilter3(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function c97965070.phasfilter1(c)
    return c97965070.matfilter1(c) and Duel.IsExistingMatchingCard(c97965070.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c97965070.phascon2(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c97965070.phasfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c97965070.phasop2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,c97965070.phasfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,c97965070.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,2,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoHand(g,nil,REASON_MATERIAL+0x100000000)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.SendtoGrave(g2,REASON_COST)
end


function c97965070.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c97965070.attop(e,tp,eg,ep,ev,re,r,rp)
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

function c97965070.descon(e)
	return e:GetHandler():GetLevel()==0
end

function c97965070.discost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():GetLevel()>0 end
   local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or c:GetLevel()<0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-1)
	c:RegisterEffect(e1)
end
function c97965070.disfilter(c,code)
    return c:IsType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) or c:IsType(FACE_DOWN)
end
function c97965070.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97965070.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c97965070.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c97965070.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		if tc:GetBaseAttack()>=0 and tc:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(97965070,0)) then
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc2=g2:GetFirst()
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_UPDATE_LEVEL)
	    e1:SetReset(RESET_EVENT+0x1fe0000)
	    e1:SetValue(-1)
	    c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e2:SetValue(tc:GetBaseAttack())
		tc2:RegisterEffect(e2)
	end
end
end
