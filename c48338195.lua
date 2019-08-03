--Chaos-Blade Dragon - Envoy of Genesis
function c48338195.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c48338195.mfilter1,c48338195.mfilter2,1,1,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c48338195.splimit)
	c:RegisterEffect(e1)
	--Super Nuke
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60681103,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c48338195.condition)
	e2:SetCost(c48338195.destg)
	e2:SetOperation(c48338195.desop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c48338195.aclimit)
	e3:SetCondition(c48338195.actcon)
	c:RegisterEffect(e3)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72989439,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c48338195.atcon)
	e4:SetOperation(c48338195.atop)
	c:RegisterEffect(e4)
end

function c48338195.mfilter1(c)
	return c:GetLevel()==8 and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_FUSION)
end
function c48338195.mfilter2(c)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK)
end

function c48338195.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c48338195.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c48338195.filter(c,atk)
	return c:IsAttackBelow(atk) and c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c48338195.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c48338195.filter,tp,0,LOCATION_HAND,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c48338195.filter,tp,0,LOCATION_HAND,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c48338195.ctfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function c48338195.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local hg=Duel.GetMatchingGroup(c48338195.filter,tp,0,LOCATION_HAND,c,c:GetAttack())
		Duel.Destroy(hg,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
end

function c48338195.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c48338195.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c48338195.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
		and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c48338195.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
