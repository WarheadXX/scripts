--Test Wizard
--Scripted by WarheadXX
function c614875521.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(614875521,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	-- e1:SetCountLimit(1,614875521)
	e1:SetCondition(c614875521.spcon)
	e1:SetValue(c614875521.spval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c614875521.descon)
	e2:SetOperation(c614875521.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c614875521.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	-- local zone=1 -- This checks the first MZone, and sees if it is empty
    -- local zone=2 -- This checks the second MZone, and sees if it is empty
    local zone=4 -- This checks the third MZone, and sees if it is empty
	if c:IsAICard() then zone=1 end
	-- local zone=8 -- This checks the fourth MZone, and sees if it is empty
	-- local zone=16 -- This checks the fifth MZone, and sees if it is empty
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	-- 
end
function c614875521.spval(e,c)
    -- local zone=1 -- This Special Summons into the first MZone
    -- local zone=2 -- This Special Summons into the second MZone
    local zone=4 -- This Special Summons into the third MZone
	if c:IsAICard() then zone=1 end
	-- local zone=8 -- This Special Summons into the fourth Mzone
	-- local zone=16 -- This special Summons into the fifth Mzone
	return 0,zone
end

function c614875521.descon(e)
	return e:GetHandler():GetSequence()~=2
end
function c614875521.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end