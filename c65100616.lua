--リンク・インフライヤー
--Link In-Flyer
--Scripted by Eerie Code
function c65100616.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65100616,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	-- e1:SetTargetRange(c74997493.cfilter,1)
	e1:SetCountLimit(1,65100616)
	-- e1:SetCondition(c65100616.spcon)
	-- e1:SetOperation(c65100616.spop)
	e1:SetCondition(c65100616.spcon)
	e1:SetValue(c65100616.spval)
	c:RegisterEffect(e1)
end
-- function c74997493.cfilter(c,g)
	-- return POS_FACEUP
-- end
function c65100616.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	-- 
end
function c65100616.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
-- function c65100616.spop(e,tp,eg,ep,ev,re,r,rp,c)
	-- local zone=Duel.GetLinkedZone(tp)
	-- Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
-- end
