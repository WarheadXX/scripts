--Swiftblade Behemoth Axe
function c60232433.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c60232433.mfilter1,c60232433.mfilter2,1,1,true)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60232433.regcon)
	e1:SetOperation(c60232433.regop)
	c:RegisterEffect(e1)
	--extra att
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40737112,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c60232433.rmcon)
	e3:SetTarget(c60232433.rmtg)
	e3:SetOperation(c60232433.rmop)
	c:RegisterEffect(e3)
end

function c60232433.mfilter1(c)
    return c:IsSetCard(1000)
	and c:IsType(TYPE_MONSTER)
end
function c60232433.mfilter2(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR)
end

function c60232433.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c60232433.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c60232433.efilter)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end
function c60232433.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function c60232433.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c60232433.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c60232433.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if Duel.Remove(bc,POS_FACEUP,REASON_EFFECT) then
		local g=Duel.SelectMatchingCard(tp,Card.Destructable,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,1,0,0,REASON_EFFECT)
	end
end
