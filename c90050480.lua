--E HERO コズモ・ネオス
--Elemental HERO Cosmo Neos
--Scripted by AlphaKretin
function c90050480.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	-- aux.AddFusionProcMixN(c,false,false,89943723,1,c90050480.ffilter,3)
	-- aux.AddContactFusion(c,c90050480.contactfil,c90050480.contactop,c90050480.splimit)
	--WarheadXX Revisionist History
	local f1=Effect.CreateEffect(c)
	f1:SetType(EFFECT_TYPE_FIELD)
	f1:SetCode(EFFECT_SPSUMMON_PROC)
	f1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	f1:SetRange(LOCATION_EXTRA)
	f1:SetCondition(c90050480.contactcon)
	f1:SetOperation(c90050480.contactop2)
	c:RegisterEffect(f1)
	--no activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90050480,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c90050480.nacon)
	e1:SetTarget(c90050480.natg)
	e1:SetOperation(c90050480.naop)
	c:RegisterEffect(e1)
	--neos return
	-- aux.EnableNeosReturn(c,CATEGORY_DESTROY,c90050480.desinfo,c90050480.desop)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(48996569,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c90050480.retcon1)
	e5:SetTarget(c90050480.rettg)
	e5:SetOperation(c90050480.retop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(0)
	e6:SetCondition(c90050480.retcon2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(48996569,0))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c90050480.retcon1)
	e7:SetTarget(c90050480.rettg)
	e7:SetOperation(c90050480.retop)
	c:RegisterEffect(e7)
	-- new neos return effect
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(90050480,2))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_CUSTOM+90050480)
	e8:SetTarget(c90050480.desinfo)
	e8:SetOperation(c90050480.desop)
	c:RegisterEffect(e8)
end
c90050480.listed_names={89943723}
c90050480.material_setcode={0x8,0x3008,0x9,0x1f}
function c90050480.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsFusionSetCard(0x1f)  and (c:GetAttribute(fc,sumtype,tp)~=0) and (not sg or not sg:IsExists(c90050480.fusfilter,1,c,c:GetAttribute(fc,sumtype,tp),fc,sumtype,tp))
end
function c90050480.fusfilter(c,attr,fc,sumtype,tp)
	return c:IsFusionSetCard(0x1f) and c:IsAttribute(attr,fc,sumtype,tp) and not c:IsHasEffect(511002961)
end
function c90050480.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c90050480.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function c90050480.fffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:GetCode(89943723)
end
function c90050480.ffffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x1f) or c:GetCode(89943723)
end
function c90050480.contactcon(c,tp)
    local g=Duel.GetMatchingGroup(c90050480.ffffilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end
function c90050480.contactop2(g,tp)
 -- local rg=Duel.GetMatchingGroup(c41933425.ffilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
    local rg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(c90050480.ffffilter,tp,LOCATION_MZONE,0,nil)
	-- local g2=Duel.SelectMatchingCard(tp,c90050480.fffilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	-- local tc2=g2:GetFirst()
	for i=1,1 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
		local tc2=g:Select(tp,1,1,nil):GetFirst()
		if tc2 then
			rg:AddCard(tc2)
			g:Remove(Card.IsCode,nil,tc2:GetCode())
		end
		local tc3=g:Select(tp,1,1,nil):GetFirst()
		if tc3 then
			rg:AddCard(tc3)
			g:Remove(Card.IsCode,nil,tc3:GetCode())
		end
		local tc4=g:Select(tp,1,1,nil):GetFirst()
		if tc4 then
			rg:AddCard(tc4)
			g:Remove(Card.IsCode,nil,tc4:GetCode())
		end
	end
	-- rg:AddCard(tc2)
	Duel.ConfirmCards(1-tp,rg)
	Duel.SendtoDeck(rg,nil,4,REASON_COST+REASON_MATERIAL)
end
function c90050480.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c90050480.nacon(e)
	return e:GetHandler():GetSummonLocation() and LOCATION_EXTRA==LOCATION_EXTRA
end
function c90050480.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c90050480.chainlm)
end
function c90050480.chainlm(e,rp,tp)
	return tp==rp
end
function c90050480.naop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c90050480.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90050480.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end
function c90050480.desinfo(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c90050480.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c90050480.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(42015635)
end
function c90050480.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
function c90050480.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c90050480.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	if Duel.IsExistingMatchingCard(NeosFusion,tp,LOCATION_GRAVE,0,1,nil) then 
	local g=Duel.GetMatchingGroup(NeosFusion,tp,LOCATION_GRAVE,0,nil)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		return Duel.Remove(g:GetFirst(),POS_FACEUP,REASON_EFFECT)
	else
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) then
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	  end
	end
 end
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) then 
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
  end
end
function c90050480.retcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
