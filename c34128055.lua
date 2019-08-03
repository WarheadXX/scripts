--Dark-Spell Enchanter Dragon
function c34128055.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c34128055.mfilter1,c34128055.mfilter2,1,1,true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c34128055.spcon)
	e1:SetOperation(c34128055.spop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--Add Spell/Trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60681103,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c34128055.condition)
	e2:SetCost(c34128055.cost)
	e2:SetOperation(c34128055.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c34128055.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Activate Effect of Spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13093792,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c34128055.etg)
	e4:SetCost(c34128055.ecost)
	e4:SetOperation(c34128055.eop)
	c:RegisterEffect(e4)
	--ADD Effect Addition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c34128055.efcon)
	e5:SetOperation(c34128055.efop)
	c:RegisterEffect(e5)
end

function c34128055.mfilter1(c)
	return c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)
end
function c34128055.mfilter2(c)
	return c:IsLevelAbove(6) and c:IsRace(RACE_SPELLCASTER)
end

function c34128055.spfilter(c,fc)
	return c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c34128055.spfilter2(c,fc)
	return c:IsLevelAbove(6) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c34128055.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c34128055.spfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
		and Duel.IsExistingMatchingCard(c34128055.spfilter2,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c34128055.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c34128055.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,c)
	local g2=Duel.SelectMatchingCard(tp,c34128055.spfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
end

function c34128055.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and e:GetLabel()==1
end
function c34128055.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c34128055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34128055.cfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c34128055.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c34128055.afilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c34128055.operation(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsExistingMatchingCard(c34128055.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c34128055.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c34128055.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

function c34128055.efilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function c34128055.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34128055.efilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95100047,1))
	local g=Duel.SelectMatchingCard(tp,c34128055.efilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(false,true,true)
	c34128055[Duel.GetCurrentChain()]=te
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c34128055.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c34128055[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c34128055.eop(e,tp,eg,ep,ev,re,r,rp)
	local te=c34128055[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function c34128055.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c34128055.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c34128055.unval)
	rc:RegisterEffect(e1,true)
	Duel.RaiseSingleEvent(rc,34128055,e,r,rp,ep,0)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		rc:RegisterEffect(e2,true)
	end
end

function c34128055.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end