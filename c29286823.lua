--Phantom Pride Dragon
function c29286823.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c29286823.mfilter1,c29286823.mfilter2,1,1,true)
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c29286823.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c29286823.val)
	c:RegisterEffect(e2)
	--Immune to Traps
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c29286823.efilter)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--ADD Effect Addition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c29286823.efcon)
	e5:SetOperation(c29286823.efop)
	c:RegisterEffect(e5)
end


function c29286823.mfilter1(c)
	return c:IsLevelAbove(4)
end
function c29286823.mfilter2(c)
	return c:IsLevelAbove(4)
end

function c29286823.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c29286823.val(e,c)
	return Duel.GetMatchingGroupCount(c29286823.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
function c29286823.atkfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function c29286823.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end

function c29286823.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c29286823.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	Duel.RaiseSingleEvent(rc,29286823,e,r,rp,ep,0)
	local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(c29286823.damcon)
	e2:SetOperation(c29286823.damop)
	rc:RegisterEffect(e2,true)
	Duel.RaiseSingleEvent(rc,29286823,e,r,rp,ep,0)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		rc:RegisterEffect(e3,true)
	end
end

function c29286823.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsDefensePos()
end
function c29286823.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
