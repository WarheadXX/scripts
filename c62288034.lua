--Flaming Catastor
function c62288034.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,62288034)
	e1:SetCondition(c62288034.spcon)
	c:RegisterEffect(e1)
	--Inflict Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62288034,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c62288034.dmcon)
	e2:SetTarget(c62288034.dmtg)
	e2:SetOperation(c62288034.dmop)
	c:RegisterEffect(e2)
end

function c62288034.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c62288034.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c62288034.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c62288034.dmfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c62288034.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and Duel.GetTurnPlayer()~=tp
end
function c62288034.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c62288034.dmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c62288034.dmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c62288034.dmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end


