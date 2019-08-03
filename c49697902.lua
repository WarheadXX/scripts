--Zodiac Dragon
function c49697902.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,5,c49697902.ovfilter,aux.Stringid(49697902,0),5,c49697902.xyzop)
	c:EnableReviveLimit()
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c49697902.damcon)
	e2:SetTarget(c49697902.damtg)
	e2:SetOperation(c49697902.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c49697902.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--immune to spell/trap
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c49697902.efilter)
	c:RegisterEffect(e4)
	--Attach
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c49697902.atccon)
	e5:SetOperation(c49697902.atcop)
	c:RegisterEffect(e5)
	--Immune to monster targeting and destruction
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c49697902.imcon)
	e6:SetValue(c49697902.tgvalue)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(c49697902.tgvalue)
	c:RegisterEffect(e7)
	--Material
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(49697902,1))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_START)
	e8:SetCountLimit(1)
	e8:SetTarget(c49697902.target)
	e8:SetOperation(c49697902.operation)
	c:RegisterEffect(e8)
	--Banish 
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetDescription(aux.Stringid(49697902,2))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c49697902.bancost)
	e9:SetTarget(c49697902.bantg)
	e9:SetOperation(c49697902.banop)
	c:RegisterEffect(e9)
	--ATKup
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EVENT_CHAINING)
	e10:SetRange(LOCATION_MZONE)
	e10:SetOperation(aux.chainreg)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAIN_SOLVED)
	e11:SetCondition(c49697902.atkcon)
	e11:SetOperation(c49697902.atkop)
	c:RegisterEffect(e11)
end

function c49697902.cfilter(c)
	return c:IsSetCard(149) and c:IsType(TYPE_QUICKPLAY) and c:IsDiscardable()
end
function c49697902.ovfilter(c)
	return c:IsFaceup() and c:IsRankAbove(7) and c:IsType(TYPE_XYZ) and (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_FAIRY)) and not c:IsCode(49697902)
end
function c49697902.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49697902.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c49697902.cfilter,1,1,REASON_COST+REASON_DISCARD)
end

function c49697902.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,2,nil,TYPE_XYZ)
end
function c49697902.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c49697902.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c49697902.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

function c49697902.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()then return true end
end

function c49697902.atccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
end
function c49697902.atcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
				Duel.ConfirmCards(tp,g)
				g=g:Filter(Card.IsType,c,TYPE_MONSTER)
			if  g:GetCount()>0 and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) then
				local og=g:GetFirst():GetOverlayGroup()
					if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)end
					Duel.Overlay(c,g)
end
end

function c49697902.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c49697902.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end

function c49697902.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c49697902.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

function c49697902.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c49697902.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsIsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c49697902.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
end

function c49697902.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tpe=re:GetActiveType()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetFlagEffect(1)>0 and Duel.GetTurnPlayer()==tp
end
function c49697902.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end

