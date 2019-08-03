  --Rune Summon
    c:EnableReviveLimit()
    local r1=Effect.CreateEffect(c)
    r1:SetType(EFFECT_TYPE_FIELD)
    r1:SetCode(EFFECT_SPSUMMON_PROC)
    r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    r1:SetRange(LOCATION_EXTRA)
    r1:SetCondition(cxxxxxxxx.runcon)
    r1:SetOperation(cxxxxxxxx.runop)
    r1:SetValue(0x4f000000)
    c:RegisterEffect(r1)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Make Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--Make Ritual
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e2)
	--Make Xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_XYZ)
	c:RegisterEffect(e3)
	--Rune or Pendulum Zones
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCountLimit(1)
	e4:SetTarget(cxxxxxxxx.ztg)
	e4:SetOperation(cxxxxxxxx.zop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e6)
end
	
function cxxxxxxxx.matfilter1(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function cxxxxxxxx.matfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function cxxxxxxxx.matfilter3(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function cxxxxxxxx.runfilter1(c)
    return cxxxxxxxx.matfilter1(c) and Duel.IsExistingMatchingCard(cxxxxxxxx.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function cxxxxxxxx.runcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(cxxxxxxxx.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not c:IsFaceup()
end
function cxxxxxxxx.runop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Group.CreateGroup()
    local g1=Duel.SelectMatchingCard(tp,cxxxxxxxx.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
    g:Merge(g1)
    local g2=Duel.SelectMatchingCard(tp,cxxxxxxxx.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,2,g1:GetFirst(),c)
    g:Merge(g2)
    c:SetMaterial(g)
    Duel.SendtoHand(g,nil,REASON_MATERIAL+0x100000000)
end

function cxxxxxxxx.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) or Duel.CheckLocation(tp,LOCATION_SZONE,1) or Duel.CheckLocation(tp,LOCATION_SZONE,2)end
end
function cxxxxxxxx.zop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7)then return false end
	local c=e:GetHandler()
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	local b2=cxxxxxxxx.rzcon
	if b1 or b2 then
		op=Duel.SelectOption(tp,aux.Stringid(xxxxxxxx,0),aux.Stringid(xxxxxxxx,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		Duel.SendtoExtraP(c,tp,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCountLimit(1,10000001)
		e1:SetCondition(cxxxxxxxx.rzcon1)
		e1:SetOperation(cxxxxxxxx.rzop)
		e1:SetValue(0x4f0000000)
		c:RegisterEffect(e1)
	elseif op==1 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SendtoExtraP(c,tp,REASON_EFFECT)
	end
end
end

function cxxxxxxxx.rzcon(e,c)
    return c:IsFaceup()
end

function cxxxxxxxx.rzfilter1(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_SYNCHRO)
end
function cxxxxxxxx.rzcon1(e,c,tp,chkc)
    return Duel.IsExistingMatchingCard(cxxxxxxxx.rzfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp)
end
function cxxxxxxxx.rzfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4
end
function cxxxxxxxx.rzop(e,tp,eg,ep,ev,re,r,rp,c)
   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				local tg=nil
				if og then
				tg=og:Filter(tp,cxxxxxxxx.rzfilter1,nil,e,tp)
				else
					tg=Duel.GetMatchingGroup(cxxxxxxxx.rzfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
				end
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and (ect<=0 or ect>ft) then ect=nil end
				if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=tg:Select(tp,1,ft,nil)
					g:Merge(g)
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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
					end
				end
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
end
			